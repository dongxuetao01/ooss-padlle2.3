if(WITH_GPU)
  nv_library(
    phi_place
    SRCS place.cc
    DEPS phi_gpu_info)
elseif(WITH_ROCM)
  hip_library(
    phi_place
    SRCS place.cc
    DEPS phi_gpu_info)
else()
  cc_library(phi_place SRCS place.cc)
endif()

cc_library(
  scalar
  SRCS scalar.cc
  DEPS phi_enforce tensor)
