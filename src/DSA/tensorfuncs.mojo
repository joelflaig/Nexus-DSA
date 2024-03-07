'''
Provides functions for working with `Tensor` values.
'''
from tensor import TensorShape
from .array import DTypeArray

struct Vector[type: DType]:
  '''
  Provides functions for working with 1-dimensional `Tensor` values.
  '''

  @staticmethod
  fn append(inout vec: Tensor[type], data: SIMD[type,1]) raises:
    vec = vec.reshape(
      TensorShape(
        vec.shape().num_elements()+1
        )
      )
    vec.simd_store(-1, data)

  @staticmethod
  fn sum(vec: Tensor[type]) -> SIMD[type,1]:
    var val: SIMD[type,1] = 0
    for i in range(vec.dim(0)):
      val += vec[1]
    return val

  @staticmethod
  fn vector_applicable(
    func: fn(x: SIMD[type,1], a: SIMD[type,1]) -> SIMD[type,1]
    ) -> 
    fn(x: Tensor[type], a: SIMD[type, 1]) raises escaping -> Tensor[type]:
    '''Takes a function with a parameter and returns it equivalent for the `Self` type.'''
    @always_inline
    fn vecfunc(vec: Tensor[type], a: SIMD[type,1]) raises -> Tensor[type]:
      var val = Tensor[type]()
      for i in range(vec.dim(0)):
        Self.append(val, 
          func(
            i, a
            )
          )
      return val
    
    return vecfunc

struct Matrix[type: DType]:
  '''
  Provides functions for working with 2-dimensional `Tensor` values.
  '''

  @staticmethod
  fn matrix_applicable(
    func: fn(x: SIMD[type, 1], a: SIMD[type, 1]) -> SIMD[type, 1]
    ) -> 
    fn(x: Tensor[type], a: SIMD[type, 1]) raises escaping -> Tensor[type]:
      
    '''Takes a function with a parameter and returns it equivalent for the `Matrix` type.'''
    @always_inline
    fn matfunc(matrix: Tensor[type], a: SIMD[type, 1]) raises escaping -> Tensor[type]:
      var val = Tensor[type](matrix.dim(0), matrix.dim(1))
      for i in range(matrix.dim(0)):
        for j in range(matrix.dim(1)):
          
          val.simd_store[1](
            VariadicList(i, j), 
            func(
              matrix.simd_load[1](i, j), a
              )
            )

      return val
    
    return matfunc

struct AnyTensorOps[type: DType]:
  '''
  Provides functions for working with n-dimensional `Tensor` values.
  '''

  @always_inline
  fn hadamard[type: DType](a: Tensor[type], b:Tensor[type]) raises -> Tensor[DType]:
    if not a.shape() == b.shape:
      raise Error("Cannot execute hadamard multiplication due to unequal shapes.")
    var arr_a = DTypeArray(a.data(), a.num_elements())

  @always_inline
  fn dot[type: DType](a: Tensor[type], b: Tensor[type]) raises -> Tensor[type]:
    '''Defines function for matrix-vector multiplication.'''
    if a.dim(0) != b.dim(1):
      raise Error("Cannot multiply due to dimension mismatch")

    var val = Tensor[type](a.dim(0))

    for i in range(a.dim(0)):
      # multiplies input vector with rows of matrix
      val[i] = (b * 
        # returns the i-th row of the matrix as Tensor value
        a.clip(
          a.dim(1)*i, 
          a.dim(1)*(i+1)-1
        ))[0]
    
    return val

  @always_inline
  fn flatten[type: DType](inout tens: Tensor[type]) raises -> Tensor[type]:
    '''Returns all values of the underlying `Tensor` value in a 1-dimensional form.'''
    var shape: Int = 0
    for i in range(tens.rank()):
      shape *= tens.dim(i)

    return tens.reshape(
        TensorShape(
          shape
          )
        )
