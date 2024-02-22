'''Contains `TensorWrapper` a trait for wrappers around a `data` variable of `Tensor` type.'''

trait TensorWrapper:
  '''
  `Tensorwrapper` summarizes all types, 
  that 'wrap' around a `data` `Tensor`.
  '''

  fn __init__(inout self) raises:
    ...

  fn __copyinit__(inout self, borrowed other: Self):
    ...
	
  fn __moveinit__(inout self, owned other: Self):
    ...
