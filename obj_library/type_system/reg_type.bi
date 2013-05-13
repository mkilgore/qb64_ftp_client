
!!if not defined __OBJ_OBJECTS_TYPE_SYSTEM_REG_TYPE_BI__
!!define __OBJ_OBJECTS_TYPE_SYSTEM_REG_TYPE_BI__

CONST OBJ_TYPE_PARENT_MAX = 40

TYPE OBJ_type_info
  base_size     AS LONG 
  class_size    AS LONG 
  init          AS @PROC
  class_init    AS @PROC
  destroy       AS @PROC
  parent        AS LONG
  flags         AS LONG
  @DEFINE_BITFLAGS OBJ_type_info
    ABSTRACT
    
  @END_BITFLAGS
  
  class_copy    AS _OFFSET
END TYPE

REDIM SHARED OBJ_TYPE_list(100) AS OBJ_type_info, OBJ_type_count AS LONG

TYPE OBJ_Object
  vtable AS _OFFSET
  otype  AS LONG
END TYPE

TYPE OBJ_Object_class
  filler AS @PROC
END TYPE

!!endif
