
!!include once

TYPE OBJ_TEXT
  parent    AS OBJ_Object
  length    AS LONG
  allocated AS LONG
  s         AS _OFFSET
END TYPE

TYPE OBJ_TEXT_class @class
  parent_class AS OBJ_Object_Class
END TYPE

DECLARE FUNCTION OBJ_T_get$(this AS _OFFSET)
DECLARE FUNCTION OBJ_T_set (this AS _OFFSET, n AS STRING)

