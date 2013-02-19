'Text editor using the GUI Library

'$include:'mem_library/mem_lib.bi'
'$include:'file_library/file_helpers.bi'
'$include:'gui_library/gui_lib.bi'

DIM SHARED main_gui_num, menu_items as integer
main_gui_num = 3
menu_items = 3

DIM main_gui(main_gui_num) AS GUI_element_type
DIM Global_menu(menu_items) as GUI_menu_item_type, menu(10, menu_items) as GUI_menu_item_type, menun(menu_items)


GUI_init

main_gui(1).element_type = GUI_MENU
GUI_init_element main_gui(1), "MENU"
main_gui(1).row1 = 1
main_gui(1).col1 = 1
main_gui(1).col2 = _WIDTH(0)
main_gui(1).menu_padding = 2

main_gui(1).shadow = -1

main_gui(2).element_type = GUI_TEXT_BOX
GUI_init_element main_gui(2), "Untitled"
main_gui(2).row1 = 2
main_gui(2).row2 = _HEIGHT(0) - 1
main_gui(2).col1 = 1
main_gui(2).col2 = _WIDTH(0)
MEM_allocate_string_array main_gui(2).lines, 120
main_gui(2).length = 1
main_gui(2).scroll = 3
main_gui(2).scroll_max_hors = 300
main_gui(2).max_lines = 0

main_gui(3).element_type = GUI_LABEL
GUI_init_element main_gui(3), space$(80)
main_gui(3).row1 = _HEIGHT(0)
main_gui(3).col1 = 1
main_gui(3).col2 = _WIDTH(0)
main_gui(3).mcolor.fr = 0
main_gui(3).mcolor.bk = 3

g = 1
MEM_put_str Global_Menu(g).nam, "#File": n = 1
Menu(n, g).ident = "OPEN ": MEM_put_str Menu(n, g).nam, "#Open            ": n = n + 1
Menu(n, g).ident = "SAVE ": MEM_put_str Menu(n, g).nam, "#Save         ": n = n + 1
Menu(n, g).ident = "SAVEA": MEM_put_str Menu(n, g).nam, "Save #As        ": n = n + 1
MEM_put_str Menu(n, g).nam, "-": n = n + 1
Menu(n, g).ident = "EXIT ": MEM_put_str Menu(n, g).nam, "E#xit                "
Menun(g) = n

g = g + 1: MEM_put_str Global_Menu(g).nam, "#Edit": n = 1
Menu(n, g).ident = "CUT  ": MEM_put_str Menu(n, g).nam, "#Cut        ": n = n + 1
Menu(n, g).ident = "COPY ": MEM_put_str Menu(n, g).nam, "C#opy        ": n = n + 1
Menu(n, g).ident = "PASTE": MEM_put_str Menu(n, g).nam, "#Paste        "
Menun(g) = n

g = g + 1: MEM_put_str Global_Menu(g).nam, "#Help": n = 1
Menu(n, g).ident = "HELP ": MEM_put_str Menu(n, g).nam, "#Help               ": n = n + 1
Menu(n, g).ident = "SETIN": MEM_put_str Menu(n, g).nam, "#Change Settings    ": n = n + 1
MEM_put_str Menu(n, g).nam, "-": n = n + 1
Menu(n, g).ident = "ABOUT": MEM_put_str Menu(n, g).nam, "#About              "
Menun(g) = n

GUI_attach_base_menu main_gui(1), g, _OFFSET(Global_Menu(1))
FOR x = 1 to g
  GUI_attach_menu Global_Menu(x), Menun(x), _OFFSET(Menu(1, x))
next x

DO
  _LIMIT 300

  if GUI_update_screen(main_gui(), main_gui_num, selected_gui) then
    GUI_draw_element_array main_gui(), main_gui_num, selected_gui
  end if

  GUI_mouse_range main_gui(), main_gui_num, selected_gui

  a$ = GUI_inkey$(main_gui(), main_gui_num, selected_gui)

  'select case a$
  '  case "A"
  '
  'end select
  if main_gui(1).menu_chosen then
    main_gui(1).menu_chosen = 0
    i$ = main_gui(1).menu_choice
    GUI_draw_element_array main_gui(), main_gui_num, selected_gui

    if i$ = "EXIT " then exit_flag = -1
    if i$ = "OPEN " then
      f$ = open_file$("/home/dsman195276", "All Files| |QB64 File|*.bas|QB64 Include|*.bm *.bi|C++ Source|*.cpp|C/C++ Header|*.h *.hpp")
    end if
  end if
LOOP until exit_flag or _EXIT

SYSTEM


'$include:'mem_library/mem_lib.bm'
'$include:'file_library/file_helpers.bm'
'$include:'gui_library/gui_lib.bm'

'$include:'dialogs/open_save_file.bm'
