cmake_minimum_required(VERSION 3.16)

project(kdetasks)

set(KF_MIN_VERSION "6.0.0")
set(QT_MIN_VERSION "6.6.0")

find_package(ECM ${KF_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMQmlModule)  # <--- Add this line
include(ECMQtDeclareLoggingCategory)
include(ECMSetupVersion)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS Core Quick Network NetworkAuth)
find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS I18n CoreAddons)
find_package(Plasma REQUIRED)

add_subdirectory(src)

# Installs the QML/metadata package
plasma_install_package(package org.greenmarioh.kdetasks)