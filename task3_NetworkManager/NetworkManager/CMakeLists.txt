cmake_minimum_required(VERSION 3.16)

project(NetworkManager VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick DBus)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appNetworkManager
    main.cpp
)

qt_add_qml_module(appNetworkManager
    URI NetworkManager
    QML_FILES
        Main.qml
        SOURCES WifiManager.cpp
        SOURCES WifiManager.h
        SOURCES BluetoothManager.h
        SOURCES BluetoothManager.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appNetworkManager PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appNetworkManager
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appNetworkManager
    PRIVATE Qt6::Quick
    PRIVATE Qt6::DBus
)

include(GNUInstallDirs)
install(TARGETS appNetworkManager
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
