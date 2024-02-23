'''Contains the `Tensor3D` struct.'''
from .mdtensorwrapper import MDTensorWrapper
from .vector import Vector
from tensor import TensorShape
from random import seed, rand

struct Tensor3D[type: DType](MDTensorWrapper):
  '''Defines a wrapper to handle mathematical 3-dimensional tensors.'''
  
  var x: Int
  var y: Int
  var z: Int
  var data: Tensor[type]

  fn __init__(inout self) raises:
    self.data = Tensor[type]()
    self.x = 0
    self.y = 0
    self.z = 0

  fn __init__(inout self, owned x: Int, owned y: Int, owned z: Int):
    self.x = x
    self.y = y
    self.z = z
    self.data = Tensor[type](x,y,z)

  fn __init__(inout self, owned data: Tensor[type]) raises:
    
    if data.rank() != 3:
      raise Error("Unable to convert given data to a matrix due to rank mismatch")
    self.data = data
    self.x = data.dim(0)
    self.y = data.dim(1)
    self.z = data.dim(2)

  fn __copyinit__(inout self, borrowed other: Self):
    self.data = other.data
    self.x = other.x
    self.y = other.y
    self.z = other.z

  fn __moveinit__(inout self, owned other: Self):
    self.data = other.data
    self.x = other.x
    self.y = other.y
    self.z = other.z

  fn flatten(inout self) raises -> Vector[type]:
    return Vector(self.data.reshape(TensorShape(self.x * self.y * self.z)))

  fn random_tensor3d(inout self, owned x: Int, owned y: Int, owned z: Int):
    seed()
    self.data = rand[type](x, y, z)

alias MLT3D = Tensor3D[f32]
'''`Tensor3D` containing `DType.float32` values, useful for ML applications.'''

alias GPUT3D = Tensor3D[tf32]
'''
`Tensor3D` containing values of Mojo's special `DType.tensor_float32` type. 

Note that this requires a NVIDIA GPU.
'''
