'GUI TEST PROGRAM
'Used to test functionality of GUI library

'$include:'mem_library/mem_lib.bi'
'$include:'gui_library/gui_lib.bi'

GUI_init

gui_num = 24

DIM main_gui(gui_num) as GUI_element_type 'create 7 GUI elements
DIM buttons(3) AS INTEGER 
DIM labels(3) AS INTEGER 'Will hold the GUI numbers for 3 labels we have
DIM click_count(3) AS INTEGER
DIM base_menu(5) as GUI_menu_item_type
DIM sub_menus(5, 10) as GUI_menu_item_type


'GUI(1) is our main dialog box and is going to be
g = 1
main_gui(g).element_type = GUI_MENU
GUI_init_element main_gui(g), "Menu"
main_gui(g).row1 = 1
main_gui(g).col1 = 1
main_gui(g).col2 = 80
main_gui(g).menu_padding = 2

put_str base_menu(1).nam, "#File"
base_menu(1).ident = "File "
put_str base_menu(2).nam, "#Edit"
base_menu(2).ident = "Edit "
put_str base_menu(3).nam, "#Search"
base_menu(3).ident = "Searc"
put_str base_menu(4).nam, "#Tools"
base_menu(4).ident = "Tools"
put_str base_menu(5).nam, "#Help"
base_menu(5).ident = "Help "

GUI_attach_base_menu main_gui(g), 5, _OFFSET(base_menu(1))
put_str sub_menus(1, 1).nam, "#New"
put_str sub_menus(1, 2).nam, "#Open"
put_str sub_menus(1, 3).nam, "-"
put_str sub_menus(1, 4).nam, "#Save"
put_str sub_menus(1, 5).nam, "S#ave As"
put_str sub_menus(1, 6).nam, "-"
put_str sub_menus(1, 7).nam, "#Exit"
GUI_attach_menu base_menu(1), 7, _OFFSET(sub_menus(1, 1))

put_str sub_menus(2, 1).nam, "#Cut"
put_str sub_menus(2, 2).nam, "#Copy"
put_str sub_menus(2, 3).nam, "#Paste"
put_str sub_menus(2, 4).nam, "#Delete"
GUI_attach_menu base_menu(2), 4, _OFFSET(sub_menus(2, 1))

put_str sub_menus(3, 1).nam, "#Cut"
put_str sub_menus(3, 2).nam, "#Copy"
put_str sub_menus(3, 3).nam, "#Paste"
put_str sub_menus(3, 4).nam, "#Delete"
GUI_attach_menu base_menu(3), 4, _OFFSET(sub_menus(3, 1))

put_str sub_menus(4, 1).nam, "#Cut"
put_str sub_menus(4, 2).nam, "#Copy"
put_str sub_menus(4, 3).nam, "#Paste"
put_str sub_menus(4, 4).nam, "#Delete"
GUI_attach_menu base_menu(4), 4, _OFFSET(sub_menus(4, 1))

put_str sub_menus(5, 1).nam, "#Cut"
put_str sub_menus(5, 2).nam, "#Copy"
put_str sub_menus(5, 3).nam, "#Paste"
put_str sub_menus(5, 4).nam, "#Delete"
GUI_attach_menu base_menu(5), 4, _OFFSET(sub_menus(5, 1))

g=g+1
main_gui(g).updated = -1 'set update flag for first pass
main_gui(g).element_type = GUI_BOX
GUI_init_element main_gui(g), "Plain Box" 'set name and initalize element (Currently just set's default colors)
main_gui(g).row1 = 1  'location
main_gui(g).row2 = 25
main_gui(g).col1 = 1
main_gui(g).col2 = 80
main_gui(g).skip = -1 ' -- We don't want to be able to TAB to this gui element
main_gui(g).layer = -1 ' -- Set in background. Layer 0 is the default

g=g+1
main_gui(g).element_type = GUI_INPUT_BOX
GUI_init_element main_gui(g), "Input Box"
main_gui(g).row1 = 2
main_gui(g).col1 = 2
main_gui(g).col2 = 30

g=g+1
main_gui(g).element_type = GUI_LIST_BOX
GUI_init_element main_gui(g), "List Box"
main_gui(g).row1 = 2
main_gui(g).row2 = 10
main_gui(g).col1 = 31
main_gui(g).col2 = 79
'scroll = 1 means just vertical, scroll = 2 means just horisontal, scroll = 3 means both (Bit field)
main_gui(g).scroll = 1
allocate_string_array main_gui(g).lines, 120
main_gui(g).length = 80
for x = 1 to 80
  put_str_array main_gui(g).lines, x, "Str:" + str$(x)
next x
'main_gui(g).scroll_max_hors = 90 'Max horisontal column to scroll to

g=g+1
main_gui(g).element_type = GUI_CHECKBOX
GUI_init_element main_gui(g), "CheckBox1"
main_gui(g).row1 = 5
main_gui(g).col1 = 2

g=g+1
main_gui(g).element_type = GUI_CHECKBOX
GUI_init_element main_gui(g), "CheckBox2"
main_gui(g).row1 = 5
main_gui(g).col1 = 16

g=g+1
main_gui(g).element_type = GUI_BUTTON
GUI_init_element main_gui(g), "Button"
main_gui(g).row1 = 6
main_gui(g).col1 = 2
buttons(1) = g

g=g+1
main_gui(g).element_type = GUI_BUTTON
GUI_init_element main_gui(g), "Button2"
main_gui(g).row1 = 6
main_gui(g).col1 = 11
buttons(2) = g

g=g+1
main_gui(g).element_type = GUI_BUTTON
GUI_init_element main_gui(g), "Button3"
main_gui(g).row1 = 6
main_gui(g).col1 = 21
buttons(3) = g


g=g+1
main_gui(g).element_type = GUI_DROP_DOWN
GUI_init_element main_gui(g), "Drop Down"
main_gui(g).row1 = 7
main_gui(g).col1 = 2
main_gui(g).row2 = 15
main_gui(g).col2 = 30
main_gui(g).scroll = 1 'just vertical scroll
main_gui(g).shadow = -1 'Draws shadow under box when drop-down is opened
main_gui(g).selected = 1 'Set the default selected item
allocate_string_array main_gui(g).lines, 120
main_gui(g).length = 80
for x = 1 to 80
  put_str_array main_gui(g).lines, x, "Str:" + str$(x)
next x


g=g+1
main_gui(g).element_type = GUI_DROP_DOWN 
GUI_init_element main_gui(g), "Drop Down"
main_gui(g).row1 = 8
main_gui(g).col1 = 2
main_gui(g).row2 = 24
main_gui(g).col2 = 30
main_gui(g).scroll = 1
main_gui(g).shadow = -1
main_gui(g).selected = 1
allocate_string_array main_gui(g).lines, 120 
main_gui(g).length = 80
for x = 1 to 80
  put_str_array main_gui(g).lines, x, "Str:" + str$(x)
next x


g=g+1
main_gui(g).element_type = GUI_INPUT_BOX
GUI_init_element main_gui(g), "Input Box"
main_gui(g).row1 = 22
main_gui(g).col1 = 2
main_gui(g).col2 = 79

for x = 1 to 4 'group 0
  g=g+1
  main_gui(g).element_type = GUI_RADIO_BUTTON
  GUI_init_element main_gui(g), "Radio Button" + str$(x)
  main_gui(g).row1 = 8 + x
  main_gui(g).col1 = 2
next x

for x = 1 to 4 'group 1
  g=g+1
  main_gui(g).element_type = GUI_RADIO_BUTTON
  GUI_init_element main_gui(g), "Radio Button" + str$(x)
  main_gui(g).row1 = 13 + x
  main_gui(g).col1 = 2
  main_gui(g).group = 1
next x

FOR x = 1 to 3
  g=g+1
  main_gui(g).element_type = GUI_LABEL
  GUI_init_element main_gui(g), ""
  main_gui(g).row1 = 18 + x
  main_gui(g).col1 = 2 ' + (x - 1) * (78 / 3)
  labels(x) = g
NEXT x

g=g+1
main_gui(g).element_type = GUI_TEXT_BOX
GUI_init_element main_gui(g), "Text Box"
main_gui(g).row1 = 11
main_gui(g).row2 = 21
main_gui(g).col1 = 31
main_gui(g).col2 = 79
'scroll = 1 means just vertical, scroll = 2 means just horisontal, scroll = 3 means both (Bit field)
main_gui(g).scroll = 3
allocate_string_array main_gui(g).lines, 120
main_gui(g).length = 20
main_gui(g).scroll_max_hors = 120
for x = 1 to 10
  put_str_array main_gui(g).lines, x, "Str:" + str$(x)
next x


 'Initalize arrays for elements that need them and fill then with random data


selected_gui = 1 'First selected gui element

DO
  _LIMIT 1000
  
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
  for x = 1 to 3
    if main_gui(buttons(x)).pressed then
      click_count(x) = click_count(x) + 1
      put_str main_gui(labels(x)).nam, "Button" + str$(x) + " :" + str$(click_count(x)) + " Times!"
      main_gui(labels(x)).updated = -1
      main_gui(buttons(x)).pressed = 0
    end if
  next x
LOOP UNTIL key$ = CHR$(27) or _EXIT

GUI_free_element_array main_gui()

SYSTEM

'$include:'mem_library/mem_lib.bm'
'$include:'gui_library/gui_lib.bm'
