#ifndef KALDI_CUDA_MATRIX_COMMON_H_
#define KALDI_CUDA_MATRIX_COMMON_H_

// This file contains some #includes, forward declarations
// and typedefs that are needed by all the main header
// files in this directory.

#include "base/kaldi-common.h"
#include "matrix/kaldi-blas.h"
#include "cudamatrix/cu-device.h"
#include "cudamatrix/cu-common.h"

namespace kaldi {
  
  cublasOperation_t KaldiTransToCuTrans(MatrixTransposeType kaldi_trans) {
    cublasOperation_t cublas_trans;

    if (kaldi_trans == kNoTrans)
      cublas_trans = CUBLAS_OP_N;
    else if (kaldi_trans == kTrans)
      cublas_trans = CUBLAS_OP_T;
    else
      cublas_trans = CUBLAS_OP_C;
    return cublas_trans;
  }
} // namespace



#endif  // KALDI_CUDA_MATRIX_COMMON_H_
