'GUI TEST PROGRAM
'Used to test functionality of GUI library

'$include:'mem_library/mem_lib.bi'
'$include:'gui_library/gui_lib.bi'

gui_num = 5

DIM main_gui(gui_num) as GUI_element_type 'create 3 GUI elements

main_gui(1).updated = -1 'set update flag for first pass
main_gui(1).element_type = GUI_BOX
put_str main_gui(1).nam, "Plain Box"
main_gui(1).c1 = 7
main_gui(1).c2 = 1
main_gui(1).sc1 = 1
main_gui(1).sc2 = 7
main_gui(1).row1 = 1
main_gui(1).row2 = 10
main_gui(1).col1 = 1
main_gui(1).col2 = 19

main_gui(2).element_type = GUI_INPUT_BOX
put_str main_gui(2).nam, "Input Box"
main_gui(2).c1 = 7
main_gui(2).c2 = 1
main_gui(2).sc1 = 1
main_gui(2).sc2 = 7
main_gui(2).row1 = 1
main_gui(2).col1 = 20
main_gui(2).col2 = 40

main_gui(3).element_type = GUI_LIST_BOX
put_str main_gui(3).nam, "List Box"
main_gui(3).c1 = 7
main_gui(3).c2 = 1
main_gui(3).sc1 = 1
main_gui(3).sc2 = 7
main_gui(3).row1 = 1
main_gui(3).row2 = 10
main_gui(3).col1 = 41
main_gui(3).col2 = 80
main_gui(3).scroll = 1

main_gui(4).element_type = GUI_CHECKBOX
put_str main_gui(4).nam, "CheckBox"
main_gui(4).c1 = 7
main_gui(4).c2 = 1
main_gui(4).sc1 = 15
main_gui(4).sc2 = 1
main_gui(4).row1 = 4
main_gui(4).col1 = 20

main_gui(5).element_type = GUI_BUTTON
put_str main_gui(5).nam, "Button"
main_gui(5).c1 = 7
main_gui(5).c2 = 1
main_gui(5).sc1 = 15
main_gui(5).sc2 = 1
main_gui(5).row1 = 5
main_gui(5).col1 = 20

allocate_string_array main_gui(3).lines, 120
for x = 1 to 80
  put_str_array main_gui(3).lines, x, "Str:" + str$(x)
next x

main_gui(3).length = 80 'number of elements

selected_gui = 1

DO
  _LIMIT 500
  
  if GUI_update_screen(main_gui(), gui_num) then 
    GUI_draw_element_array main_gui(), gui_num, selected_gui
  end if

  
  GUI_mouse_range main_gui(), gui_num, selected_gui

  key$ = GUI_inkey$(main_gui(), gui_num, selected_gui)
  
  SELECT CASE key$
  
  END SELECT
  IF main_gui(5).pressed then
    locate 23, 1
    print "Pressed! "; count;
    count = count + 1
    main_gui(5).pressed = 0
  end if
LOOP UNTIL key$ = CHR$(27)

SYSTEM

'$include:'mem_library/mem_lib.bm'
'$include:'gui_library/gui_lib.bm'
