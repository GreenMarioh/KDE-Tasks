# KDE-Tasks
Google Tasks integration for the KDE Plasma desktop.

This repo builds a QML plugin and a Plasma widget that:
- Authenticates with Google (OAuth2)
- Fetches your tasks
- Lets you add and complete tasks from the widget

Below is a step-by-step guide to get it running on your machine, including Google Cloud setup and local build/run instructions.

## Prerequisites
You need:
- KDE Plasma (for the widget)
- Qt 6 + KDE Frameworks 6 development packages
- CMake + a C++ compiler
- `plasmoidviewer` (for testing the widget)
- A Google Cloud OAuth client ID/secret

On Arch Linux, the package set typically includes:
- `cmake`
- `qt6-base`
- `qt6-declarative`
- `qt6-networkauth`
- `extra-cmake-modules`
- `kf6-kirigami`
- `kf6-ki18n`
- `kf6-kwallet`
- `plasma-framework`
- `plasma-workspace` (for `plasmoidviewer`)

If you are on another distro, install the equivalent Qt 6 / KF6 / Plasma developer packages.

## 1) Google Cloud Setup
You must create OAuth credentials for the Google Tasks API.

1. Go to Google Cloud Console.
2. Create a new project (or choose an existing one).
3. Enable the **Google Tasks API** for the project.
4. Configure the OAuth consent screen (External is fine for personal use).
5. Create **OAuth Client ID** credentials:
   - Application type: **Desktop app**
   - Authorized redirect URI: **http://localhost:8080/**
6. Copy the **Client ID** and **Client Secret**.

The app uses a local HTTP server on port `8080` for OAuth, so that redirect URI must match.

## 2) Configure Credentials
You can provide credentials via environment variables (recommended for dev), or via KWallet.

### Option A: Environment variables
Create or edit `.env` in the project root:

```bash
QML2_IMPORT_PATH=$PWD/build/bin:$PWD/bin:/usr/lib/qt6/qml:$QML2_IMPORT_PATH
QML_IMPORT_PATH=$QML2_IMPORT_PATH

GOOGLE_TASKS_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_TASKS_CLIENT_SECRET=your-client-secret
```

### Option B: KWallet
If `GOOGLE_TASKS_CLIENT_ID` / `GOOGLE_TASKS_CLIENT_SECRET` are not set, the app will attempt to read them from KWallet under:
- Folder: `KDE Tasks`
- Keys: `clientId`, `clientSecret`

If the values are found, they are reused and stored for future runs.

## 3) Build
From the repository root:

```bash
cmake -S . -B build
cmake --build build
```

This produces the QML plugin at:
`build/bin/org/greenmarioh/kdetasks`

## 4) Run (Standalone UI)
The standalone window is useful for quick testing without Plasma.

```bash
source .env
/usr/lib/qt6/bin/qmlscene standalone.qml
```

If `qmlscene` is not in that path on your system, use the Qt 6 version available in your PATH, or run:

```bash
which qmlscene
qmlscene -v
```

Make sure you are running the **Qt 6** version.

## 5) Run (Plasma Widget)
You can run the widget directly using `plasmoidviewer`:

```bash
source .env
plasmoidviewer -a package
```

If you have an older system-installed plugin that conflicts, ensure `QML2_IMPORT_PATH` points to `build/bin` first as in the `.env` above.

## 6) First Login
1. Click **Sign In**.
2. A browser opens for OAuth.
3. After success, the widget should fetch tasks automatically.
4. Use **Refresh** if you want to force re-fetch.

## Troubleshooting
### The widget loads but buttons do nothing
This usually means the old plugin is being loaded. Ensure:
- `QML2_IMPORT_PATH` includes `build/bin` first
- You rebuilt after code changes

### Tasks fetch succeeds but list is empty
Check that the UI list is visible and that `Loaded tasks: X` at the bottom shows a nonzero count.

### OAuth login opens but doesn’t complete
Make sure the redirect URI is **http://localhost:8080/** and that port `8080` is not blocked.

### `module "org.kde.kirigami" is not installed`
Install Kirigami (Qt 6) and ensure `/usr/lib/qt6/qml` is in your QML import path.

## Project Structure
Key files:
- `src/` – C++ plugin (TasksController, NetworkManager, model)
- `package/` – Plasma widget package
- `standalone.qml` – Standalone window for testing

## Notes
- The OAuth server listens on port 8080.
- The plugin is registered as `org.greenmarioh.kdetasks`.
- The Tasks API scope used: `https://www.googleapis.com/auth/tasks`
