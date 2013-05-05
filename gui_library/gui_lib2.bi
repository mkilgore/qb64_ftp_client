
@if not defined __GUI_LIB2_BI__
@define __GUI_LIB2_BI__

CONST GUI_TRUE = -1
CONST GUI_FALSE = 0
CONST GUI_NULL = 0

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

'$include:'objects/ref_object.bi'
'$include:'objects/signal_object.bi'
'$include:'objects/event_object.bi'
'$include:'objects/gui_object.bi'

'$include:'events/key.bi'
'$include:'events/mouse.bi'

@endif
