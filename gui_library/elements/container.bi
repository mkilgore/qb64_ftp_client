
!!if not defined __GUI_ELEMENTS_CONTAINER_BI__
!!define __GUI_ELEMENTS_CONTAINER_BI__

'$include:'gui_element.bi'

TYPE GUI_element_container
  ele as GUI_Element
  element AS _OFFSET
  flags as _UNSIGNED LONG
END TYPE

TYPE GUI_element_container_class
  parent  AS GUI_element_class
END TYPE

!!endif
