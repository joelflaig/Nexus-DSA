from DSA.datastructs.vector import Vector
from DSA.datastructs import f16

fn main() raises:
  var v = Vector[f16]()
  v.random_vector(10)
  var path = Path()
  path.path += "/bin/tests/random_vector_test.out"
  v.data.save(path)
