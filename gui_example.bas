'GUI TEST PROGRAM
'Used to test functionality of GUI library

'$include:'mem_library/mem_lib.bi'
'$include:'gui_library/gui_lib.bi'
'$include:'dialogs/prompt.bi'

$CONSOLE

GUI_init

gui_num = 25

DIM main_gui(gui_num) as GUI_element_type 'create 25 GUI elements
DIM buttons(3) AS INTEGER
DIM labels(4) AS INTEGER 'Will hold the GUI numbers for 4 labels we have
DIM click_count(3) AS INTEGER
DIM base_menu(4) as GUI_menu_item_type
'DIM sub_menus(5, 10) as GUI_menu_item_type
DIM file_menu(10) as GUI_menu_item_type
DIM edit_menu(10) as GUI_menu_item_type
DIM search_menu(10) as GUI_menu_item_type
DIM tools_menu(10) as GUI_menu_item_type
DIM help_menu(10) as GUI_menu_item_type

print "Size: "; len(main_gui(1))
sleep


'GUI(1) is our main dialog box and is going to be
g = 1
main_gui(g).element_type = GUI_MENU
GUI_init_element main_gui(g), "Menu"
main_gui(g).row1 = 1
main_gui(g).col1 = 1
main_gui(g).col2 = 80
main_gui(g).menu_padding = 2
'main_gui(g).skip = -1
'main_gui(g).shadow = -1
main_gui(g).flags = main_gui(g).flags OR GUI_FLAG_SKIP OR GUI_FLAG_SHADOW

MEM_put_str base_menu(1).nam, "#File"
base_menu(1).ident = "File "
MEM_put_str base_menu(2).nam, "#Edit"
base_menu(2).ident = "Edit "
MEM_put_str base_menu(3).nam, "#Search"
base_menu(3).ident = "Searc"
MEM_put_str base_menu(4).nam, "#Help"
base_menu(4).ident = "Help "
GUI_attach_base_menu main_gui(g), 4, _OFFSET(base_menu(1))

m=0
m=m+1: MEM_put_str file_menu(m).nam, "#New         ": file_menu(m).ident = "NEW  "
m=m+1: MEM_put_str file_menu(m).nam, "#Open": file_menu(m).ident = "OPEN "
m=m+1: MEM_put_str file_menu(m).nam, "#Connect": file_menu(m).ident = "CONEC"
m=m+1: MEM_put_str file_menu(m).nam, "-"
m=m+1: MEM_put_str file_menu(m).nam, "#Save": file_menu(m).ident = "SAVE "
m=m+1: MEM_put_str file_menu(m).nam, "S#ave As": file_menu(m).ident = "SAVEA"
m=m+1: MEM_put_str file_menu(m).nam, "-"
m=m+1: MEM_put_str file_menu(m).nam, "#Exit": file_menu(m).ident = "EXIT "
GUI_attach_menu base_menu(1), m, _OFFSET(file_menu(1))

m=0
m=m+1: MEM_put_str edit_menu(m).nam, "#Cut": edit_menu(m).ident = "CUT  "
m=m+1: MEM_put_str edit_menu(m).nam, "#Copy": edit_menu(m).ident = "COPY "
m=m+1: MEM_put_str edit_menu(m).nam, "#Paste": edit_menu(m).ident = "PASTE"
m=m+1: MEM_put_str edit_menu(m).nam, "#Delete": edit_menu(m).ident = "DELET"
m=m+1: MEM_put_str edit_menu(m).nam, "-"
m=m+1: MEM_put_str edit_menu(m).nam, "#Rename": edit_menu(m).ident = "RENAM"
m=m+1: MEM_put_str edit_menu(m).nam, "#Select All": edit_menu(m).ident = "SELAL"
GUI_attach_menu base_menu(2), m, _OFFSET(edit_menu(1))

m=0
m=m+1: MEM_put_str search_menu(m).nam, "#Find": search_menu(m).ident = "FIND "
m=m+1: MEM_put_str search_menu(m).nam, "Find #Next": search_menu(m).ident = "FINDN"
m=m+1: MEM_put_str search_menu(m).nam, "Find #Previous": search_menu(m).ident = "FINDP"
m=m+1: MEM_put_str search_menu(m).nam, "-"
m=m+1: MEM_put_str search_menu(m).nam, "#Replace": search_menu(m).ident = "REPLA"
GUI_attach_menu base_menu(3), m, _OFFSET(search_menu(1))

m=0
m=m+1: MEM_put_str help_menu(m).nam, "#Help": help_menu(m).ident = "HELP "
m=m+1: MEM_put_str help_menu(m).nam, "-"
m=m+1: MEM_put_str help_menu(m).nam, "#About     ": help_menu(m).ident = "ABOUT"
GUI_attach_menu base_menu(4), m, _OFFSET(help_menu(1))

g=g+1
main_gui(g).element_type = GUI_BOX
GUI_init_element main_gui(g), "Plain Box"
main_gui(g).row1 = 2  'location
main_gui(g).row2 = 25
main_gui(g).col1 = 1
main_gui(g).col2 = 80
main_gui(g).layer = -1 ' -- Set in background. Layer 0 is the default
'main_gui(g).skip = -1 ' -- We don't want to be able to TAB to this gui element
'main_gui(g).hide = -1 ' -- Don't draw box characters or box name, etc.
main_gui(g).flags = main_gui(g).flags OR GUI_FLAG_SKIP OR GUI_FLAG_HIDE

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
'main_gui(g).scroll = 1
main_gui(g).flags = main_gui(g).flags OR GUI_FLAG_SCROLL_V

MEM_allocate_string_array main_gui(g).lines, 120
main_gui(g).length = 80
for x = 1 to 80
  MEM_put_str_array main_gui(g).lines, x, "Str:" + str$(x)
next x
list_box_n = g
'main_gui(g).scroll_max_hors = 90 'Max horisontal column to scroll to

g=g+1
main_gui(g).element_type = GUI_CHECKBOX 'Initalize a few Checkbox's
GUI_init_element main_gui(g), "CheckBox1"
main_gui(g).row1 = 6 'Location
main_gui(g).col1 = 2

g=g+1
main_gui(g).element_type = GUI_CHECKBOX 'Same as the last one
GUI_init_element main_gui(g), "CheckBox2"
main_gui(g).row1 = 6
main_gui(g).col1 = 20

g=g+1
main_gui(g).element_type = GUI_BUTTON 'Initalize some buttons -- Virtually the same as buttons
GUI_init_element main_gui(g), "Button"
main_gui(g).row1 = 7 'Location
main_gui(g).col1 = 2
buttons(1) = g 'Store main_gui() number for later use

g=g+1
main_gui(g).element_type = GUI_BUTTON 'Same as before
GUI_init_element main_gui(g), "Button2"
main_gui(g).row1 = 7
main_gui(g).col1 = 15
buttons(2) = g

g=g+1
main_gui(g).element_type = GUI_BUTTON 'Same as before
GUI_init_element main_gui(g), "Button3"
main_gui(g).row1 = 7
main_gui(g).col1 = 31
buttons(3) = g


g=g+1
main_gui(g).element_type = GUI_DROP_DOWN 'Initalize a drop-down selection
GUI_init_element main_gui(g), "Drop Down"
main_gui(g).row1 = 8
main_gui(g).col1 = 2

main_gui(g).row2 = 15 '<-- These cords will be used to draw the drop-down box when it is open
main_gui(g).col2 = 40 '<--

'main_gui(g).scroll = 1 '1 means just vertical scroll (No hoisontal)
'main_gui(g).shadow = -1 'Draws shadow under box when drop-down is opened
main_gui(g).flags = main_gui(g).flags OR GUI_FLAG_SCROLL_V OR GUI_FLAG_SHADOW
main_gui(g).selected = 1 'Set the default selected item
'allocate space for the items in the drop-down
MEM_allocate_string_array main_gui(g).lines, 80
main_gui(g).length = 80 'Set the actual number of items in the drop down
for x = 1 to 80 'Fill array with some items
  MEM_put_str_array main_gui(g).lines, x, "Str:" + str$(x)
next x


g=g+1
main_gui(g).element_type = GUI_DROP_DOWN 'Almost exactly the same as before
GUI_init_element main_gui(g), "Drop Down"
main_gui(g).row1 = 9
main_gui(g).col1 = 2
main_gui(g).row2 = 24 'A larger row2 value will result in a bigger drop-down box
main_gui(g).col2 = 40
'main_gui(g).scroll = 1
'main_gui(g).shadow = -1
main_gui(g).flags = main_gui(g).flags OR GUI_FLAG_SCROLL_V OR GUI_FLAG_SHADOW
main_gui(g).selected = 1
MEM_allocate_string_array main_gui(g).lines, 80
main_gui(g).length = 80
for x = 1 to 80
  MEM_put_str_array main_gui(g).lines, x, "Str:" + str$(x)
next x

for x = 1 to 4 'group 0
  g=g+1
  main_gui(g).element_type = GUI_RADIO_BUTTON 'Initalize 4 radio buttons linked by their group number
  GUI_init_element main_gui(g), "Radio Button" + str$(x)
  main_gui(g).row1 = 9 + x
  main_gui(g).col1 = 2
next x

for x = 1 to 4 'group 1
  g=g+1
  main_gui(g).element_type = GUI_RADIO_BUTTON 'Same as before, but different group number
  GUI_init_element main_gui(g), "Radio Button" + str$(x)
  main_gui(g).row1 = 14 + x
  main_gui(g).col1 = 2
  main_gui(g).group = 1
next x

FOR x = 1 to 4
  g=g+1
  main_gui(g).element_type = GUI_LABEL 'Initalize 4 lables via a loop
  GUI_init_element main_gui(g), ""
  main_gui(g).row1 = 18 + x
  main_gui(g).col1 = 2
  labels(x) = g 'Store it's main_gui() element number for later use
NEXT x

g=g+1
main_gui(g).element_type = GUI_TEXT_BOX 'Initalize a Text-Box
GUI_init_element main_gui(g), "Text Box"

main_gui(g).row1 = 11 'location
main_gui(g).row2 = 22
main_gui(g).col1 = 41
main_gui(g).col2 = 80
'scroll = 1 means just vertical, scroll = 2 means just horisontal, scroll = 3 means both (Bit field)
'main_gui(g).scroll = 3
main_gui(g).flags = main_gui(g).flags OR GUI_FLAG_SCROLL_V OR GUI_FLAG_SCROLL_H
'We allocate 120 Lines for the array (main_gui(g).lines won't be allocated for you, but it may be reallocated if you allow it)
'Just set this to a reasonable value for your program.
MEM_allocate_string_array main_gui(g).lines, 120
'Setting this to zero (It's default) means main_gui(g).lines will be reallocated if needed
'The user could technically use all his memory if he allocates to many lines
'But he'll probably reach the max length value before that happens...
main_gui(g).max_lines = 0
main_gui(g).length = 10 'Only display 10 lines since only 10 lines will have data in the beginning
'Length will be dynamically changed based on the input (If a line is deleted, for instance, length will go down)
'Length will never go higher then max_lines though, unless max_lines = 0.
'You can set length without putting anything into the MEM_string_type's  in the main_gui(g).lines array

'scroll_max_hors represents the max hosisontal scroll distance (Or, the max length of each string you display)
main_gui(g).scroll_max_hors = 120

for x = 1 to 10 'Fill the first 10 lines with some data.
  MEM_put_str_array main_gui(g).lines, x, "Str:" + str$(x)
next x

g=g+1
main_gui(g).element_type = GUI_INPUT_BOX 'One extra Input box for good measure ;)
GUI_init_element main_gui(g), "Input Box"
main_gui(g).row1 = 23
main_gui(g).col1 = 1
main_gui(g).col2 = 80


'selected_gui = 0 'First selected gui element

DO 'Main loop

  'Reduce CPU usage
  ' -- May need to be increased if there are tons of GUI elements, but low numbers seem to do fine
  ' -- This program has 25 GUI elements, probably more then you'll ever come across, so with that in mind
  ' The Limit doesn't need to be that big.
  _LIMIT 200

  'Check if we should update screen because an event happened or otherwise
  if GUI_update_screen(main_gui(), gui_num, selected_gui) then
    'Redraw screen (May be improved in the future but currently redraws the entire screen)
    GUI_draw_element_array main_gui(), gui_num, selected_gui
  end if

  'Mouse events
  g_clicked = GUI_mouse_range(main_gui(), gui_num, selected_gui)

  'Keyboard input events
  'Returns the INKEY$ result it got in-case you want to do extra actions
  ' -- For this reason don't use INKEY$ or _MOUSEINPUT outside of the GUI functions
  key$ = GUI_inkey$(main_gui(), gui_num, selected_gui)

  SELECT CASE key$ 'In this example I'll do extra checking for the ESC key.
    CASE CHR$(27) 'ESC key
      exit_flag = -1
  END SELECT

  'manage interactions here.
  for x = 1 to 3 'This loop checks the three buttons we have
    if buttons(x) = g_clicked then
      click_count(x) = click_count(x) + 1
      'We're setting the string in a label and then marking it to be updated
      MEM_put_str main_gui(labels(x)).text, "Button" + str$(x) + " :" + str$(click_count(x)) + " Times!"
      'main_gui(labels(x)).updated = -1
      main_gui(labels(x)).flags = main_gui(labels(x)).flags OR GUI_FLAG_UPDATED
      'main_gui(buttons(x)).pressed = 0 'Reset the button to 0 so we don't end up catching it a second time
    end if
  next x
  if main_gui(1).flags AND GUI_FLAG_MENU_CHOSEN then 'Check our menu
    MEM_put_str main_gui(labels(4)).text, "Menu Chosen: " + main_gui(1).menu_choice
    main_gui(1).flags = main_gui(1).flags AND NOT GUI_FLAG_MENU_CHOSEN 'Reset the menu so we don't enter this IF again
    i$ = main_gui(1).menu_choice
    'main_gui(1).updated = -1 'set menu to updated
    main_gui(1).flags = main_gui(1).flags OR GUI_FLAG_UPDATED
    'Redraw screen so menu doesn't show before opening menu choice
    GUI_draw_element_array main_gui(), gui_num, selected_gui

    if i$ = "EXIT " then exit_flag = -1 '"EXIT " is for the EXIT menu option -- So set our exit_flag variable
    if i$ = "ABOUT" then
      'about_dialog
    end if
    if i$ = "RENAM" then
      'rename_file_GUI 0
    end if
    if i$ = "OPEN " then
      'prompt = prompt_dialog("Test Dialog"+chr$(13) + "Line 2", 10, OK_BUTTON OR CLOSE_BUTTON, OK_BUTTON)
    end if
    if i$ = "CONEC" then
      'Connect_To_FTP
    end if
    if i$ = "HELP " then
      'popup_dialog_gui "Not Implemented Yet."
    end if
  end if
LOOP UNTIL exit_flag = -1 or _EXIT

'Free the array of elements
GUI_free_element_array main_gui()

SYSTEM

sub debug_print (p$)
_DEST _CONSOLE
print p$
_DEST 0
END SUB

'$include:'mem_library/mem_lib.bm'
'$include:'gui_library/gui_lib.bm'
''$include:'dialogs/about.bm'
''$include:'dialogs/rename_file.bm'
''$include:'dialogs/prompt.bm'
''$include:'dialogs/ftp_connect.bm'
''$include:'dialogs/dialog_simple.bm'
