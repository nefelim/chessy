
if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build, options are: Debug Release" FORCE)
endif ()

set(ROOT "${CMAKE_SOURCE_DIR}/..")
set(OBJ_DIR "${ROOT}/obj")
set(LIB_DIR "${ROOT}/lib/${CMAKE_BUILD_TYPE}")
set(BIN_DIR "${ROOT}/bin/${CMAKE_BUILD_TYPE}")
set(TEST_DIR "${ROOT}/tests/${CMAKE_BUILD_TYPE}")
set(GEN_DIR "${ROOT}/gen/${CMAKE_BUILD_TYPE}")
set(DOCS_DIR "${GEN_DIR}/docs")
set(INSTALL_DIR "${ROOT}/install/${CMAKE_BUILD_TYPE}")

# Installation dir (if using cpack for generating packages)
set(BIN_INSTALL_DIR opt/.${PACKAGE_NAME})
set(LIBS_INSTALL_DIR ${BIN_INSTALL_DIR}/libs/)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${LIB_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${LIB_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${BIN_DIR}")

option(BUILD_TESTING "Build and enable clang-tidy tests" OFF)

if( ${${PACKAGE_NAME}_ENABLE_ARCH_AUTODETECTION} MATCHES ON )
    message("-- Detected host system processor architecture: ${CMAKE_HOST_SYSTEM_PROCESSOR}")
    set(${PACKAGE_NAME}_PRESETUPED_ARCH "${CMAKE_HOST_SYSTEM_PROCESSOR}")
else()
    if(${${PACKAGE_NAME}_PRESETUPED_ARCH} MATCHES "UNKNOWN")
        message(FATAL_ERROR "Presetuped processor architecture isn't set")
    else()
        message("-- Presetuped processor architecture: ${${PACKAGE_NAME}_PRESETUPED_ARCH}")
    endif()
endif()

if("${${PACKAGE_NAME}_PRESETUPED_ARCH}" STREQUAL "i386")
    set(LINUX_AGENT_32 TRUE)
    message(STATUS "LINUX_AGENT_32 is set to TRUE")
else()
    set(LINUX_AGENT_64 TRUE)
    message(STATUS "LINUX_AGENT_64 is set to TRUE")
endif()

macro(make_project_)
    if (NOT DEFINED PROJECT)
        get_filename_component(PROJECT ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    endif ()

    project(${PROJECT})

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror -std=c++17 -fstrict-aliasing -pedantic-errors -pedantic -Wno-deprecated-declarations")

    if (NOT DEFINED HEADERS)
        file(GLOB HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/*.h)
    endif ()

    if (NOT DEFINED SOURCES)
        file(GLOB SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
    endif ()

    source_group("Header Files" FILES ${HEADERS})
    source_group("Source Files" FILES ${SOURCES})
endmacro()

macro(set_qt_env)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${Qt5Widgets_EXECUTABLE_COMPILE_FLAGS}")
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)
    set(CMAKE_AUTOUIC ON)
    IF(CMAKE_BUILD_TYPE MATCHES Debug)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DQT_QML_DEBUG -DQT_DECLARATIVE_DEBUG")
    ENDIF()
endmacro()

macro(make_library)
    make_project_()
    add_library(${PROJECT} STATIC ${HEADERS} ${SOURCES})
    target_include_directories(${PROJECT} INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})

    if (NOT SOURCES)
        set_target_properties(${PROJECT} PROPERTIES LINKER_LANGUAGE CXX)
    endif ()
endmacro()

macro(make_qt_library)
    set_qt_env()
    make_library()
endmacro()

macro(make_executable)
    make_project_()
    add_executable(${PROJECT} ${HEADERS} ${SOURCES})
endmacro()

macro(make_executable_x86)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
    make_project_()
    add_executable(${PROJECT} ${HEADERS} ${SOURCES})
endmacro()

macro(make_qt_executable)
    set_qt_env()
    make_project_()
    add_executable(${PROJECT} ${HEADERS} ${SOURCES} ${QT_RESOURCES})
endmacro()

macro(make_test)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${TEST_DIR}")
    make_executable()

    target_include_directories(${PROJECT} PRIVATE ${GMOCK_INCLUDE_DIRS})
    target_link_libraries(${PROJECT} PRIVATE ${GMOCK_MAIN_LIBRARIES})

    add_test(NAME ${PROJECT}
        COMMAND ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${PROJECT} ${XML_TEST_RESULT_ARG}
        WORKING_DIRECTORY ${TEST_DIR})
endmacro()

function(add_subdirectories)
    if (ARGV)
        set(DIRECTORIES ${ARGV})
    else ()
        set(DIRECTORIES )
        file(GLOB CHILDREN RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*)

        foreach (CHILD ${CHILDREN})
            if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${CHILD})
                set(DIRECTORIES ${DIRECTORIES} ${CHILD})
            endif ()
        endforeach ()
    endif ()

    foreach (DIR ${DIRECTORIES})
        add_subdirectory(${DIR})
    endforeach ()
endfunction()
