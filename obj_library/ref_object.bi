
!!include once

TYPE OBJ_ref_trait
  'parent AS OBJ_Object
  ref_count AS _UNSIGNED LONG
END TYPE

TYPE OBJ_ref_trait_class @class
  'parent_class as OBJ_Object_class
  get_ref      AS @FUNCTION(_OFFSET) AS _OFFSET
  release_ref  AS @SUB(_OFFSET)
END TYPE

