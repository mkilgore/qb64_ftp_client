'GUI TEST PROGRAM
'Used to test functionality of GUI library

'$include:'mem_library/mem_lib.bi'
'$include:'gui_library/gui_lib.bi'

GUI_init

gui_num = 16

DIM main_gui(gui_num) as GUI_element_type 'create 7 GUI elements

'GUI(1) is our main dialog box and is going to be
main_gui(1).updated = -1 'set update flag for first pass
main_gui(1).element_type = GUI_BOX
GUI_init_element main_gui(1), "Plain Box" 'set name and initalize element (Currently just set's default colors)
main_gui(1).row1 = 1  'location
main_gui(1).row2 = 25
main_gui(1).col1 = 1
main_gui(1).col2 = 80
main_gui(1).skip = -1 ' -- We don't want to be able to TAB to this gui element
main_gui(1).layer = -1 ' -- Set in background. Layer 0 is the default

main_gui(2).element_type = GUI_INPUT_BOX
GUI_init_element main_gui(2), "Input Box"
main_gui(2).row1 = 2
main_gui(2).col1 = 2
main_gui(2).col2 = 30

main_gui(3).element_type = GUI_LIST_BOX
GUI_init_element main_gui(3), "List Box"
main_gui(3).row1 = 2
main_gui(3).row2 = 20
main_gui(3).col1 = 31
main_gui(3).col2 = 79
'scroll = 1 means just vertical, scroll = 2 means just horisontal, scroll = 3 means both (Bit field)
main_gui(3).scroll = 1
'main_gui(3).scroll_max_hors = 90 'Max horisontal column to scroll to

main_gui(4).element_type = GUI_CHECKBOX
GUI_init_element main_gui(4), "CheckBox"
main_gui(4).row1 = 5
main_gui(4).col1 = 2

main_gui(5).element_type = GUI_BUTTON
GUI_init_element main_gui(5), "Button"
main_gui(5).row1 = 6
main_gui(5).col1 = 2

main_gui(6).element_type = GUI_DROP_DOWN
GUI_init_element main_gui(6), "Drop Down"
main_gui(6).row1 = 7
main_gui(6).col1 = 2
main_gui(6).row2 = 15
main_gui(6).col2 = 30
main_gui(6).scroll = 1 'just vertical scroll
main_gui(6).shadow = -1 'Draws shadow under box when drop-down is opened
main_gui(6).selected = 1 'Set the default selected item

main_gui(7).element_type = GUI_DROP_DOWN 
GUI_init_element main_gui(7), "Drop Down"
main_gui(7).row1 = 8
main_gui(7).col1 = 2
main_gui(7).row2 = 24
main_gui(7).col2 = 30
main_gui(7).scroll = 1
main_gui(7).shadow = -1
main_gui(7).selected = 1

main_gui(8).element_type = GUI_INPUT_BOX
GUI_init_element main_gui(8), "Input Box"
main_gui(8).row1 = 22
main_gui(8).col1 = 2
main_gui(8).col2 = 79

for x = 1 to 4 'group 0
  main_gui(8 + x).element_type = GUI_RADIO_BUTTON
  GUI_init_element main_gui(8 + x), "Radio Button" + str$(x)
  main_gui(8 + x).row1 = 8 + x
  main_gui(8 + x).col1 = 2
next x

for x = 1 to 4 'group 1
  main_gui(12 + x).element_type = GUI_RADIO_BUTTON
  GUI_init_element main_gui(12 + x), "Radio Button" + str$(x)
  main_gui(12 + x).row1 = 13 + x
  main_gui(12 + x).col1 = 2
  main_gui(12 + x).group = 1
next x

allocate_string_array main_gui(3).lines, 120 'Initalize arrays for elements that need them and fill then with data
allocate_string_array main_gui(6).lines, 120
allocate_string_array main_gui(7).lines, 120 
for x = 1 to 80
  put_str_array main_gui(3).lines, x, "Str:" + str$(x)
  put_str_array main_gui(6).lines, x, "Str:" + str$(x)
  put_str_array main_gui(7).lines, x, "Str:" + str$(x)
next x

main_gui(3).length = 80 'number of elements in their arrays of strings
main_gui(6).length = 80 'IE. main_gui(6) is a Drop-down and it has 80 options 
main_gui(7).length = 80

selected_gui = 1 'First selected gui element

DO
  _LIMIT 500
  
  'Update screen based on elements and events
  if GUI_update_screen(main_gui(), gui_num, selected_gui) then 
    GUI_draw_element_array main_gui(), gui_num, selected_gui
  end if

  'Mouse events
  GUI_mouse_range main_gui(), gui_num, selected_gui
  
  'Keyboard input events
  'Returns the INKEY$ result it got in-case you want to do extra actions
  ' -- For this reason don't use INKEY$ or _MOUSEINPUT outside of the GUI functions
  key$ = GUI_inkey$(main_gui(), gui_num, selected_gui)

  'manage interactions here.
  'main_gui(5) is a button, so check if it's pressed. If it's pressed, reset it's value to zero, etc.
  if main_gui(5).pressed then
    locate 23, 1
    print "Pressed! "; count;
    count = count + 1
    main_gui(5).pressed = 0
  end if
LOOP UNTIL key$ = CHR$(27) or _EXIT

GUI_free_element_array main_gui()

SYSTEM

'$include:'mem_library/mem_lib.bm'
'$include:'gui_library/gui_lib.bm'
