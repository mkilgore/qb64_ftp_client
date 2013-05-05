
@if not defined __GUI_ELEMENTS_FRAME_BI__
@define __GUI_ELEMENTS_FRAME_BI__

'$include:'container.bi'

@REGISTER GUI_ELEMENT GUI_FRAME
TYPE GUI_element_frame
  ele as GUI_element_Container
  flags as _UNSIGNED LONG 
  nam as MEM_String
  @DEFINE_BITFLAGS GUI_element_frame
    SHADOW
  @END_BITFLAGS  
END TYPE

@endif
