
!!include once

TYPE _trait 

END TYPE

TYPE _trait_class @class

END TYPE

DECLARE FUNCTION _trait_get_type& ()
DECLARE FUNCTION _trait_cast%& (this as _OFFSET)
DECLARE SUB      _trait_init (this as _OFFSET)
DECLARE SUB      _trait_class_init (class AS _OFFSET)
DECLARE SUB      _trait_destroy (trait AS _OFFSET)
DECLARE FUNCTION _is_ _trait& (this as _OFFSET)

