# This is boilerplate to use the latest policies available
# Info:
# https://cliutils.gitlab.io/modern-cmake/chapters/basics.html#minimum-version
cmake_minimum_required(VERSION 3.7...3.19)
if ( ${CMAKE_VERSION} VERSION_LESS 3.12 )
    cmake_policy( VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} )
endif()
# End.

project( ycmd
  VERSION 2.0.0
  DESCRIPTION "A code comrehension server"
  LANGUAGES CXX
)

include( CTest )

# All of this project uses c++17 and we certainly don't want random extensions
set( CMAKE_CXX_STANDARD 20 )
set( CMAKE_CXX_EXTENSIONS OFF )
set( CMAKE_CXX_STANDARD_REQUIRED ON )

option( ENABLE_ASAN "Build with address sanitizer" OFF )

# Always generate compilation database
set( CMAKE_EXPORT_COMPILE_COMMANDS ON )

# add the executable
add_subdirectory(core)
add_subdirectory(ycmd)
