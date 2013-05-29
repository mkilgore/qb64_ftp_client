
'Use 'Text-Mode' Screen 0 GUI
!!define GUI_TEXT

'Set debug mode
!!define __DEBUG__

'!!if defined __DEBUG__
'!!  define debug_print(x) 
'!!else
'!!  define debug_print(x)
'!!end if

'$include:'gui_library/gui_lib2.bi'

DIM Win AS _OFFSET, button as _OFFSET, ele AS LONG, m as MEM_String, of as _OFFSET

Win = GUI_element_window_new_s_title%&(25, 80, "Hey!")

button = GUI_element_button_new_text%&("Hi!")
GUI_element_set_location button, 20, 15

GUI_element_container_add Win, button
'GUI_element_show Win
GUI_element_window_screen win


id = OBJ_signal_add_new_signal(button, "pressed1")
print id
sleep
id = OBJ_signal_add_new_signal(button, "pressed2")
id = OBJ_signal_add_new_signal(button, "pressed3")

of = _OFFSET(m)

handle_id = OBJ_signal_connect_to_signal&(button, "pressed1", @SUB(Test_signal1), of)

print handle_id
sleep

'PRINT @call((_OFFSET, LONG, LONG) AS _OFFSET, test, (arg1, arg2, arg3)) 

DO
  _LIMIT 60
  a$ = inkey$
  if a$ > "" then
    MEM_put_str m, a$
    OBJ_signal_emit button, "pressed1"
  end if
LOOP until a$ = chr$(27)

SUB Test_signal1 (this as _OFFSET, dat as _OFFSET)
DIM m as MEM_String
'print "Test"
MEM_MEMCPY _OFFSET(m), dat, LEN(MEM_String, TYPE)
print MEM_get_str$(m);
END SUB

'$include:'gui_library/gui_lib2.bm'
