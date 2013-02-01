'GUI TEST PROGRAM
'Used to test functionality of GUI library

'$include:'mem_library/mem_lib.bi'
'$include:'gui_library/gui_lib.bi'

GUI_init

gui_num = 25

DIM main_gui(gui_num) as GUI_element_type 'create 7 GUI elements
DIM buttons(3) AS INTEGER 
DIM labels(4) AS INTEGER 'Will hold the GUI numbers for 3 labels we have
DIM click_count(3) AS INTEGER
DIM base_menu(4) as GUI_menu_item_type
'DIM sub_menus(5, 10) as GUI_menu_item_type
DIM file_menu(10) as GUI_menu_item_type
DIM edit_menu(10) as GUI_menu_item_type
DIM search_menu(10) as GUI_menu_item_type
DIM tools_menu(10) as GUI_menu_item_type
DIM help_menu(10) as GUI_menu_item_type

'GUI(1) is our main dialog box and is going to be
g = 1
main_gui(g).element_type = GUI_MENU
GUI_init_element main_gui(g), "Menu"
main_gui(g).row1 = 1
main_gui(g).col1 = 1
main_gui(g).col2 = 80
main_gui(g).menu_padding = 2
main_gui(g).skip = -1
main_gui(g).shadow = -1

put_str base_menu(1).nam, "#File"
base_menu(1).ident = "File "
put_str base_menu(2).nam, "#Edit"
base_menu(2).ident = "Edit "
put_str base_menu(3).nam, "#Search"
base_menu(3).ident = "Searc"
put_str base_menu(4).nam, "#Help"
base_menu(4).ident = "Help "
GUI_attach_base_menu main_gui(g), 4, _OFFSET(base_menu(1))

m=0
m=m+1: put_str file_menu(m).nam, "#New         ": file_menu(m).ident = "NEW  "
m=m+1: put_str file_menu(m).nam, "#Open": file_menu(m).ident = "OPEN "
m=m+1: put_str file_menu(m).nam, "-"
m=m+1: put_str file_menu(m).nam, "#Save": file_menu(m).ident = "SAVE "
m=m+1: put_str file_menu(m).nam, "S#ave As": file_menu(m).ident = "SAVEA"
m=m+1: put_str file_menu(m).nam, "-"
m=m+1: put_str file_menu(m).nam, "#Exit": file_menu(m).ident = "EXIT "
GUI_attach_menu base_menu(1), m, _OFFSET(file_menu(1))

m=0
m=m+1: put_str edit_menu(m).nam, "#Cut": edit_menu(m).ident = "CUT  "
m=m+1: put_str edit_menu(m).nam, "#Copy": edit_menu(m).ident = "COPY "
m=m+1: put_str edit_menu(m).nam, "#Paste": edit_menu(m).ident = "PASTE"
m=m+1: put_str edit_menu(m).nam, "#Delete": edit_menu(m).ident = "DELET"
m=m+1: put_str edit_menu(m).nam, "-"
m=m+1: put_str edit_menu(m).nam, "#Select All": edit_menu(m).ident = "SELAL"
GUI_attach_menu base_menu(2), m, _OFFSET(edit_menu(1))

m=0
m=m+1: put_str search_menu(m).nam, "#Find": search_menu(m).ident = "FIND "
m=m+1: put_str search_menu(m).nam, "Find #Next": search_menu(m).ident = "FINDN"
m=m+1: put_str search_menu(m).nam, "Find #Previous": search_menu(m).ident = "FINDP"
m=m+1: put_str search_menu(m).nam, "-"
m=m+1: put_str search_menu(m).nam, "#Replace": search_menu(m).ident = "REPLA"
GUI_attach_menu base_menu(3), m, _OFFSET(search_menu(1))

m=0
m=m+1: put_str help_menu(m).nam, "#Help": help_menu(m).ident = "HELP "
m=m+1: put_str help_menu(m).nam, "-"
m=m+1: put_str help_menu(m).nam, "#About     ": help_menu(m).ident = "ABOUT"
GUI_attach_menu base_menu(4), m, _OFFSET(help_menu(1))

g=g+1
main_gui(g).updated = -1 'set update flag for first pass
main_gui(g).element_type = GUI_BOX
GUI_init_element main_gui(g), "Plain Box" 'set name and initalize element (Currently just set's default colors)
main_gui(g).row1 = 2  'location
main_gui(g).row2 = 25
main_gui(g).col1 = 1
main_gui(g).col2 = 80
main_gui(g).skip = -1 ' -- We don't want to be able to TAB to this gui element
main_gui(g).layer = -1 ' -- Set in background. Layer 0 is the default
main_gui(g).hide = -1 ' -- Don't draw box characters or box name, etc.

g=g+1
main_gui(g).element_type = GUI_INPUT_BOX
GUI_init_element main_gui(g), "Input Box"
main_gui(g).row1 = 2
main_gui(g).col1 = 1
main_gui(g).col2 = 40

g=g+1
main_gui(g).element_type = GUI_LIST_BOX
GUI_init_element main_gui(g), "List Box"
main_gui(g).row1 = 2
main_gui(g).row2 = 10
main_gui(g).col1 = 41
main_gui(g).col2 = 80
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
main_gui(g).row1 = 6
main_gui(g).col1 = 2

g=g+1
main_gui(g).element_type = GUI_CHECKBOX
GUI_init_element main_gui(g), "CheckBox2"
main_gui(g).row1 = 6
main_gui(g).col1 = 20

g=g+1
main_gui(g).element_type = GUI_BUTTON
GUI_init_element main_gui(g), "Button"
main_gui(g).row1 = 7
main_gui(g).col1 = 2
buttons(1) = g

g=g+1
main_gui(g).element_type = GUI_BUTTON
GUI_init_element main_gui(g), "Button2"
main_gui(g).row1 = 7
main_gui(g).col1 = 15
buttons(2) = g

g=g+1
main_gui(g).element_type = GUI_BUTTON
GUI_init_element main_gui(g), "Button3"
main_gui(g).row1 = 7
main_gui(g).col1 = 31
buttons(3) = g


g=g+1
main_gui(g).element_type = GUI_DROP_DOWN
GUI_init_element main_gui(g), "Drop Down"
main_gui(g).row1 = 8
main_gui(g).col1 = 2
main_gui(g).row2 = 15
main_gui(g).col2 = 40
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
main_gui(g).row1 = 9
main_gui(g).col1 = 2
main_gui(g).row2 = 24
main_gui(g).col2 = 40
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
main_gui(g).row1 = 23
main_gui(g).col1 = 1
main_gui(g).col2 = 80

for x = 1 to 4 'group 0
  g=g+1
  main_gui(g).element_type = GUI_RADIO_BUTTON
  GUI_init_element main_gui(g), "Radio Button" + str$(x)
  main_gui(g).row1 = 9 + x
  main_gui(g).col1 = 2
next x

for x = 1 to 4 'group 1
  g=g+1
  main_gui(g).element_type = GUI_RADIO_BUTTON
  GUI_init_element main_gui(g), "Radio Button" + str$(x)
  main_gui(g).row1 = 14 + x
  main_gui(g).col1 = 2
  main_gui(g).group = 2
next x

FOR x = 1 to 4
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
main_gui(g).row2 = 22
main_gui(g).col1 = 41
main_gui(g).col2 = 80
'scroll = 1 means just vertical, scroll = 2 means just horisontal, scroll = 3 means both (Bit field)
main_gui(g).scroll = 3
allocate_string_array main_gui(g).lines, 120
main_gui(g).length = 10
main_gui(g).scroll_max_hors = 120
for x = 1 to 10
  put_str_array main_gui(g).lines, x, "Str:" + str$(x)
next x


 'Initalize arrays for elements that need them and fill then with random data


'selected_gui = 0 'First selected gui element

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
  if main_gui(1).menu_chosen then
    put_str main_gui(labels(4)).nam, "Menu Chosen: " + main_gui(1).menu_choice
    main_gui(1).menu_chosen = 0
    i$ = main_gui(1).menu_choice
  end if
LOOP UNTIL key$ = CHR$(27) or _EXIT OR i$ = "EXIT "

GUI_free_element_array main_gui()

SYSTEM

'$include:'mem_library/mem_lib.bm'
'$include:'gui_library/gui_lib.bm'
