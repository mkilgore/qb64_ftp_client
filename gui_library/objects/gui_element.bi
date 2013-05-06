
@if not defined __GUI_OBJECTS_GUI_ELEMENT_BI__
@define __GUI_OBJECTS_GUI_ELEMENT_BI__

'$include:'signal_object.bi'

TYPE GUI_Element
  s as GUI_signal
  dimension AS GUI_dimension
  flags AS _UNSIGNED LONG
  @DEFINE_BITFLAGS GUI_element
    UPDATED @set @get
    VISIBLE @set @get
    ACTIVE  @set @get
    SKIP    @set @get
    INTERNAL
  @END_BITFLAGS
  element_type AS _UNSIGNED LONG @set
  img AS LONG 
  parent AS _OFFSET
  drw AS @PROC

END TYPE

@endif
