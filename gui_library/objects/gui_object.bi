
@if not defined __GUI_OBJECTS_GUI_OBJECT_BI__
@define __GUI_OBJECTS_GUI_OBJECT_BI__

'$include:'signal_object.bi'

TYPE GUI_Object
  s as GUI_signal_object
  flags AS _UNSIGNED LONG
  'free AS @SUB (_OFFSET)
  @DEFINE_BITFLAGS GUI_Object
    FLOATING
  @END_BITFLAGS
END TYPE

@endif
