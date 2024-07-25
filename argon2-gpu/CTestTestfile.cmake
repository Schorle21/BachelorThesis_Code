# CMake generated Testfile for 
# Source directory: /home/hjl/projects/argon2-gpu
# Build directory: /home/hjl/projects/argon2-gpu
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(argon2-gpu-test-opencl "argon2-gpu-test" "-m" "opencl")
set_tests_properties(argon2-gpu-test-opencl PROPERTIES  _BACKTRACE_TRIPLES "/home/hjl/projects/argon2-gpu/CMakeLists.txt;111;add_test;/home/hjl/projects/argon2-gpu/CMakeLists.txt;0;")
add_test(argon2-gpu-test-cuda "argon2-gpu-test" "-m" "cuda")
set_tests_properties(argon2-gpu-test-cuda PROPERTIES  _BACKTRACE_TRIPLES "/home/hjl/projects/argon2-gpu/CMakeLists.txt;112;add_test;/home/hjl/projects/argon2-gpu/CMakeLists.txt;0;")
subdirs("ext/argon2")
