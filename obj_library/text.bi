

!!if not defined __OBJ_OBJECTS_TEXT_BI__
!!define __OBJ_OBJECTS_TEXT_BI__

TYPE OBJ_TEXT
  parent    AS OBJ_ref_Object
  length    AS LONG
  allocated AS LONG
  s         AS _OFFSET
END TYPE

TYPE OBJ_TEXT_class @class
  parent_class AS OBJ_ref_object_class
END TYPE

!!endif

