cmake_minimum_required( VERSION 3.0 )
project( cmaketools )

list( APPEND CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules
)
add_subdirectory( CMakeModules )
add_subdirectory( examples )
