# Install script for directory: /home/hjl/projects/argon2-gpu

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libargon2-gpu-common.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libargon2-gpu-common.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/lib/libargon2-gpu-common.so"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/lib/libargon2-gpu-common.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/usr/local/lib" TYPE SHARED_LIBRARY FILES "/home/hjl/projects/argon2-gpu/libargon2-gpu-common.so")
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libargon2-gpu-common.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libargon2-gpu-common.so")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/lib/libargon2-gpu-common.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  include("/home/hjl/projects/argon2-gpu/CMakeFiles/argon2-gpu-common.dir/install-cxx-module-bmi-Release.cmake" OPTIONAL)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libargon2-opencl.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libargon2-opencl.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/lib/libargon2-opencl.so"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/lib/libargon2-opencl.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/usr/local/lib" TYPE SHARED_LIBRARY FILES "/home/hjl/projects/argon2-gpu/libargon2-opencl.so")
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libargon2-opencl.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libargon2-opencl.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/usr/local/lib/libargon2-opencl.so"
         OLD_RPATH "/home/hjl/projects/argon2-gpu:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/lib/libargon2-opencl.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  include("/home/hjl/projects/argon2-gpu/CMakeFiles/argon2-opencl.dir/install-cxx-module-bmi-Release.cmake" OPTIONAL)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libargon2-cuda.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libargon2-cuda.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/lib/libargon2-cuda.so"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/lib/libargon2-cuda.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/usr/local/lib" TYPE SHARED_LIBRARY FILES "/home/hjl/projects/argon2-gpu/libargon2-cuda.so")
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libargon2-cuda.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libargon2-cuda.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/usr/local/lib/libargon2-cuda.so"
         OLD_RPATH "/home/hjl/projects/argon2-gpu:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/lib/libargon2-cuda.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  include("/home/hjl/projects/argon2-gpu/CMakeFiles/argon2-cuda.dir/install-cxx-module-bmi-Release.cmake" OPTIONAL)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/include/argon2-common.h;/usr/local/include/argon2params.h;/usr/local/include/cl.hpp;/usr/local/include/opencl.h;/usr/local/include/device.h;/usr/local/include/globalcontext.h;/usr/local/include/programcontext.h;/usr/local/include/processingunit.h;/usr/local/include/kernelrunner.h;/usr/local/include/cudaexception.h;/usr/local/include/kernels.h;/usr/local/include/device.h;/usr/local/include/globalcontext.h;/usr/local/include/programcontext.h;/usr/local/include/processingunit.h")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/usr/local/include" TYPE FILE FILES
    "/home/hjl/projects/argon2-gpu/include/argon2-gpu-common/argon2-common.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-gpu-common/argon2params.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-opencl/cl.hpp"
    "/home/hjl/projects/argon2-gpu/include/argon2-opencl/opencl.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-opencl/device.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-opencl/globalcontext.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-opencl/programcontext.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-opencl/processingunit.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-opencl/kernelrunner.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-cuda/cudaexception.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-cuda/kernels.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-cuda/device.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-cuda/globalcontext.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-cuda/programcontext.h"
    "/home/hjl/projects/argon2-gpu/include/argon2-cuda/processingunit.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-bench" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-bench")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-bench"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/bin/argon2-gpu-bench")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/usr/local/bin" TYPE EXECUTABLE FILES "/home/hjl/projects/argon2-gpu/argon2-gpu-bench")
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-bench" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-bench")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-bench"
         OLD_RPATH "/home/hjl/projects/argon2-gpu:/home/hjl/projects/argon2-gpu/ext/argon2:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-bench")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  include("/home/hjl/projects/argon2-gpu/CMakeFiles/argon2-gpu-bench.dir/install-cxx-module-bmi-Release.cmake" OPTIONAL)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-test" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-test")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-test"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/bin/argon2-gpu-test")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/usr/local/bin" TYPE EXECUTABLE FILES "/home/hjl/projects/argon2-gpu/argon2-gpu-test")
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-test" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-test")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-test"
         OLD_RPATH "/home/hjl/projects/argon2-gpu:/home/hjl/projects/argon2-gpu/ext/argon2:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/bin/argon2-gpu-test")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  include("/home/hjl/projects/argon2-gpu/CMakeFiles/argon2-gpu-test.dir/install-cxx-module-bmi-Release.cmake" OPTIONAL)
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/hjl/projects/argon2-gpu/ext/argon2/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
  file(WRITE "/home/hjl/projects/argon2-gpu/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
