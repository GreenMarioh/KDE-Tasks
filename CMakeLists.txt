cmake_minimum_required(VERSION 3.16)

project(kdetasks)

set(KF_MIN_VERSION "6.0.0")
set(QT_MIN_VERSION "6.6.0")

# 1. Setup ECM
find_package(ECM ${KF_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMQmlModule)
include(ECMQtDeclareLoggingCategory)
include(ECMSetupVersion)

# 2. Find Dependencies (Consolidated to KF6)
find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS Core Quick Network NetworkAuth)
find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS I18n CoreAddons Wallet)
find_package(Plasma REQUIRED)

# 3. Add source directory
add_subdirectory(src)

# 4. Install metadata
plasma_install_package(package org.greenmarioh.kdetasks)