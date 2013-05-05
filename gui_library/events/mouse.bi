
@if not defined __GUI_EVENTS_MOUSE_BI__
@define __GUI_EVENTS_MOUSE_BI__


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

