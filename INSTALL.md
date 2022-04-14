## Compile

```shell
# get cuda home
echo $CUDA_HOME
> /jet/packages/spack/opt/spack/linux-centos8-zen/gcc-8.3.1/cuda-11.1.1-a6ajxenobex5bvpejykhtnfut4arfpwh

# build bridge 2 use sm_60
make src.build CUDA_HOME="/jet/packages/spack/opt/spack/linux-centos8-zen/gcc-8.3.1/cuda-11.1.1-a6ajxenobex5bvpejykhtnfut4arfpwh" NVCC_GENCODE="-gencode=arch=compute_60,code=sm_60"

make src.build NVCC_GENCODE="-gencode=arch=compute_60,code=sm_60"

# export env variable for build
# under nccl root directory
export NCCL_ROOT_DIR=`pwd`/build
```