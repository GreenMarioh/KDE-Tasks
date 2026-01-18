# Install script for directory: /home/mohnish/github/KDE-Tasks/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "kdetasks" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so"
         RPATH "\$ORIGIN/../../../../lib")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks" TYPE MODULE FILES "/home/mohnish/github/KDE-Tasks/build/bin/org/greenmarioh/kdetasks/libkdetasksplugin.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so"
         OLD_RPATH ":::::::::::::::::::::::"
         NEW_RPATH "\$ORIGIN/../../../../lib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "kdetasks" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks" TYPE FILE FILES "/home/mohnish/github/KDE-Tasks/build/bin/org/greenmarioh/kdetasks/qmldir")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "kdetasks" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks" TYPE FILE FILES "/home/mohnish/github/KDE-Tasks/build/bin/org/greenmarioh/kdetasks/kdetasksplugin.qmltypes")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "kdetasks" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks" TYPE FILE RENAME "kde-qmlmodule.version" FILES "/home/mohnish/github/KDE-Tasks/build/src/kdetasksplugin-kde-qmlmodule.version")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "kdetasks" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so"
         RPATH "\$ORIGIN/../../../../lib")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks" TYPE MODULE FILES "/home/mohnish/github/KDE-Tasks/build/bin/org/greenmarioh/kdetasks/libkdetasksplugin.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so"
         OLD_RPATH ":::::::::::::::::::::::"
         NEW_RPATH "\$ORIGIN/../../../../lib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks/libkdetasksplugin.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "kdetasks" OR NOT CMAKE_INSTALL_COMPONENT)
  include("/home/mohnish/github/KDE-Tasks/build/src/CMakeFiles/kdetasksplugin.dir/install-cxx-module-bmi-Debug.cmake" OPTIONAL)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "kdetasks" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/qt6/qml/org/greenmarioh/kdetasks" TYPE FILE FILES "/home/mohnish/github/KDE-Tasks/build/src/qmldir")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/home/mohnish/github/KDE-Tasks/build/src/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
