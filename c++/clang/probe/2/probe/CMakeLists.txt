cmake_minimum_required(VERSION 3.2)

add_compile_options(-std=gnu++11)
find_package(LLVM REQUIRED CONFIG)
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

llvm_map_components_to_libnames(llvm_libs all)

add_executable(probe
 probe.cpp
 )

target_link_libraries(probe
  ${llvm_libs}
  clang
  clangBasic
  clangFrontend
  clangTooling
)

