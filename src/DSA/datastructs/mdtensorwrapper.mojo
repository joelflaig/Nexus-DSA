'''Contains the `MDTensorwrapper` trait.'''
from .tensorwrapper import TensorWrapper
from .vector import Vector

trait MDTensorWrapper(TensorWrapper):
  
  '''
  `TensorWrappers` conforming to this trait have more than one dimension 
  and can be flattened out to a `Vector`.
  '''
