cmake_minimum_required(VERSION 3.0 )

# project name
project( nccl_example LANGUAGES CXX CUDA )
message(STATUS "CMAKE_CUDA_COMPILER ${CMAKE_CUDA_COMPILER}")

# find nccl
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/)

# exec
add_executable( demo demo.cu  )

# nccl
find_package(nccl REQUIRED)
if ( NCCL_FOUND )
    message(STATUS "NCCL found ${NCCL_INCLUDE_DIRS} ${NCCL_LIBRARIES}")
else()
    message(STATUS "NCCL not found")
endif()

# header
include_directories( ${NCCL_INCLUDE_DIRS} )

# I'm using C++17 in the test
target_compile_features(demo PRIVATE cxx_std_11)

# link nccl
target_link_libraries( demo PRIVATE ${NCCL_LIBRARIES} )
