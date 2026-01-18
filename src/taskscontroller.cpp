#include "taskscontroller.h"
#include <QDebug>
#include <QDesktopServices>
#include <QUrl>
#include <QOAuthHttpServerReplyHandler> 
#include <QOAuth2AuthorizationCodeFlow>
#include <KWallet/Wallet>
#include <QWindow>

TasksController::TasksController(QObject *parent)
    : QObject(parent),
      m_tasksModel(new TasksModel(this)),
      m_networkManager(new NetworkManager(this)),
      m_googleAuth(new QOAuth2AuthorizationCodeFlow(this))
{
    m_googleAuth->setAuthorizationUrl(QUrl(QStringLiteral("https://accounts.google.com/o/oauth2/auth")));
    m_googleAuth->setAccessTokenUrl(QUrl(QStringLiteral("https://oauth2.googleapis.com/token")));

    loadCredentialsFromWallet();
    
    // FETCH FROM ENVIRONMENT VARIABLES
    const QString clientId = qEnvironmentVariable("GOOGLE_TASKS_CLIENT_ID");
    const QString clientSecret = qEnvironmentVariable("GOOGLE_TASKS_CLIENT_SECRET");

    if (clientId.isEmpty() || clientSecret.isEmpty()) {
        qWarning() << "Warning: GOOGLE_TASKS_CLIENT_ID or GOOGLE_TASKS_CLIENT_SECRET not set in environment!";
    }

    m_googleAuth->setClientIdentifier(clientId);
    m_googleAuth->setClientIdentifierSharedKey(clientSecret);
    
    m_googleAuth->setScope(QStringLiteral("https://www.googleapis.com/auth/tasks"));

    auto replyHandler = new QOAuthHttpServerReplyHandler(8080, this);
    m_googleAuth->setReplyHandler(replyHandler);

    // Internal Connections
    connect(m_networkManager, &NetworkManager::tasksFetched, 
            m_tasksModel, &TasksModel::setTasks);

    connect(m_networkManager, &NetworkManager::errorOccurred, this, [](const QString &error){
        qWarning() << "Google Tasks Error:" << error;
    });

    // OAuth Connections
    connect(m_googleAuth, &QOAuth2AuthorizationCodeFlow::granted, this, [this]() {
        m_networkManager->setAccessToken(m_googleAuth->token());
        m_networkManager->fetchTasks();
    });

    connect(m_googleAuth, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, &QDesktopServices::openUrl);
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
    m_googleAuth->grant();
}

void TasksController::loadCredentialsFromWallet() {
    // 1. Open the local wallet synchronously for simplicity in this example
    // In a production app, use openWallet(KWallet::Wallet::LocalWallet(), 0, Asynchronous)
    m_wallet = KWallet::Wallet::openWallet(KWallet::Wallet::LocalWallet(), 0);

    if (m_wallet) {
        const QString folder = QStringLiteral("KDE Tasks");
        
        // Ensure our folder exists
        if (!m_wallet->hasFolder(folder)) {
            m_wallet->createFolder(folder);
        }
        m_wallet->setFolder(folder);

        // 2. Try to read entries
        QString clientId = m_wallet->readPassword(QStringLiteral("clientId"));
        QString clientSecret = m_wallet->readPassword(QStringLiteral("clientSecret"));

        // 3. Fallback: If wallet is empty, check Environment Variables
        if (clientId.isEmpty()) {
            clientId = qEnvironmentVariable("GOOGLE_TASKS_CLIENT_ID");
            if (!clientId.isEmpty()) {
                m_wallet->writePassword(QStringLiteral("clientId"), clientId);
            }
        }
        
        if (clientSecret.isEmpty()) {
            clientSecret = qEnvironmentVariable("GOOGLE_TASKS_CLIENT_SECRET");
            if (!clientSecret.isEmpty()) {
                m_wallet->writePassword(QStringLiteral("clientSecret"), clientSecret);
            }
        }

        // 4. Apply to Auth Flow
        m_googleAuth->setClientIdentifier(clientId);
        m_googleAuth->setClientIdentifierSharedKey(clientSecret);
    }
}