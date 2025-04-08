cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

project(ROOTEGPythia6 VERSION 1.0.0 LANGUAGES CXX C)

option(ROOTEGPythia6_Pythia6_BUILTIN "Whether to build Pythia6" ON)

#Changes default install path to be a subdirectory of the build dir.
#Can set build dir at configure time with -DCMAKE_INSTALL_PREFIX=/install/path
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set (CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/${CMAKE_SYSTEM_NAME}/"
           CACHE PATH "default install path" FORCE)
endif()

if(CMAKE_BUILD_TYPE STREQUAL "")
  set(CMAKE_BUILD_TYPE RELWITHDEBINFO)
elseif(NOT DEFINED CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE RELWITHDEBINFO)
endif()

LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake/Modules)

######################### Dependencies

find_package(ROOT 6 REQUIRED)

if(ROOTEGPythia6_Pythia6_BUILTIN)
  enable_language(Fortran)

  add_library(Pythia6 SHARED 
    pythia6/pythia6428.f
    pythia6/pythia6_common_address.c
    pythia6/tpythia6_called_from_cc.F)

  set_source_files_properties(pythia6/tpythia6_called_from_cc.F PROPERTIES COMPILE_FLAGS -fno-second-underscore)
  target_compile_options(Pythia6 PRIVATE -march=native)

  add_library(Pythia6::Pythia6 ALIAS Pythia6)

  install(TARGETS Pythia6
      EXPORT ROOTEGPythia6-targets
      LIBRARY DESTINATION lib 
      ARCHIVE DESTINATION lib)
else()
  find_package(Pythia6 REQUIRED)
endif()

ROOT_GENERATE_DICTIONARY(TPythia6
              ${CMAKE_CURRENT_LIST_DIR}/inc/TMCParticle.h
              ${CMAKE_CURRENT_LIST_DIR}/inc/TPythia6.h
              ${CMAKE_CURRENT_LIST_DIR}/inc/TPythia6Decayer.h
              LINKDEF ${CMAKE_CURRENT_LIST_DIR}/inc/LinkDef.h
              OPTIONS -p)

add_library(EGPythia6 SHARED 
              TPythia6.cxx
              ${CMAKE_CURRENT_LIST_DIR}/src/TMCParticle.cxx
              ${CMAKE_CURRENT_LIST_DIR}/src/TPythia6.cxx
              ${CMAKE_CURRENT_LIST_DIR}/src/TPythia6Decayer.cxx)

add_library(ROOT::EGPythia6 ALIAS EGPythia6)

target_link_libraries(EGPythia6 PUBLIC ROOT::EG Pythia6::Pythia6)
target_include_directories(EGPythia6 PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/inc>
  $<INSTALL_INTERFACE:include>)

set_target_properties(EGPythia6 PROPERTIES 
  PUBLIC_HEADER "inc/TMCParticle.h;inc/TPythia6.h;inc/TPythia6Decayer.h;inc/TPythia6Calls.h")

install(TARGETS EGPythia6
      EXPORT ROOTEGPythia6-targets
      LIBRARY DESTINATION lib 
      ARCHIVE DESTINATION lib 
      PUBLIC_HEADER DESTINATION include)

install(FILES 
    ${CMAKE_CURRENT_BINARY_DIR}/libTPythia6.rootmap 
    ${CMAKE_CURRENT_BINARY_DIR}/libTPythia6_rdict.pcm 
  DESTINATION lib)

install(EXPORT ROOTEGPythia6-targets
  FILE ROOTEGPythia6Targets.cmake
  NAMESPACE ROOT::
  DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake/ROOTEGPythia6
)

include(CMakePackageConfigHelpers)
configure_package_config_file(
  ${CMAKE_CURRENT_LIST_DIR}/cmake/Templates/ROOTEGPythia6Config.cmake.in 
  ${CMAKE_BINARY_DIR}/ROOTEGPythia6Config.cmake
  INSTALL_DESTINATION 
    /this/is/ignored/for/some/reason/thanks/kitware
  NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO)

write_basic_package_version_file(
  ${CMAKE_BINARY_DIR}/ROOTEGPythia6ConfigVersion.cmake
  VERSION ${ROOTEGPythia6_VERSION}
  COMPATIBILITY AnyNewerVersion)

install(FILES 
    ${CMAKE_BINARY_DIR}/ROOTEGPythia6Config.cmake 
    ${CMAKE_BINARY_DIR}/ROOTEGPythia6ConfigVersion.cmake 
  DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake/ROOTEGPythia6)

configure_file(${CMAKE_CURRENT_LIST_DIR}/cmake/Templates/ROOTEGPythia6-config.in
  "${PROJECT_BINARY_DIR}/ROOTEGPythia6-config" @ONLY)
install(PROGRAMS
  "${PROJECT_BINARY_DIR}/ROOTEGPythia6-config" DESTINATION bin)