from DSA import *

fn main() raises:
  var a = Tensor[f32](2,2)
  a.simd_store[1](VariadicList(0, 0), 3.0)
  a.simd_store[1](VariadicList(1, 0), 5.0)
  a.simd_store[1](VariadicList(0, 1), 4.0)
  a.simd_store[1](VariadicList(1, 1), 2.0)

  var b = Tensor[f32](2,2)
  b.simd_store[1](VariadicList(0, 0), 7.0)
  b.simd_store[1](VariadicList(1, 0), 2.0)
  b.simd_store[1](VariadicList(0, 1), 9.0)
  b.simd_store[1](VariadicList(1, 1), 0.0)

  print(a)
  print(b)
  
  var c = TensorOps.hadamard(a, b)

  print(c)

