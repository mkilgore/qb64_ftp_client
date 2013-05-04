
@if not defined __GUI_ELEMENTS_BUTTON_BI__
@define __GUI_ELEMENTS_BUTTON_BI__

'$include:'container.bi'

@REGISTER GUI_ELEMENT GUI_BUTTON
TYPE GUI_element_button
  ele as GUI_container
  text as MEM_string
  flags AS _UNSIGNED LONG
  @DEFINE_BITFLAGS GUI_element_button
    PRESSED
  @END_BITFLAGS
END TYPE

@endif
