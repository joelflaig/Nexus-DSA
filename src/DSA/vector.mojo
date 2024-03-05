'''Contains the `Vector` struct.'''
from .tensorwrapper import TensorWrapper
from tensor import TensorShape
from random import seed, rand

struct Vector[type: DType](TensorWrapper, Sized):
  '''Defines a wrapper to handle mathematical vectors.'''
  
  var data: Tensor[type]
  var size: Int
  var _offset: Int

  fn __init__(inout self) raises:
    self.size = 0
    self._offset = 0
    self.data = Tensor[type]()

  fn __init__(inout self, owned size: Int) raises:
    self.size = size
    self._offset = 0
    self.data = Tensor[type](size)

  fn __init__(inout self, data: Tensor[type]) raises:
    if data.rank() != 1:
      raise Error("Unable to convert given data to a vector due to rank mismatch")
    self.data = data
    self._offset = 0
    self.size = data.dim(0)

  fn __del__(owned self):
    self.data.__del__()
    self.size.__del__()
    self._offset.__del__()

  fn __copyinit__(inout self, borrowed other: Self):
    self.data.__copyinit__(other.data)
    self._offset = other._offset
    self.size = other.size

  fn __moveinit__(inout self, owned other: Self):
    self.data.__moveinit__(other.data)
    self._offset = other._offset
    self.size = other.size

  fn __getitem__(self, index: Int) -> SIMD[type, 1]:
    return self.data[index]

  fn __len__(self) -> Int:
    return self.size

  fn __iter__(self) raises -> Self:
    return self.data

  fn __next__(inout self) raises -> SIMD[type,1]:
    if self._offset >= self.size:
      raise Error("Index out of range of vector")
    self._offset += 1
    return self.data[self._offset]

  @always_inline
  fn __ipow__(inout self, exponent: Int) raises:
    self.data.__ipow__(exponent)

  @always_inline
  fn __pow__(self, exponent: Int) raises -> Self:
    return Self(self.data ** exponent)

  @always_inline
  fn __truediv__(self, scalar: SIMD[type,1]) raises -> Self:
    return Self(self.data / scalar)

  @always_inline
  fn __rtruediv__(self, scalar: SIMD[type,1]) raises -> Self:
    return Self(self.data / scalar)

  @always_inline
  fn __truediv__(self, vec: Self) raises -> Self:
    if not self.dim_match(vec):
      raise Error("Unable to divide by vector due to dimension mismatch")

    return Self(self.data / vec.data)

  @always_inline
  fn __rtruediv__(self, vec: Self) raises -> Self:
    if not self.dim_match(vec):
      raise Error("Unable to divide by vector due to dimension mismatch")
    
    return Self(self.data / vec.data)

  @always_inline
  fn __mul__(self, vec: Self) raises -> SIMD[type,1]:
    if not self.dim_match(vec):
      raise Error("Unable to multiply vectors due to dimension mismatch")

    return (self.data * vec.data)[0]

  @always_inline
  fn __rmul__(self, vec: Self) raises -> SIMD[type,1]:
    return self.__mul__(vec)

  @always_inline
  fn __sub__(self, vec: Self) raises -> Self:
    if not self.dim_match(vec):
      raise Error("Unable to subtract vector due to dimension mismatch")
    
    return Self(self.data - vec.data)

  @always_inline
  fn __rsub__(self, vec: Self):
    pass

  @always_inline
  fn __add__(self, vec: Self) raises -> Self:
    if not self.dim_match(vec):
      raise Error("Unable to add vectors due to dimension mismatch")
    
    return Self(self.data + vec.data)

  @always_inline
  fn __eq__(self, vec: Self) -> Bool:
    if self.data != vec.data: return False
    return True

  @always_inline
  fn __ne__(self, vec: Self) -> Bool:
    return not self.__eq__(vec)
  
  @always_inline
  fn dim_match(self, vec: Self) -> Bool:
    '''Checks wether the length of the vector matches the length of `self`.'''
    if vec.data.dim(0) != self.data.dim(0): return False
    return True

  fn append(inout self, data: SIMD[type,1]) raises:
    self.data = self.data.reshape(
      TensorShape(
        self.data.shape().num_elements()+1
        )
      )
    self.data.simd_store(-1, data)

  fn sum(self) -> SIMD[type,1]:
    var val: SIMD[type,1] = 0
    for i in range(self.data.dim(0)):
      val += self.data[i]
    return val

  fn random_vector(inout self, len: Int) raises:
    '''Defines function for generating random vectors with `SIMD[type,1]` values.'''
    seed()
    self.data = rand[type](len)

  @staticmethod
  fn vector_applicable[type: DType](
    func: fn(x: SIMD[type,1], a: SIMD[type,1]) -> SIMD[type,1]
    ) -> 
    fn(x: Tensor[type], a: SIMD[type, 1]) raises escaping -> Tensor[type]:
    '''Takes a function with a parameter and returns it equivalent for the `Self` type.'''
    @always_inline
    fn vecfunc(vec: Tensor[type], a: SIMD[type,1]) raises -> Tensor[type]:
      var val = Tensor[type]()
      for i in vec:
        val.append(
          func(
            i, a
            )
          )
      return val
    
    return vecfunc

alias MLVec = Vector[f32]
'''`Vector` containing `DType.float32` values, useful for ML applications.'''

alias GPUVec = Vector[tf32]
'''
`Vector` containing values of Mojo's special `DType.tensor_float32` type. 

Note that this requires a NVIDIA GPU.
'''
