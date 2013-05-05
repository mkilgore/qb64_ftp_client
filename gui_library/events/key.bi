
@if not defined __GUI_EVENTS_KEY_BI__
@define __GUI_EVENTS_KEY_BI__


@REGISTER GUI_EVENT GUI_EVENT_KEY
TYPE GUI_event_key '6
  e as GUI_event 
  key_code AS _UNSIGNED LONG  
  'gui_element AS _UNSIGNED LONG
  flags AS _UNSIGNED INTEGER
END TYPE

@endif

