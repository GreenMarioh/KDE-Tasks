#include "taskscontroller.h"
#include <QDebug>
#include <QDesktopServices>
#include <QUrl>
#include <QUrlQuery>
#include <QOAuthHttpServerReplyHandler> 
#include <QOAuth2AuthorizationCodeFlow>
#include <KWallet> 
#include <QWindow>
#include <QSet>
#include <QMultiMap>
#include <QVariant>

TasksController::TasksController(QObject *parent)
    : QObject(parent),
      m_tasksModel(new TasksModel(this)),
      m_networkManager(new NetworkManager(this)),
      m_googleAuth(new QOAuth2AuthorizationCodeFlow(this))
{
    // 1. Basic OAuth2 setup
    m_googleAuth->setAuthorizationUrl(QUrl(QStringLiteral("https://accounts.google.com/o/oauth2/auth")));
    m_googleAuth->setTokenUrl(QUrl(QStringLiteral("https://oauth2.googleapis.com/token")));
    
    // FIX: Request offline access and consent to ensure we get a refresh token
    connect(m_googleAuth, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, this, [this](const QUrl &url) {
        QUrlQuery query(url);
        query.addQueryItem(QStringLiteral("access_type"), QStringLiteral("offline"));
        query.addQueryItem(QStringLiteral("prompt"), QStringLiteral("consent"));
        QUrl authorizedUrl = url;
        authorizedUrl.setQuery(query);
        QDesktopServices::openUrl(authorizedUrl);
    });

    // FIX: Handle Google's double-encoding bug (Qt 6 QMultiMap)
    m_googleAuth->setModifyParametersFunction([](QAbstractOAuth::Stage stage, auto *parameters) {
        if (stage == QAbstractOAuth::Stage::RequestingAccessToken) {
            const QByteArray code = parameters->value(QStringLiteral("code")).toByteArray();
            parameters->replace(QStringLiteral("code"), QUrl::fromPercentEncoding(code));
        }
    });

    // 2. Load Credentials (Logic is now centralized)
    loadCredentialsFromWallet();

    // 3. Final Validation check for the "Missing client_id" error
    if (m_googleAuth->clientIdentifier().isEmpty()) {
        qWarning() << "CRITICAL ERROR: No Client ID found! Check your .bashrc or KWallet.";
    } else {
        qDebug() << "OAuth initialized with Client ID:" << m_googleAuth->clientIdentifier();
    }

    // 4. Setup Scopes
    QSet<QByteArray> scopes;
    scopes.insert("https://www.googleapis.com/auth/tasks");
    m_googleAuth->setRequestedScopeTokens(scopes);

    // 5. Setup Reply Handler
    auto replyHandler = new QOAuthHttpServerReplyHandler(8080, this);
    m_googleAuth->setReplyHandler(replyHandler);

    // Internal Connections
    connect(m_networkManager, &NetworkManager::tasksFetched, 
            m_tasksModel, &TasksModel::setTasks);

    connect(m_networkManager, &NetworkManager::errorOccurred, this, [](const QString &error){
        qWarning() << "Google Tasks Error:" << error;
    });

    // Handle successful login
    connect(m_googleAuth, &QOAuth2AuthorizationCodeFlow::granted, this, [this]() {
        qDebug() << "Login Successful!";
        m_networkManager->setAccessToken(m_googleAuth->token());
        m_networkManager->fetchTasks();
    });
}

void TasksController::refreshTasks() {
    if (!m_googleAuth->token().isEmpty()) {
        m_networkManager->setAccessToken(m_googleAuth->token());
        m_networkManager->fetchTasks();
    } else {
        authenticate();
    }
}

void TasksController::authenticate() {
    // If we reach here and ID is still empty, the login will fail at Google's end
    if (m_googleAuth->clientIdentifier().isEmpty()) {
        qWarning() << "Cannot authenticate: Client ID is missing.";
        return;
    }
    m_googleAuth->grant();
}

void TasksController::loadCredentialsFromWallet() {
    // Priority 1: Environment Variables (easiest for testing)
    QString clientId = qEnvironmentVariable("GOOGLE_TASKS_CLIENT_ID");
    QString clientSecret = qEnvironmentVariable("GOOGLE_TASKS_CLIENT_SECRET");

    // Priority 2: KWallet (if Environment Variables are empty)
    if (clientId.isEmpty() || clientSecret.isEmpty()) {
        m_wallet = KWallet::Wallet::openWallet(KWallet::Wallet::LocalWallet(), 0);
        if (m_wallet) {
            const QString folder = QStringLiteral("KDE Tasks");
            if (m_wallet->hasFolder(folder)) {
                m_wallet->setFolder(folder);
                QString walletId, walletSecret;
                m_wallet->readPassword(QStringLiteral("clientId"), walletId);
                m_wallet->readPassword(QStringLiteral("clientSecret"), walletSecret);
                
                if (clientId.isEmpty()) clientId = walletId;
                if (clientSecret.isEmpty()) clientSecret = walletSecret;
            }
        }
    }

    // Apply found credentials to the OAuth object
    if (!clientId.isEmpty()) {
        m_googleAuth->setClientIdentifier(clientId);
        m_googleAuth->setClientIdentifierSharedKey(clientSecret);
        
        // If we have a wallet open, make sure these are saved for next time
        if (m_wallet && m_wallet->isOpen()) {
            const QString folder = QStringLiteral("KDE Tasks");
            if (!m_wallet->hasFolder(folder)) m_wallet->createFolder(folder);
            m_wallet->setFolder(folder);
            m_wallet->writePassword(QStringLiteral("clientId"), clientId);
            m_wallet->writePassword(QStringLiteral("clientSecret"), clientSecret);
        }
    }
}