find_package(Git REQUIRED)
message("${CMAKE_BUILD_TYPE}")
SET(GTEST_PREFIX_DIR    ${CMAKE_CURRENT_BINARY_DIR}/gtest)
SET(GTEST_SOURCE_DIR    ${CMAKE_CURRENT_BINARY_DIR}/gtest/src/extern_gtest)
SET(GTEST_INSTALL_DIR   ${CMAKE_CURRENT_BINARY_DIR}/install/gtest)
SET(GTEST_INCLUDE_DIR   "${GTEST_INSTALL_DIR}/include" CACHE PATH "gtest include directory." FORCE)
set(GTEST_REPOSITORY     https://github.com/google/googletest.git)
set(GTEST_TAG            release-1.8.1)
INCLUDE_DIRECTORIES(${GTEST_INCLUDE_DIR})
IF(WIN32)
    # if use CMAKE_INSTALL_LIBDIR, the path of lib actually is install/gtest/lib/gtest.lib but GTEST_LIBRARIES 
    # is install/gtest/gtest.lib
    set(GTEST_LIBRARIES
        "${GTEST_INSTALL_DIR}/lib/gtest.lib" CACHE FILEPATH "gtest libraries." FORCE)
    set(GTEST_MAIN_LIBRARIES
        "${GTEST_INSTALL_DIR}/lib/gtest_main.lib" CACHE FILEPATH "gtest main libraries." FORCE)
ELSE()
    set(GTEST_LIBRARIES
        "${GTEST_INSTALL_DIR}/${CMAKE_INSTALL_LIBDIR}/libgtest.a" CACHE FILEPATH "gtest libraries." FORCE)
    set(GTEST_MAIN_LIBRARIES
        "${GTEST_INSTALL_DIR}/${CMAKE_INSTALL_LIBDIR}/libgtest_main.a" CACHE FILEPATH "gtest main libraries." FORCE)
ENDIF(WIN32)
ExternalProject_Add(
    extern_gtest
    PREFIX gtest
    GIT_REPOSITORY ${GTEST_REPOSITORY}
    GIT_TAG ${GTEST_TAG}
    DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
    UPDATE_COMMAND  ""
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${GTEST_INSTALL_DIR}
               -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
               -DCMAKE_BUILD_TYPE:STRING=Release
    BUILD_BYPRODUCTS ${GTEST_LIBRARIES}
    BUILD_BYPRODUCTS ${GTEST_MAIN_LIBRARIES}
)

ADD_LIBRARY(thirdparty_gtest STATIC IMPORTED GLOBAL)
SET_PROPERTY(TARGET thirdparty_gtest PROPERTY IMPORTED_LOCATION ${GTEST_LIBRARIES})
ADD_DEPENDENCIES(thirdparty_gtest extern_gtest)

ADD_LIBRARY(thirdparty_gtest_main STATIC IMPORTED GLOBAL)
SET_PROPERTY(TARGET thirdparty_gtest_main PROPERTY IMPORTED_LOCATION ${GTEST_MAIN_LIBRARIES})
ADD_DEPENDENCIES(thirdparty_gtest_main extern_gtest)
