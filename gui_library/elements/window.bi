
@if not defined __GUI_ELEMENTS_WINDOW_BI__
@define __GUI_ELEMENTS_WINDOW_BI__

'$include:'container.bi'

@REGISTER GUI_ELEMENT GUI_WINDOW
TYPE GUI_element_window
  ele AS GUI_element_Container
  focus as _UNSIGNED LONG
  flags AS _UNSIGNED LONG 
  title as MEM_String
  
END TYPE

@endif
