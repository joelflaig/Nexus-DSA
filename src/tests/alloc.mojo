from DSA import DTypeArray
from DSA import f32

fn main() raises:
  var arr = DTypeArray[f32](3.23, 5.32, 234,9)

  for i in range(len(arr)):
    print(arr[i])

  arr.append(4.23)

  for i in range(len(arr)):
    print(arr[i])

