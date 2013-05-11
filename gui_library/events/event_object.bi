
!!if not defined __GUI_OBJECTS_EVENT_OBJECT_BI__
!!define __GUI_OBJECTS_EVENT_OBJECT_BI__

TYPE GUI_event
  obj as OBJ_ref_object
  event_type AS _UNSIGNED LONG
  source as _OFFSET 'GUI_element
  modifiers AS _UNSIGNED LONG
END TYPE

TYPE GUI_event_class
  parent_class AS OBJ_ref_object_class
END TYPE

!!endif
