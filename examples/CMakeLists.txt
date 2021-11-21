include( MakeIncludable )

set( CHAR_WIDTH 2 CACHE STRING "Character width" )

set( includable_prefix "" )
if ( CHAR_WIDTH EQUAL 2 )
  set( includable_prefix "L" )
endif()

make_includable(
    LargeFile.h
    ${CMAKE_CURRENT_BINARY_DIR}/generated/LargeFile.h
    "c++-include"
    "${includable_prefix}"
    LARGEFILE_LINECOUNT
    LARGEFILE_SIZE
)
source_group(
    \\generated
    FILES
        ${CMAKE_CURRENT_BINRY_DIR}/generated/LargeFile.h
)

add_executable(
    include-large-file
    include-large-file.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/generated/LargeFile.h
)
target_include_directories(
    include-large-file
    PUBLIC
        ${CMAKE_CURRENT_BINARY_DIR}
)
target_compile_definitions(
    include-large-file
    PUBLIC
        -DCHAR_WIDTH=${CHAR_WIDTH}
        -DLARGEFILE_LINECOUNT=${LARGEFILE_LINECOUNT}
        -DLARGEFILE_SIZE=${LARGEFILE_SIZE}
)
