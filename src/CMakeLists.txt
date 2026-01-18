# 1. Update the source list to match your actual filenames
# Note: Removed the 's' from taskmodel and tasksplugin to match your screenshot
set(kdetasks_SRCS
    taskplugin.cpp
    taskmodel.cpp
    taskscontroller.cpp
    networkmanager.cpp
)

# 2. Define the QML module
ecm_add_qml_module(kdetasksplugin
    URI "org.greenmarioh.kdetasks"
    GENERATE_PLUGIN_SOURCE
    SOURCES ${kdetasks_SRCS}
)

# 3. Add NetworkAuth for the Google login flow
target_link_libraries(kdetasksplugin
    PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Network
    Qt6::NetworkAuth
    KF6::I18n
)

# 4. Finalize the module (Generates the necessary qmldir and type info)
ecm_finalize_qml_module(kdetasksplugin)

# 5. Install the library AND the module metadata
install(TARGETS kdetasksplugin
    DESTINATION ${KDE_INSTALL_QMLDIR}/org/greenmarioh/kdetasks
)

# Explicitly install the generated qmldir file
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/qmldir
    DESTINATION ${KDE_INSTALL_QMLDIR}/org/greenmarioh/kdetasks
)