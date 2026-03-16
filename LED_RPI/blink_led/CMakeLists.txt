cmake_minimum_required(VERSION 3.16)

project(blink_led VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.5)

# Create executable with ALL C++ source files
qt_add_executable(appblink_led
    main.cpp
    gpio_27.cpp
    gpio_27.h
    ledcontroller.cpp
    ledcontroller.h
)

# Add QML module - ONLY QML files go here
qt_add_qml_module(appblink_led
    URI blink_led
    VERSION 1.0
    QML_FILES
        qml/Main.qml
)

set_target_properties(appblink_led PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appblink_led PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appblink_led
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
