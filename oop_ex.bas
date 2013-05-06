@define GUI_TEXT

'$include:'/mnt/data/git/qb64_ftp_client/mem_library/mem_lib.bi'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/gui_lib2.bi'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/elements/std_elements.bi'

DIM Win AS _OFFSET, button as _OFFSET, ele AS LONG, m as MEM_String, of as _OFFSET

Win = GUI_element_window_new_with_size_title%&(25, 80, "Hey!")

button = GUI_element_button_new_with_text%&("Hi!")
GUI_element_set_location button, 20, 15

GUI_element_container_add Win, button
GUI_element_show Win
GUI_element_window_set_as_screen win

GUI_signal_add_new_signal button, "pressed1"
GUI_signal_add_new_signal button, "pressed2"
GUI_signal_add_new_signal button, "pressed3"

of = _OFFSET(m)

handle_id = GUI_signal_connect&(button, "pressed1", @SUB(Test_signal1), of)
'handle_id = GUI_signal_connect&(button, "pressed2", @SUB(Test_signal2), off)
'handle_id = GUI_signal_connect&(button, "pressed2", @SUB(Test_signal1), off)
'handle_id = GUI_signal_connect&(button, "pressed3", @SUB(Test_signal3), off)

print handle_id

DO
  _LIMIT 60

  a$ = inkey$
  if a$ > "" then
    MEM_put_str m, a$
    GUI_signal_emit button, "pressed1"
  end if
LOOP until a$ = chr$(27)

SUB Test_signal1 (this as _OFFSET, dat as _OFFSET)
DIM m as MEM_String
MEM_MEMCPY _OFFSET(m), dat, LEN(MEM_String, TYPE)
print MEM_get_str$(m);
END SUB

SUB Test_signal2 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
if count = 0 then count = 1
count = count + 1
'if count mod 100000 = 0 then
  LOCATE 3, 2
  print count
'end if
END SUB

SUB Test_signal3 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
if count = 0 then count = 1
count = count + 1
'if count mod 100000 = 0 then
  LOCATE 4, 2
  print count
'end if
END SUB

'$include:'/mnt/data/git/qb64_ftp_client/mem_library/mem_lib.bm'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/gui_lib2.bm'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/elements/std_elements.bm'
