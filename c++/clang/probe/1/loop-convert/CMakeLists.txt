#cf. file:///usr/share/doc/llvm/html/CMake.html
cmake_minimum_required(VERSION 3.2)
include(GNUInstallDirs)
# find_package(Boost)

message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "CMAKE_SYSTEM_PREFIX_PATH: ${CMAKE_SYSTEM_PREFIX_PATH}")

add_compile_options(-std=gnu++11)
find_package(LLVM REQUIRED CONFIG)
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

message(STATUS "LLVM_ALL_TARGETS: ${LLVM_ALL_TARGETS}")
message(STATUS "LLVM_AVAILABLE_LIBS: ${LLVM_AVAILABLE_LIBS}")
message(STATUS "LLVM_CMAKE_DIR: ${LLVM_CMAKE_DIR}")
message(STATUS "LLVM_CONSIDERED_CONFIGS: ${LLVM_CONSIDERED_CONFIGS}")
message(STATUS "LLVM_CONSIDERED_VERSIONS: ${LLVM_CONSIDERED_VERSIONS}")
message(STATUS "LLVM_DEFINITIONS: ${LLVM_DEFINITIONS}")
message(STATUS "LLVM_DIR: ${LLVM_DIR}")
message(STATUS "LLVM_ENABLE_ASSERTIONS: ${LLVM_ENABLE_ASSERTIONS}")
message(STATUS "LLVM_ENABLE_EH: ${LLVM_ENABLE_EH}")
message(STATUS "LLVM_ENABLE_PIC: ${LLVM_ENABLE_PIC}")
message(STATUS "LLVM_ENABLE_RTTI: ${LLVM_ENABLE_RTTI}")
message(STATUS "LLVM_ENABLE_TERMINFO: ${LLVM_ENABLE_TERMINFO}")
message(STATUS "LLVM_ENABLE_THREADS: ${LLVM_ENABLE_THREADS}")
message(STATUS "LLVM_ENABLE_ZLIB: ${LLVM_ENABLE_ZLIB}")
message(STATUS "LLVM_INCLUDE_DIRS: ${LLVM_INCLUDE_DIRS}")
message(STATUS "LLVM_INSTALL_PREFIX: ${LLVM_INSTALL_PREFIX}")
message(STATUS "LLVM_LIBRARY_DIRS: ${LLVM_LIBRARY_DIRS}")
message(STATUS "LLVM_NATIVE_ARCH: ${LLVM_NATIVE_ARCH}")
message(STATUS "LLVM_ON_UNIX: ${LLVM_ON_UNIX}")
message(STATUS "LLVM_ON_WIN32: ${LLVM_ON_WIN32}")
message(STATUS "LLVM_PACAKGE_VERSION: ${LLVM_PACKAGE_VERSION}")
message(STATUS "LLVM_TARGETS_TO_BUILD: ${LLVM_TARGETS_TO_BUILD}")
message(STATUS "LLVM_TARGETS_WITH_JIT: ${LLVM_TARGETS_WITH_JIT}")
message(STATUS "LLVM_TOOLS_BINARY_DIR: ${LLVM_TOOLS_BINARY_DIR}")
message(STATUS "LLVM_VERSION: ${LLVM_VERSION}")
message(STATUS "LLVM_VERSION_COUNT: ${LLVM_VERSION_COUNT}")
message(STATUS "LLVM_VERSION_MAJOR: ${LLVM_VERSION_MAJOR}")
message(STATUS "LLVM_VERSION_MINOR: ${LLVM_VERSION_MINOR}")
message(STATUS "LLVM_VERSION_PATCH: ${LLVM_VERSION_PATCH}")
message(STATUS "LLVM_VERSION_TWEAK: ${LLVM_VERSION_TWEAK}")
message(STATUS "TARGET_TRIPLE: ${TARGET_TRIPLE}")

 llvm_map_components_to_libnames(llvm_libs support)
# message(STATUS "llvm_libs: ${llvm_libs}")

# list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
# include(AddLLVM)

#set(LLVM_LINK_COMPONENTS all)
#set(LLVM_USED_LIBS
#  clangARCMigrate
#  clangAST
#  clangASTMatchers
#  clangAnalysis
#  clangBasic
#  clangCodeGen
#  clangDriver
#  clangDynamicASTMatchers
#  clangEdit
#  clangFormat
#  clangFrontend
#  clangFrontendTool
#  clangIndex
#  clangLex
#  clangParse
#  clangRewrite
#  clangRewriteFrontend
#  clangSema
#  clangSerialization
#  clangStaticAnalyzerCheckers
#  clangStaticAnalyzerCore
#  clangStaticAnalyzerFrontend
#  clangTooling
#  clangToolingCore
#)

# set(LLVM_RUNTIME_OUTPUT_INTDIR ".")
# set(LLVM_LIBRARY_OUTPUT_INTDIR ".")

add_executable(loop-convert
 LoopConvert.cpp
 )
target_link_libraries(loop-convert
  ${llvm_libs}
  LLVM-${LLVM_PACKAGE_VERSION}
  LTO
  clang
  clangARCMigrate
  clangAST
  clangASTMatchers
  clangAnalysis
  clangBasic
  clangCodeGen
  clangDriver
  clangDynamicASTMatchers
  clangEdit
  clangFormat
  clangFrontend
  clangFrontendTool
  clangIndex
  clangLex
  clangParse
  clangRewrite
  clangRewriteFrontend
  clangSema
  clangSerialization
  clangStaticAnalyzerCheckers
  clangStaticAnalyzerCore
  clangStaticAnalyzerFrontend
  clangTooling
  clangToolingCore
)
