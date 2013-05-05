@define GUI_TEXT

'$include:'/mnt/data/git/qb64_ftp_client/mem_library/mem_lib.bi'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/gui_lib2.bi'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/elements/std_elements.bi'

DIM Win AS _OFFSET, button as _OFFSET, ele AS LONG

Win = GUI_element_window_new_with_size_title%&(25, 80, "Hey!")

button = GUI_element_button_new_with_text%&("Hi!")
GUI_element_set_location button, 20, 15

GUI_element_container_add Win, button
GUI_element_show Win
GUI_element_window_set_as_screen win

GUI_signal_Object_add_new_signal button, "pressed"

handle_id = GUI_signal_Object_attach_proc_to_signal&(button, "pressed", @SUB(Test_signal1), GUI_NULL)
handle_id = GUI_signal_Object_attach_proc_to_signal&(button, "pressed", @SUB(Test_signal2), GUI_NULL)
handle_id = GUI_signal_Object_attach_proc_to_signal&(button, "pressed", @SUB(Test_signal3), GUI_NULL)
handle_id = GUI_signal_Object_attach_proc_to_signal&(button, "pressed", @SUB(Test_signal4), GUI_NULL)
handle_id = GUI_signal_Object_attach_proc_to_signal&(button, "pressed", @SUB(Test_signal5), GUI_NULL)
handle_id = GUI_signal_Object_attach_proc_to_signal&(button, "pressed", @SUB(Test_signal6), GUI_NULL)
handle_id = GUI_signal_Object_attach_proc_to_signal&(button, "pressed", @SUB(Test_signal7), GUI_NULL)
handle_id = GUI_signal_Object_attach_proc_to_signal&(button, "pressed", @SUB(Test_signal8), GUI_NULL)

print handle_id

DO
  _LIMIT 60

  a$ = inkey$
  if a$ = " " then 
    t# = TIMER(.001)
    for x = 1 to 5000
      GUI_signal_Object_emit_signal button, "pressed"
    next x
    t2# = TIMER(.001)
    locate 6, 2
    print using "TIME: ##.######"; t2# - t#
  end if
LOOP until a$ = chr$(27)

SUB Test_signal1 (this as _OFFSET, dat as _OFFSET)
STATIC count
'if count = 0 then count = 1
'count = count + 1
'if count mod 100000 = 0 then
'  LOCATE 2, 2
'  print count
'end if
END SUB

SUB Test_signal2 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
'if count = 0 then count = 1
'count = count * 2
'if count mod 100000 = 0 then
'  LOCATE 3, 2
'  print count
'end if
END SUB

SUB Test_signal3 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
'if count = 0 then count = 1
'count = count + 20
'if count mod 100000 = 0 then
'  LOCATE 4, 2
'  print count
'end if
END SUB

SUB Test_signal4 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
'if count = 0 then count = 1
'count = count + 20
'if count mod 100000 = 0 then
'  LOCATE 4, 2
'  print count
'end if
END SUB

SUB Test_signal5 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
'if count = 0 then count = 1
'count = count + 20
'if count mod 100000 = 0 then
'  LOCATE 4, 2
'  print count
'end if
END SUB

SUB Test_signal6 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
'if count = 0 then count = 1
'count = count + 20
'if count mod 100000 = 0 then
'  LOCATE 4, 2
'  print count
'end if
END SUB

SUB Test_signal7 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
'if count = 0 then count = 1
'count = count + 20
'if count mod 100000 = 0 then
'  LOCATE 4, 2
'  print count
'end if
END SUB

SUB Test_signal8 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
'if count = 0 then count = 1
'count = count + 20
'if count mod 100000 = 0 then
'  LOCATE 4, 2
'  print count
'end if
END SUB

'$include:'/mnt/data/git/qb64_ftp_client/mem_library/mem_lib.bm'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/gui_lib2.bm'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/elements/std_elements.bm'
