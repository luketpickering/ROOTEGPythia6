if(NOT COMMAND EnsureVarOrEnvSet)

# If ${OUT_VARNAME} is defined and not empty, this is a no-op
# If ${OUT_VARNAME} is undefiend or empty then first $ENV{${VARNAME}} 
# and then ${${VARNAME}} are checked, if either are defined and non-empty, 
# ${OUT_VARNAME} is set equal to them in the parent scope.
function(EnsureVarOrEnvSet OUT_VARNAME VARNAME)
  set(options UNSET_IS_FATAL)
  cmake_parse_arguments(OPTS 
                      "${options}" 
                      "${oneValueArgs}"
                      "${multiValueArgs}" ${ARGN})

  if(NOT DEFINED ${OUT_VARNAME} OR "${${OUT_VARNAME}}x" STREQUAL "x")
    if(DEFINED ENV{${VARNAME}} AND NOT "$ENV{${VARNAME}}x" STREQUAL "x")
      set(${OUT_VARNAME} $ENV{${VARNAME}} PARENT_SCOPE)
      message(DEBUG "[EnsureVarOrEnvSet] Variable \"${OUT_VARNAME}\" set to the value of environment variable \"${VARNAME}\"=\"$ENV{${VARNAME}}\"")
      return()
    endif()
    if(DEFINED ${VARNAME} AND NOT "${${VARNAME}}x" STREQUAL "x")
      set(${OUT_VARNAME} ${${VARNAME}} PARENT_SCOPE)
      message(DEBUG "[EnsureVarOrEnvSet] Variable \"${OUT_VARNAME}\" set to the value of CMake variable \"${VARNAME}\"=\"${${VARNAME}}\"")
      return()
    endif()
  else()
    message(DEBUG "[EnsureVarOrEnvSet] Variable \"${OUT_VARNAME}\" already set to \"${${OUT_VARNAME}}\"")
    return()
  endif()

  if(OPTS_UNSET_IS_FATAL)
    message(FATAL_ERROR "${OUT_VARNAME} undefined, either configure with -D${VARNAME}=<value> or set ${VARNAME} into the environment")
  else()
    message(DEBUG "[EnsureVarOrEnvSet] Variable \"${OUT_VARNAME}\" is not set as \"${VARNAME}\" is not set in CMake or in the environment.")
    set(${OUT_VARNAME} ${OUT_VARNAME}-NOTFOUND PARENT_SCOPE)
  endif()

endfunction()
endif()

if(NOT TARGET Pythia6::Pythia6)

  EnsureVarOrEnvSet(PYTHIA6 PYTHIA6)
  EnsureVarOrEnvSet(PYTHIA6_ENV_LIB_DIR PYTHIA6_LIB_DIR)
  EnsureVarOrEnvSet(PYTHIA6_LIBRARY PYTHIA6_LIBRARY)

  find_path(PYTHIA6_LIB_DIR
  NAMES libPythia6.so
  PATHS ${PYTHIA6} ${PYTHIA6_ENV_LIB_DIR} ${PYTHIA6_LIBRARY})

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(Pythia6
      REQUIRED_VARS 
        PYTHIA6_LIB_DIR
  )

  if(NOT Pythia6_FOUND)
    return()
  endif()

  message(STATUS "Found Pythia6:")
  message(STATUS "     PYTHIA6_LIB_DIR: ${PYTHIA6_LIB_DIR}")

  add_library(Pythia6::Pythia6 SHARED IMPORTED)
  set_target_properties(Pythia6::Pythia6 PROPERTIES
      IMPORTED_LOCATION ${PYTHIA6_LIB_DIR}/libPythia6.so
    )
endif()
