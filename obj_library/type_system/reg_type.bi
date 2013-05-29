
!!include once

CONST OBJ_TYPE_PARENT_MAX = 40

TYPE OBJ_type_info 
  base_size     AS LONG
  base_init     AS @PROC

  class_size    AS LONG
  class_init    AS @PROC

  destroy       AS @PROC

  parent        AS LONG

  vtable        AS _OFFSET
  vtable_size   AS LONG
  trait_count   AS LONG
  traits        AS _OFFSET
  flags         AS LONG
  @DECLARE_BITFLAGS OBJ_type_info
    IS_OBJECT
    IS_ABSTRACT
    IS_TRAIT
  @END_BITFLAGS
END TYPE 

TYPE OBJ_type_trait_node 
  ttype         AS LONG 'Trait number
  toff          AS _OFFSET 'Location of trait vtable
END TYPE 

REDIM SHARED OBJ_TYPE_list(100) AS OBJ_type_info, OBJ_type_count AS LONG

TYPE OBJ_Object 
  vtable AS _OFFSET
  otype  AS LONG
END TYPE 

TYPE OBJ_Object_class 
  otype      AS LONG
  toff       AS _OFFSET
END TYPE 

TYPE OBJ_trait_class 
  ttype AS LONG
END TYPE 

DECLARE FUNCTION OBJ_is_instance_of&              (this as _OFFSET)
DECLARE FUNCTION OBJ_type_register_type&          (t as OBJ_type_info)
DECLARE FUNCTION OBJ_type_allocate_new%&          (t AS LONG)
DECLARE FUNCTION OBJ_type_new_trait_list%&        (n as LONG)
DECLARE FUNCTION OBJ_type_add_new_trait_to_list%& (list as _OFFSET, t as LONG)
DECLARE FUNCTION OBJ_type_add_trait_to_class%&    (n as LONG)
DECLARE FUNCTION OBJ_type_get_class%&             (t AS LONG)
DECLARE FUNCTION OBJ_type_get_parent_clas%&       (t AS LONG)
DECLARE FUNCTION OBJ_Object_cast_as_type%&        (this as _OFFSET, t as LONG)
DECLARE FUNCTION OBJ_Object_get_type&             ()
DECLARE FUNCTION OBJ_Object_get_class%&           (this as _OFFSET)
DECLARE FUNCTION OBJ_Object_get_parent_class%&    (this as _OFFSET)
DECLARE FUNCTION OBJ_Class_get_type&              (class AS _OFFSET)
DECLARE SUB      OBJ_Object_destroy               (this as _OFFSET)


