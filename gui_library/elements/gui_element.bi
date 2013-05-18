
!!if not defined __GUI_OBJECTS_GUI_ELEMENT_BI__
!!define __GUI_OBJECTS_GUI_ELEMENT_BI__

TYPE GUI_Element
  parent_obj as OBJ_signal
  
  nam       AS MEM_String
  dimension AS GUI_dimension
  flags     AS _UNSIGNED LONG
  img       AS LONG 
  parent    AS _OFFSET

  @DEFINE_BITFLAGS GUI_element
    UPDATED
    VISIBLE
    ACTIVE
    SKIP
  @END_BITFLAGS
END TYPE

TYPE GUI_Element_class @class
  parent_class    AS OBJ_Signal_class
  drw             AS @SUB(_OFFSET)
  create_image    AS @SUB(_OFFSET)

  set_visible     AS @SUB(_OFFSET, LONG)
  is_visible      AS @FUNCTION(_OFFSET) AS LONG
  
  set_active      AS @SUB(_OFFSET, LONG)
  is_active       AS @FUNCTION(_OFFSET) AS LONG

  set_can_focus   AS @SUB(_OFFSET, LONG)
  get_can_focus   AS @FUNCTION(_OFFSET) AS LONG
  set_size        AS @SUB(_OFFSET, LONG, LONG)
  get_image       AS @FUNCTION(_OFFSET), AS LONG
  get_parent      AS @FUNCTION(_OFFSET) AS _OFFSET
  set_parent      AS @SUB(_OFFSET, _OFFSET)
  set_name        AS @SUB(_OFFSET, STRING)
  get_name        AS @FUNCTION(_OFFSET) AS STRING
  
  set_location    AS @SUB(_OFFSET, LONG, LONG)
  set_dimension   AS @SUB(_OFFSET, LONG, LONG, LONG, LONG)
  set_dimension_d AS @SUB(_OFFSET, GUI_dimension)
  
  set_width       AS @SUB(_OFFSET, LONG)
  get_width       AS @FUNCTION(_OFFSET) AS LONG
  
  set_height      AS @SUB(_OFFSET, LONG)
  get_height      AS @FUNCTION(_OFFSET) AS LONG
  
!!if defined GUI_TEXT
  set_row         AS @SUB(_OFFSET, LONG)
  set_col         AS @SUB(_OFFSET, LONG)
  get_row         AS @FUNCTION(_OFFSET) AS LONG
  get_col         AS @FUNCTION(_OFFSET) AS LONG
!!else
  set_x           AS @SUB(_OFFSET, LONG)
  set_y           AS @SUB(_OFFSET, LONG)
  get_x           AS @FUNCTION(_OFFSET) AS LONG
  get_y           AS @FUNCTION(_OFFSET) AS LONG
!!endif
END TYPE


!!endif
