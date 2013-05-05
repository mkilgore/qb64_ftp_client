
@if not defined __GUI_ELEMENTS_BUTTON_BI__
@define __GUI_ELEMENTS_BUTTON_BI__

'$include:'container.bi'

TYPE GUI_element_button_color
  sel as GUI_color
  normal as GUI_color
END TYPE


@REGISTER GUI_ELEMENT GUI_BUTTON
TYPE GUI_element_button
  ele as GUI_element_container
  text as MEM_string
  theme AS GUI_element_button_color
  flags AS _UNSIGNED LONG
  @DEFINE_BITFLAGS GUI_element_button
    PRESSED
  @END_BITFLAGS
END TYPE

@endif
