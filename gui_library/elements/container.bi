
@if not defined __GUI_ELEMENTS_CONTAINER_BI__
@define __GUI_ELEMENTS_CONTAINER_BI__

'$include:'element.bi'

TYPE GUI_element_container
  ele as GUI_element 
  element AS _OFFSET
  flags as _UNSIGNED LONG
  '@DEFINE_BITFLAGS GUI_container
    
  '@END_BITFLAGS
END TYPE

@endif
