# CMake generated Testfile for 
# Source directory: /home/mohnish/github/KDE-Tasks
# Build directory: /home/mohnish/github/KDE-Tasks
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(appstreamtest "/usr/bin/cmake" "-DAPPSTREAMCLI=/usr/bin/appstreamcli" "-DINSTALL_FILES=/home/mohnish/github/KDE-Tasks/install_manifest.txt" "-P" "/usr/share/ECM/kde-modules/appstreamtest.cmake")
set_tests_properties(appstreamtest PROPERTIES  _BACKTRACE_TRIPLES "/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;173;add_test;/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;191;appstreamtest;/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;0;;/home/mohnish/github/KDE-Tasks/CMakeLists.txt;13;include;/home/mohnish/github/KDE-Tasks/CMakeLists.txt;0;")
subdirs("src")
