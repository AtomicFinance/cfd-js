project(external_download NONE)

include(../cmake/EnableCcache.cmake)
include(../cmake/ConvertSrclistFunction.cmake)

# env check
if($ENV{CFD_CMAKE_GIT_SSH})
if($ENV{CFD_CMAKE_GIT_SSH} STREQUAL "1")
set(USE_GIT_SSH   ON)
else()
set(USE_GIT_SSH   OFF)
endif()
else()
set(USE_GIT_SSH   OFF)
endif()

if($ENV{CFD_CMAKE_GIT_SKIP_UPDATE})
if($ENV{CFD_CMAKE_GIT_SKIP_UPDATE} STREQUAL "1")
set(GIT_SKIP_UPDATE   ON)
else()
set(GIT_SKIP_UPDATE   OFF)
endif()
else()
set(GIT_SKIP_UPDATE   OFF)
endif()

set(CFDJSAPI_CONFIG_FILE  "${CMAKE_CURRENT_SOURCE_DIR}/../wrap_js/dl_lib/cmake/cfdjs_api-config.cmake")
if(EXISTS ${CFDJSAPI_CONFIG_FILE})
set(CFDJS_API_INSTALLED   TRUE)
else()
include(FindPackageHandleStandardArgs)
find_package(cfdjs_api   CONFIG
  HINTS "${CMAKE_CURRENT_SOURCE_DIR}/../wrap_js/dl_lib" "${CMAKE_CURRENT_SOURCE_DIR}/../wrap_js/dl_lib/cmake")
find_package_handle_standard_args(cfdjs_api  CONFIG_MODE)
if((NOT cfdjs_api_FOUND) OR (NOT ${cfdjs_api_FOUND}))
set(CFDJS_API_INSTALLED   FALSE)
else()
set(CFDJS_API_INSTALLED   TRUE)
endif()  # find_package
endif()

find_package(univalue QUIET CONFIG)
find_package(wally  QUIET CONFIG)
find_package(cfdcore  QUIET CONFIG)
find_package(cfd  QUIET CONFIG)
if((NOT CFDJS_API_INSTALLED) OR (NOT cfd_FOUND) OR (NOT ${cfd_FOUND}) OR (NOT cfdcore_FOUND) OR (NOT ${cfdcore_FOUND}))
# load and compile libwally
else()
set(EXCLUDE_GENERATE_WALLY ON CACHE BOOL "" FORCE)
endif()

# load file
set(EXTERNAL_LOCAL_FILENAME  local_resource/external_project_local_setting.config)
set(LOCAL_VERSION_FILE  ${CMAKE_SOURCE_DIR}/${EXTERNAL_LOCAL_FILENAME})
if(EXISTS ${LOCAL_VERSION_FILE})
transform_makefile_srclist(${LOCAL_VERSION_FILE} "${CMAKE_CURRENT_BINARY_DIR}/${EXTERNAL_LOCAL_FILENAME}.cmake")
include(${CMAKE_CURRENT_BINARY_DIR}/${EXTERNAL_LOCAL_FILENAME}.cmake)
endif()

# load current repository file
set(LOCAL_CURRENT_VERSION_FILE  ${CMAKE_CURRENT_SOURCE_DIR}/../${EXTERNAL_LOCAL_FILENAME})
set(EXTERNAL_LOCAL_CURRENT_FILENAME  local_resource/external_project_local_setting2.config)
if((NOT CFD_TARGET_VERSION) AND (NOT CFD_TARGET_URL) AND (EXISTS ${LOCAL_CURRENT_VERSION_FILE}))
transform_makefile_srclist(${LOCAL_CURRENT_VERSION_FILE} "${CMAKE_CURRENT_BINARY_DIR}/${EXTERNAL_LOCAL_CURRENT_FILENAME}.cmake")
include(${CMAKE_CURRENT_BINARY_DIR}/${EXTERNAL_LOCAL_CURRENT_FILENAME}.cmake)
message(STATUS "[external project local] load current cfd-js file")
endif()


if(NOT CFDJS_API_INSTALLED)

# cfd
if(CFD_TARGET_VERSION)
set(CFD_TARGET_TAG  ${CFD_TARGET_VERSION})
message(STATUS "[external project local] cfd target=${CFD_TARGET_VERSION}")
else()
set(CFD_TARGET_TAG  v0.3.28)
endif()
if(CFD_TARGET_URL)
set(CFD_TARGET_REP  ${CFD_TARGET_URL})
message(STATUS "[external project local] cfd url=${CFD_TARGET_URL}")
else()
set(CFD_TARGET_REP  atomicfinance/cfd.git)
endif()

if(${USE_GIT_SSH})
set(CFD_URL  git@github.com:${CFD_TARGET_REP})
else()
set(CFD_URL  https://github.com/${CFD_TARGET_REP})
endif()

set(TEMPLATE_PROJECT_NAME           cfd)
set(TEMPLATE_PROJECT_GIT_REPOSITORY ${CFD_URL})
set(TEMPLATE_PROJECT_GIT_TAG        ${CFD_TARGET_TAG})
set(PROJECT_EXTERNAL  "${CMAKE_SOURCE_DIR}/external/${TEMPLATE_PROJECT_NAME}/external")
set(DIR_PATH "${CFD_ROOT_BINARY_DIR}/${TEMPLATE_PROJECT_NAME}")
set(DL_PATH "${CFD_ROOT_BINARY_DIR}/external/${TEMPLATE_PROJECT_NAME}/download")

get_property(PROP_VALUE  GLOBAL  PROPERTY ${TEMPLATE_PROJECT_NAME})
if(PROP_VALUE)
  message(STATUS "[exist directory] ${TEMPLATE_PROJECT_NAME} exist")
else()
configure_file(template_CMakeLists.txt.in ${DL_PATH}/CMakeLists.txt)
execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" -S . -B ${DL_PATH}
  RESULT_VARIABLE result
  WORKING_DIRECTORY ${DL_PATH} )
if(result)
  message(FATAL_ERROR "CMake step for ${TEMPLATE_PROJECT_NAME} failed: ${result}")
endif()
execute_process(COMMAND ${CMAKE_COMMAND} --build ${DL_PATH}
  RESULT_VARIABLE result
  WORKING_DIRECTORY ${DL_PATH} )
if(result)
  message(FATAL_ERROR "Build step for ${TEMPLATE_PROJECT_NAME} failed: ${result}")
endif()
if(EXISTS ${PROJECT_EXTERNAL})
  message(STATUS "[check exist directory] exist ${PROJECT_EXTERNAL}")
  message(STATUS "[check exist directory] dirpath ${DIR_PATH}")
  add_subdirectory(${CMAKE_SOURCE_DIR}/external/${TEMPLATE_PROJECT_NAME}/external
                   ${CFD_ROOT_BINARY_DIR}/external/${TEMPLATE_PROJECT_NAME}/external)
endif()

if((NOT cfd_FOUND) OR (NOT ${cfd_FOUND}))
add_subdirectory(${CMAKE_SOURCE_DIR}/external/${TEMPLATE_PROJECT_NAME}
                 ${DIR_PATH}/build)
else()
message(STATUS "[external project local] use cfd cache")
endif((NOT cfd_FOUND) OR (NOT ${cfd_FOUND}))

set_property(GLOBAL PROPERTY ${TEMPLATE_PROJECT_NAME} 1)
endif()

endif(NOT CFDJS_API_INSTALLED)
