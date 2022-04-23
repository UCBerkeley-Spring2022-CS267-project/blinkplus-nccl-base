## Common use command

* request 4 GPU interactive on bridge 2
```shell
salloc -N 1 -p GPU-shared --gres=gpu:4 -q interactive
```

* request node como on rise
```shell
srun --nodelist=como -t 60:00 --pty bash
```

* check nvlink connection
```shell
nvidia-smi topo -m
```

## Settings for nccl

```shell
# create config file
touch ~/.nccl.conf

# use level nccl runtime configuration
# nccl will read this file before run
vim ~/.nccl.conf
```

content of the config file
```conf
# DUMP topology
NCCL_TOPO_DUMP_FILE=`pwd`/topo.xml
# use simple proto instead of LL (low latency)
NCCL_PROTO=Simple
# show debug info
NCCL_DEBUG=Info
# debug subsystem
NCCL_DEBUG_SUBSYS=ALL
# choose algo
NCCL_ALGO=Ring
# debug file
NCCL_DEBUG_FILE=`pwd`/debugfile.%h.%p
# save graph file
NCCL_GRAPH_DUMP_FILE=`pwd`/graph.xml
```

## profiling
```shell
# save profile result
/usr/local/cuda-11.5/bin/nvprof -o output.nvvp ./examples/build/demo_group01

# XWindows open remote
ssh -X mengyibai@freddie.millennium.berkeley.edu -i ~/.ssh/id_rsa

# Display
/usr/local/cuda-11.5/bin/nvvp -vm /home/eecs/mengyibai/jdk8u322-b06-jre/bin/java output.nvvp

# visual result
/usr/local/cuda-11.5/bin/nvvp output.nvvp
```