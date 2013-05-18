
!!if not defined __OBJ_OBJECTS_REF_OBJECT_BI__
!!define __OBJ_OBJECTS_REF_OBJECT_BI__

TYPE OBJ_ref_object
  parent AS OBJ_Object
  ref_count AS _UNSIGNED LONG
END TYPE

TYPE OBJ_ref_object_class @class
  parent_class as OBJ_Object_class
  get_ref      AS @FUNCTION(_OFFSET) AS _OFFSET
  release_ref  AS @SUB(_OFFSET)
END TYPE

!!endif