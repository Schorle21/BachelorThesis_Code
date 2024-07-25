cmake_minimum_required(VERSION 3.10)
project(CudaSHA256Project)



# Specify CUDA architecture (optional)
# For example, use arch=sm_75 for RTX 2070, adjust based on your GPU
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS};
        -std=c++11;-O3;--ptxas-options=-v;-arch sm_89;-lineinfo
    )

# Add executable
cuda_add_executable(sha256_cuda main.cpp sha256.cu)
