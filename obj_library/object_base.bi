
!!include once

TYPE 
  parent AS
  
END TYPE

TYPE _class @class
  parent_class AS
END TYPE

DECLARE FUNCTION _get_type&  ()
DECLARE FUNCTION _new%&      ()
DECLARE FUNCTION _cast%&     (this as _OFFSET)
DECLARE SUB      _init       (this as _OFFSET)
DECLARE SUB      _class_init (class AS _OFFSET)
DECLARE SUB      _destroy    (this AS _OFFSET)
DECLARE FUNCTION _is_        (this as _OFFSET)

