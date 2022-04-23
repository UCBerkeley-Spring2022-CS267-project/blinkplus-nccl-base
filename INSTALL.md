## Compile

```shell
# get cuda home
# only get valid CUDA_HOME under interactive node
# build you can use below CUDA_HOME when not under interactive node
echo $CUDA_HOME
> /jet/packages/spack/opt/spack/linux-centos8-zen/gcc-8.3.1/cuda-11.1.1-a6ajxenobex5bvpejykhtnfut4arfpwh
echo $CUDA_HOME
> /usr/local/cuda-11.4
> /usr/local/cuda-11.5 # recommended
> /usr/local/cuda-11.6

# build V100 use sm_70
# NOTE: if you are using different platform, change the sm_ compute_ to your target
# reference https://arnon.dk/tag/nvcc-flags/

# build with trace and debug on rise
make -j 60 src.build CUDA_HOME="/usr/local/cuda-11.5" NVCC_GENCODE="-gencode=arch=compute_70,code=sm_70" TRACE=1 DEBUG=1

# build with trace and debug on bridge
make -j 80 src.build CUDA_HOME="/jet/packages/spack/opt/spack/linux-centos8-zen/gcc-8.3.1/cuda-11.1.1-a6ajxenobex5bvpejykhtnfut4arfpwh" NVCC_GENCODE="-gencode=arch=compute_70,code=sm_70" TRACE=1 DEBUG=1

# export env variable for cmake build
# under nccl root directory
export NCCL_ROOT_DIR=`pwd`/build

# export env variable for nccl-test
# under nccl root directory
export NCCL_HOME=`pwd`/build/
export LD_LIBRARY_PATH=`pwd`/build/lib:$LD_LIBRARY_PATH 

# Export graph file path
# under nccl root directory
export NCCL_GRAPH_FILE_CHAIN_01=`pwd`/chain01.xml
export NCCL_GRAPH_FILE_CHAIN_021=`pwd`/chain021.xml
export NCCL_GRAPH_FILE_CHAIN_031=`pwd`/chain031.xml
export NCCL_GRAPH_FILE_CHAIN_0321=`pwd`/chain0321.xml
export NCCL_GRAPH_FILE_CHAIN_0123=`pwd`/chain0123.xml

# validate export
echo $NCCL_ROOT_DIR
echo $NCCL_HOME
echo $LD_LIBRARY_PATH
echo $NCCL_GRAPH_FILE_CHAIN_01
echo $NCCL_GRAPH_FILE_CHAIN_021
echo $NCCL_GRAPH_FILE_CHAIN_031
echo $NCCL_GRAPH_FILE_CHAIN_0321
echo $NCCL_GRAPH_FILE_CHAIN_0123
```

## Common use env var
```shell
# show debug info
export NCCL_DEBUG=Info
# debug subsystem
export NCCL_DEBUG_SUBSYS=ALL
# choose algo
export NCCL_ALGO=Ring
```