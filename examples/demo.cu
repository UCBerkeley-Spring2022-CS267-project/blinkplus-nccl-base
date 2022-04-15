#include <stdio.h>
#include <array>
#include <vector>
#include "cuda_runtime.h"
#include "nccl.h"

#define CUDACHECK(cmd) do {                         \
  cudaError_t e = cmd;                              \
  if( e != cudaSuccess ) {                          \
    printf("Failed: Cuda error %s:%d '%s'\n",             \
        __FILE__,__LINE__,cudaGetErrorString(e));   \
    exit(EXIT_FAILURE);                             \
  }                                                 \
} while(0)


#define NCCLCHECK(cmd) do {                         \
  ncclResult_t r = cmd;                             \
  if (r!= ncclSuccess) {                            \
    printf("Failed, NCCL error %s:%d '%s'\n",             \
        __FILE__,__LINE__,ncclGetErrorString(r));   \
    exit(EXIT_FAILURE);                             \
  }                                                 \
} while(0)


int main(int argc, char* argv[])
{
  printf("Using 3 GPU for test\n"); fflush(stdout);
  // managing 4 devices
  int size = 32*1024*1024;
  const std::vector<int> devs = { 0,1,2,3,4,5,6,7 };
  ncclComm_t comms[devs.size()];

  printf("Allocate send & recv buffer\n"); fflush(stdout);
  // allocating and initializing device buffers
  float** sendbuff = (float**)malloc(devs.size() * sizeof(float*));
  float** recvbuff = (float**)malloc(devs.size() * sizeof(float*));
  cudaStream_t* s = (cudaStream_t*)malloc(sizeof(cudaStream_t)*(devs.size()));

  // Allocate memory
  for ( int i = 0; i < devs.size(); ++i ) 
  {
    CUDACHECK(cudaSetDevice( devs[i] ));
    CUDACHECK(cudaMalloc(sendbuff + i, size * sizeof(float)));
    CUDACHECK(cudaMalloc(recvbuff + i, size * sizeof(float)));
    CUDACHECK(cudaMemset(sendbuff[i], 1, size * sizeof(float)));
    CUDACHECK(cudaMemset(recvbuff[i], 0, size * sizeof(float)));
    CUDACHECK(cudaStreamCreate(s+i));
  }

  //initializing NCCL
  printf("Initial comm\n"); fflush(stdout);
  NCCLCHECK(ncclCommInitAll(comms, devs.size(), devs.data()));

   //calling NCCL communication API. Group API is required when using
   //multiple devices per thread
  printf("Run allreduce\n"); fflush(stdout);
  NCCLCHECK(ncclGroupStart());
  for ( int i = 0; i < devs.size(); ++i ) 
  {
    NCCLCHECK(ncclAllReduce((const void*)sendbuff[i], (void*)recvbuff[i], size, ncclFloat, \
      ncclSum, comms[i], s[i]));
  }
  NCCLCHECK(ncclGroupEnd());


  //synchronizing on CUDA streams to wait for completion of NCCL operation
  for ( int i = 0; i < devs.size(); ++i ) 
  {
    CUDACHECK(cudaSetDevice(devs[i]));
    CUDACHECK(cudaStreamSynchronize(s[i]));
  }

  //free device buffers
  for ( int i = 0; i < devs.size(); ++i )
  {
    CUDACHECK(cudaSetDevice(devs[i]));
    CUDACHECK(cudaFree(sendbuff[i]));
    CUDACHECK(cudaFree(recvbuff[i]));
  }


  //finalizing NCCL
  for ( int i = 0; i < devs.size(); ++i )
  {
      ncclCommDestroy(comms[i]);
  }

  printf("Success \n");
  return 0;
}