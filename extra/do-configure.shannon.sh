if [ -z "$BUILD_TYPE" ]; then BUILD_TYPE=DEBUG; fi
if [ -z "$USE_OPENMP" ]; then USE_OPENMP=OFF; fi


EXTRA_ARGS=$@

. ./build.inc

INSTALL_DIR=$HOME/Trilinos/install-for-mini-PIC/$BUILD_TYPE
TRILINOS_HOME=/home/mbetten/Trilinos/Trilinos
TPL_PREFIX=/home/mbetten/Packages/Trilinos/DrekarTPLs
TPL_BASE_DIR=/home/mbetten/TPLS

rm CMakeCache.txt
rm -fr CMakeFiles
CUDA_ARCH="35"

  CUDA_NVCC_FLAGS="-gencode;arch=compute_${CUDA_ARCH},code=sm_${CUDA_ARCH}"
  CUDA_NVCC_FLAGS="${CUDA_NVCC_FLAGS};-Xcompiler;-Wall,-ansi"

  if [ "${BUILD_FLAG}" = "DEBUG" ] ;
  then
    CUDA_NVCC_FLAGS="${CUDA_NVCC_FLAGS};-g"
  else
    CUDA_NVCC_FLAGS="${CUDA_NVCC_FLAGS};-O3"
  fi

echo ${CUDA_NVCC_FLAGS}

cmake \
-D Trilinos_ENABLE_EXPLICIT_INSTANTIATION:BOOL=ON \
-D Trilinos_ENABLE_INSTALL_CMAKE_CONFIG_FILES:BOOL=ON \
-D Trilinos_ENABLE_EXAMPLES:BOOL=OFF \
-D Trilinos_ENABLE_TESTS:BOOL=OFF \
-D Trilinos_ENABLE_ALL_PACKAGES:BOOL=OFF \
-D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
-D Trilinos_ENABLE_Shards:BOOL=ON \
-D Trilinos_ENABLE_Intrepid:BOOL=ON \
-D Trilinos_ENABLE_Teuchos:BOOL=ON \
-D Trilinos_ENABLE_KokkosAlgorithms:BOOL=ON \
-D Trilinos_ENABLE_KokkosCore:BOOL=ON \
-D Trilinos_ENABLE_KokkosContainers:BOOL=ON \
-D Trilinos_ENABLE_KokkosAlgorithms:BOOL=ON \
-D Kokkos_ENABLE_OpenMP:BOOL=${USE_OPENMP} \
-D Kokkos_ENABLE_Pthread:BOOL=${USE_PTHREAD} \
-D TPL_ENABLE_CUDA:BOOL=${USE_CUDA} \
-D Kokkos_ENABLE_Cuda_UVM:BOOL=${USE_CUDA} \
-D TPL_ENABLE_CUSPARSE:BOOL=${USE_CUDA} \
-D Trilinos_ENABLE_Tpetra:BOOL=ON \
-D Tpetra_INST_COMPLEX_FLOAT:BOOL=OFF \
-D Tpetra_INST_COMPLEX_DOUBLE:BOOL=OFF \
\
-D Teuchos_ENABLE_LONG_LONG_INT:BOOL=OFF \
-D CMAKE_C_COMPILER="$MPIHOME/bin/mpicc" \
-D CMAKE_CXX_COMPILER="$MPIHOME/bin/mpicxx" \
-D CMAKE_Fortran_COMPILER="$MPIHOME/bin/mpif77" \
-D CMAKE_CXX_FLAGS:STRING="$COMPILE_FLAGS" \
-D CMAKE_C_FLAGS:STRING="$COMPILE_FLAGS" \
-D CMAKE_SKIP_RULE_DEPENDENCY=ON \
-D TPL_ENABLE_MPI:BOOL=ON \
-D MPI_BASE_DIR:PATH="$MPIHOME" \
-D MPI_BIN_DIR:FILEPATH="$MPIHOME/bin" \
-D MPI_EXEC_MAX_NUMPROCS:STRING=4 \
-D CMAKE_BUILD_TYPE=${BUILD_TYPE} \
-D CMAKE_INSTALL_PREFIX:PATH=${INSTALL_DIR} \
-D TPL_ENABLE_BLAS:BOOL=ON \
-D TPL_ENABLE_LAPACK:BOOL=ON \
-D BLAS_LIBRARY_DIRS:FILEPATH="/opt/intel/mkl/lib/intel64/" \
 -D BLAS_LIBRARY_NAMES="mkl_intel_lp64;mkl_sequential;mkl_core;pthread;m" \
 -D LAPACK_LIBRARY_NAMES="" \
${EXTRA-ARGS} \
${TRILINOS_HOME}

