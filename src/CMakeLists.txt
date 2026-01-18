set(kdetasks_SRCS
    taskplugin.cpp
    taskmodel.cpp
    taskscontroller.cpp
    networkmanager.cpp
)

# Define the QML module without auto-generating a plugin class
ecm_add_qml_module(kdetasksplugin
    URI "org.greenmarioh.kdetasks"
    SOURCES ${kdetasks_SRCS}
)

target_link_libraries(kdetasksplugin
    PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Network
    Qt6::NetworkAuth
    KF6::I18n
)

ecm_finalize_qml_module(kdetasksplugin)

install(TARGETS kdetasksplugin
    DESTINATION ${KDE_INSTALL_QMLDIR}/org/greenmarioh/kdetasks
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/qmldir
    DESTINATION ${KDE_INSTALL_QMLDIR}/org/greenmarioh/kdetasks
)