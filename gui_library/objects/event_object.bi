
@if not defined __GUI_OBJECTS_EVENT_OBJECT_BI__
@define __GUI_OBJECTS_EVENT_OBJECT_BI__

'$include:'ref_object.bi'

TYPE GUI_event
  obj as GUI_ref_object
  event_type AS _UNSIGNED LONG
  source as _OFFSET 'GUI_element
  modifiers AS _UNSIGNED LONG
END TYPE

@endif
