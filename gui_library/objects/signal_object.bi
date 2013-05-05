
@if not defined __GUI_OBJECTS_SIGNAL_OBJECT_BI__
@define __GUI_OBJECTS_SIGNAL_OBJECT_BI__

'$include:'ref_object.bi'

TYPE GUI_signal
  'ref as GUI_ref_object
  signal_name AS MEM_string
  first_connection AS _OFFSET 'GUI_signal_connection
  next_signal as _OFFSET 'GUI_signal
END TYPE

TYPE GUI_signal_connection
  'ref as GUI_ref_object
  notify_proc AS @PROC
  id as _UNSIGNED LONG
  dat AS _OFFSET
  next_connection AS _OFFSET 'GUI_signal_connection
END TYPE

TYPE GUI_signal_object
  ref as GUI_ref_object
  next_id AS _UNSIGNED LONG
  first_signal as _OFFSET 'GUI_signal
END TYPE

@endif
