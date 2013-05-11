
!!if not defined __OBJ_OBJECTS_REF_OBJECT_BI__
!!define __OBJ_OBJECTS_REF_OBJECT_BI__

TYPE OBJ_ref_object
  parent AS OBJ_Object
  ref_count AS _UNSIGNED LONG
END TYPE

TYPE OBJ_ref_object_class
  parent_class as OBJ_Object_class
  get_ref AS @PROC
  release_ref AS @PROC
END TYPE

!!endif
