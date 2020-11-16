include_directories(${Qt5Widgets_INCLUDE_DIRS} ${QtQml_INCLUDE_DIRS})

add_definitions(${Qt5Widgets_DEFINITIONS} ${QtQml_DEFINITIONS} ${${Qt5Quick_DEFINITIONS}})
qt5_add_resources(QT_RESOURCES qml.qrc)
make_qt_executable()

target_precompile_headers(${PROJECT_NAME}
    PRIVATE
    "pch.h"
    )

target_link_libraries(${PROJECT_NAME}
    Qt5::Widgets
    Qt5::Qml
    Qt5::Quick
    )
