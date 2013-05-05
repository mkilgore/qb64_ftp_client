
@if not defined __GUI_LIB2_BI__
@define __GUI_LIB2_BI__

CONST GUI_TRUE = -1
CONST GUI_FALSE = 0

TYPE GUI_Object
  ref_count AS _UNSIGNED LONG
  flags AS _UNSIGNED LONG
  'free AS @SUB (_OFFSET)
  @DEFINE_BITFLAGS GUI_Object
    FLOATING
  @END_BITFLAGS
  delete AS @PROC ' SUB(_OFFSET)
END TYPE


TYPE GUI_dimension
@if defined GUI_TEXT
  row AS _UNSIGNED LONG 
  col as _UNSIGNED LONG
@else
  x AS _UNSIGNED LONG
  y AS _UNSIGNED LONG
@endif
  wid AS _UNSIGNED LONG
  hei AS _UNSIGNED LONG
END TYPE

TYPE GUI_color
@if defined GUI_TEXT
  f as _unsigned _byte
  b as _unsigned _byte
@else
  a AS _UNSIGNED _BYTE
  r AS _UNSIGNED _BYTE
  g AS _UNSIGNED _BYTE
  b AS _UNSIGNED _BYTE
@endif
END TYPE

TYPE GUI_event
  obj as GUI_Object
  event_type AS _UNSIGNED LONG
  source as _OFFSET 'GUI_element
  modifiers AS _UNSIGNED LONG
END TYPE

TYPE GUI_signal
  'GUI_element, data pointer
  nam AS MEM_string
END TYPE

@REGISTER GUI_EVENT GUI_EVENT_KEY
TYPE GUI_event_key '6
  e as GUI_event 
  key_code AS _UNSIGNED LONG  
  'gui_element AS _UNSIGNED LONG
  flags AS _UNSIGNED INTEGER
END TYPE

@REGISTER GUI_EVENT GUI_EVENT_MOUSE
TYPE GUI_event_mouse '28
  e as GUI_event
  'gui_element AS _UNSIGNED LONG
  'm as GUI_mouse_state
@if defined GUI_TEXT
  row2 AS _UNSIGNED LONG 'Used if a drag occured
  col2 AS _UNSIGNED LONG
@endif
  flags as INTEGER
  count as INTEGER
END TYPE

@endif
