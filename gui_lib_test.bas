'GUI TEST PROGRAM
'Used to test functionality of GUI library

'$include:'mem_library/mem_lib.bi'
'$include:'gui_library/gui_lib.bi'

gui_num = 6

DIM main_gui(gui_num) as GUI_element_type 'create 3 GUI elements

'GUI(1) is our main dialog box and is going to be
main_gui(1).updated = -1 'set update flag for first pass
main_gui(1).element_type = GUI_BOX
put_str main_gui(1).nam, "Plain Box"
main_gui(1).c1 = 7
main_gui(1).c2 = 1
main_gui(1).sc1 = 1
main_gui(1).sc2 = 7
main_gui(1).row1 = 1
main_gui(1).row2 = 25
main_gui(1).col1 = 1
main_gui(1).col2 = 80
main_gui(1).skip = -1 ' -- We don't want to be able to TAB to this gui element
main_gui(1).layer = -1 ' -- Set in background. Layer 0 is the default

main_gui(2).element_type = GUI_INPUT_BOX
put_str main_gui(2).nam, "Input Box"
main_gui(2).c1 = 7
main_gui(2).c2 = 1
main_gui(2).sc1 = 1
main_gui(2).sc2 = 7
main_gui(2).row1 = 2
main_gui(2).col1 = 2
main_gui(2).col2 = 30

main_gui(3).element_type = GUI_LIST_BOX
put_str main_gui(3).nam, "List Box"
main_gui(3).c1 = 7
main_gui(3).c2 = 1
main_gui(3).sc1 = 1
main_gui(3).sc2 = 7
main_gui(3).row1 = 2
main_gui(3).row2 = 20
main_gui(3).col1 = 31
main_gui(3).col2 = 79
main_gui(3).scroll = 1

main_gui(4).element_type = GUI_CHECKBOX
put_str main_gui(4).nam, "CheckBox"
main_gui(4).c1 = 7
main_gui(4).c2 = 1
main_gui(4).sc1 = 15
main_gui(4).sc2 = 1
main_gui(4).row1 = 5
main_gui(4).col1 = 2

main_gui(5).element_type = GUI_BUTTON
put_str main_gui(5).nam, "Button"
main_gui(5).c1 = 7
main_gui(5).c2 = 1
main_gui(5).sc1 = 15
main_gui(5).sc2 = 1
main_gui(5).row1 = 7
main_gui(5).col1 = 2

main_gui(6).element_type = GUI_DROP_DOWN 
put_str main_gui(6).nam, "Drop Down"
main_gui(6).c1 = 7
main_gui(6).c2 = 1
main_gui(6).sc1 = 1
main_gui(6).sc2 = 7
main_gui(6).row1 = 6
main_gui(6).col1 = 2
main_gui(6).row2 = 15
main_gui(6).col2 = 30
main_gui(6).scroll = 1
main_gui(6).shadow = -1
main_gui(6).selected = 1

allocate_string_array main_gui(3).lines, 120
allocate_string_array main_gui(6).lines, 120
for x = 1 to 80
  put_str_array main_gui(3).lines, x, "Str:" + str$(x)
  put_str_array main_gui(6).lines, x, "Str:" + str$(x)
next x

main_gui(3).length = 80 'number of elements
main_gui(6).length = 80

selected_gui = 1

DO
  _LIMIT 500
  
  if GUI_update_screen(main_gui(), gui_num, selected_gui) then 
    GUI_draw_element_array main_gui(), gui_num, selected_gui
  end if

  
  GUI_mouse_range main_gui(), gui_num, selected_gui
  key$ = GUI_inkey$(main_gui(), gui_num, selected_gui)

  SELECT CASE key$ 'Extra stuff to do on keypresses, if you have anything that isn't already handled.
  
  END SELECT
  
  'manage interactions here.

  IF main_gui(5).pressed then
    locate 23, 1
    print "Pressed! "; count;
    count = count + 1
    main_gui(5).pressed = 0
  end if
LOOP UNTIL key$ = CHR$(27) or _EXIT

SYSTEM

'$include:'mem_library/mem_lib.bm'
'$include:'gui_library/gui_lib.bm'
