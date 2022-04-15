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
NCCL_TOPO_DUMP_FILE=/jet/home/xiaosx/cs267/nccl/topo.xml
# use simple proto instead of LL (low latency)
NCCL_PROTO=Simple
# show debug info
NCCL_DEBUG=Info
# choose algo
NCCL_ALGO=Ring
# debug file
NCCL_DEBUG_FILE=/jet/home/xiaosx/cs267/nccl-BLINKplus/debugfile.%h.%p
```