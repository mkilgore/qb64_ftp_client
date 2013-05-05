
@if not defined __GUI_ELEMENTS_FRAME_BI__
@define __GUI_ELEMENTS_FRAME_BI__

'$include:'container.bi'

@REGISTER GUI_ELEMENT GUI_FRAME
TYPE GUI_element_frame
  ele as GUI_element_Container
  flags as _UNSIGNED LONG 
  @DEFINE_BITFLAGS GUI_element_frame
    SHADOW
    DIALOG
  @END_BITFLAGS  
END TYPE

@endif
