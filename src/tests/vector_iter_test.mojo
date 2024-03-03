from DSA.datastructs.vector import Vector
from DSA.datastructs import f16

fn main() raises:
  var vec = Vector[f16]()
  vec.random_vector(10)
  for i in vec:
    print(i)
