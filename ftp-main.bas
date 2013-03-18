'FTP Client
'Copyright Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

'Basically -- You just do what you want. It's fairly simple.
'I wouldn't mind a mention if you use this code, but it's by no means required.

'Thanks to DAV and the Wiki for this code
'DECLARE LIBRARY
'  FUNCTION GetLogicalDriveStringsA(BYVAL nBuff AS LONG, lpbuff AS STRING)
'END DECLARE

$SCREENHIDE
$CONSOLE

CONST VER$ = "0.98"

'$include:'mem_library/mem_lib.bi'
'$include:'file_library/file_helpers.bi'
'$include:'gui_library/gui_lib.bi'
'$include:'ftp_library/ftp_lib.bi'
'$include:'dialogs/prompt.bi'

GUI_init

'program globals, not part of library
COMMON SHARED scrnw, scrnh, scrn&
COMMON SHARED command_connect&, data_connect&, server$, username$, password$, port$
COMMON SHARED Remote_dir$, Local_dir$, temp_dir$
COMMON SHARED server_syst$
COMMON SHARED opper$, sep$

COMMON SHARED locrow, loccol, butflag AS INTEGER
COMMON SHARED main_menu_len AS INTEGER, status$, crlf$, cmd$
COMMON SHARED pasv_mode AS INTEGER, cmd_mode AS INTEGER, err_flag, cmd_count

COMMON SHARED show_hidden_local AS INTEGER, show_hidden_remote AS INTEGER
COMMON SHARED CLI, CONFIG

CONST BOXES = 7 'Don't change  -- number of GUI elements in main dialog
CONST g_menu_c = 5 'Number of global menu choices

DIM SHARED boxes(BOXES) AS GUI_element_type, global_selected_gui

DIM SHARED Remote_files(500) AS filedir_type, Local_files(1000) AS filedir_type 'Change this number for more files
'DIM SHARED global_menu_sel, menu_sel, menu_max_len(g_menu_c), temp_menu_sel, menux AS box_type

'$include:'settings.bi'

'$include:'help/setup_help.bm'

IF CLI THEN
  'command_line
  SYSTEM
ELSE
  _CONSOLE OFF
  _SCREENSHOW
END IF

'Load config file
IF CONFIG THEN
  read_config_file
END IF

boxes(1).element_type = GUI_LIST_BOX
GUI_init_element boxes(1), "Local"
boxes(1).length = 0

boxes(2).element_type = GUI_LIST_BOX
GUI_init_element boxes(2), "Remote"
boxes(2).length = 0

boxes(3).element_type = GUI_LABEL
GUI_init_element boxes(3), ""
MEM_put_str boxes(3).text, space$(_WIDTH(0))
boxes(3).flags = boxes(3).flags OR GUI_FLAG_SKIP
'boxes(3).skip = -1

boxes(4).element_type = GUI_LABEL
GUI_init_element boxes(4), ""
boxes(4).flags = boxes(4).flags OR GUI_FLAG_SKIP
'boxes(4).skip = -1

boxes(5).element_type = GUI_LABEL
GUI_init_element boxes(5), ""
boxes(5).flags = boxes(5).flags OR GUI_FLAG_SKIP
'boxes(5).skip = -1

boxes(6).element_type = GUI_MENU
GUI_init_element boxes(6), "Menu"
boxes(6).flags = boxes(6).flags OR GUI_FLAG_SHADOW OR GUI_FLAG_MENU_LAST_ON_RIGHT
'boxes(6).shadow = -1

boxes(7).element_type = GUI_BOX
GUI_init_element boxes(7), "Box"
boxes(7).flags = boxes(7).flags OR GUI_FLAG_HIDE OR GUI_FLAG_SKIP
'boxes(7).hide = -1
boxes(7).layer = -1
'boxes(7).skip = -1

MEM_allocate_string_array boxes(1).lines, 120
MEM_allocate_string_array boxes(2).lines, 120

setup_main_GUI

DIM SHARED Global_Menu(g_menu_c) as GUI_menu_item_type, Menu(9, g_menu_c) AS GUI_menu_item_type, Menun(g_menu_c)

g = 1
MEM_put_str Global_Menu(g).nam, "#File": n = 1
Menu(n, g).ident = "CONEC": MEM_put_str Menu(n, g).nam, "#Connect             ": n = n + 1
Menu(n, g).ident = "DISCO": MEM_put_str Menu(n, g).nam, "#Disconnect          ": n = n + 1
Menu(n, g).ident = "CMDLN": MEM_put_str Menu(n, g).nam, "C#ommand Line        ": n = n + 1
MEM_put_str Menu(n, g).nam, "-": n = n + 1
Menu(n, g).ident = "EXIT ": MEM_put_str Menu(n, g).nam, "E#xit                "
Menun(g) = n

g = g + 1: MEM_put_str Global_Menu(g).nam, "#Local": n = 1
Menu(n, g).ident = "LREFR": MEM_put_str Menu(n, g).nam, "#Refresh Files        ": n = n + 1
MEM_put_str Menu(n, g).nam, "-": n = n + 1
Menu(n, g).ident = "LRENA": MEM_put_str Menu(n, g).nam, "R#ename File          ": n = n + 1
Menu(n, g).ident = "LDELE": MEM_put_str Menu(n, g).nam, "#Delete File          ": n = n + 1
Menu(n, g).ident = "LSHOH": MEM_put_str Menu(n, g).nam, "#Show Hidden          ": n = n + 1
MEM_put_str Menu(n, g).nam, "-": n = n + 1
Menu(n, g).ident = "LMKDI": MEM_put_str Menu(n, g).nam, "#Make Directory       ": n = n + 1
Menu(n, g).ident = "LRMDI": mEM_put_str Menu(n, g).nam, "Re#name Directory     ": n = n + 1
Menu(n, g).ident = "LDLDI": MEM_put_str Menu(n, g).nam, "De#lete Directory     "
Menun(g) = n

g = g + 1: MEM_put_str Global_Menu(g).nam, "#Remote": n = 1
Menu(n, g).ident = "RREFR": MEM_put_str Menu(n, g).nam, "#Refresh Files        ": n = n + 1
MEM_put_str Menu(n, g).nam, "-": n = n + 1
Menu(n, g).ident = "RRENA": MEM_put_str Menu(n, g).nam, "R#ename File          ": n = n + 1
Menu(n, g).ident = "RDELE": MEM_put_str Menu(n, g).nam, "#Delete File          ": n = n + 1
Menu(n, g).ident = "RSHOH": MEM_put_str Menu(n, g).nam, "#Show Hidden          ": n = n + 1
MEM_put_str Menu(n, g).nam, "-": n = n + 1
Menu(n, g).ident = "RMKDI": MEM_put_str Menu(n, g).nam, "#Makes Directory      ": n = n + 1
Menu(n, g).ident = "RRMDI": MEM_put_str Menu(n, g).nam, "Re#name Directory     ": n = n + 1
Menu(n, g).ident = "RDLDI": MEM_put_str Menu(n, g).nam, "De#lete Directory     "
Menun(g) = n

g = g + 1: MEM_put_str Global_Menu(g).nam, "#Transfer": n = 1
Menu(n, g).ident = "SENDF": MEM_put_str Menu(n, g).nam, "#Send File       ": n = n + 1
Menu(n, g).ident = "RETRF": MEM_put_str Menu(n, g).nam, "#Recieve File    "
Menun(g) = n

g = g + 1: MEM_put_str Global_Menu(g).nam, "#Help": n = 1
Menu(n, g).ident = "HELP ": MEM_put_str Menu(n, g).nam, "#Help               ": n = n + 1
Menu(n, g).ident = "SETIN": MEM_put_str Menu(n, g).nam, "#Change Settings    ": n = n + 1
MEM_put_str Menu(n, g).nam, "-": n = n + 1
Menu(n, g).ident = "ABOUT": MEM_put_str Menu(n, g).nam, "#About              "
Menun(g) = n

GUI_attach_base_menu boxes(6), g, _OFFSET(Global_Menu(1))
FOR x = 1 to g
  GUI_attach_menu Global_Menu(x), Menun(x), _OFFSET(Menu(1, x))
next x

RANDOMIZE TIMER
status$ = "Not Connected."

main

GUI_free_element_array boxes()
SYSTEM


error_flag: 'rudimentary error checking. Simple but effective and only requires one error trap
err_flag = -1
RESUME NEXT

'Help data
'$include:'./help/help_data.bi'

'SETTINGS
'$include:'settings.bm'

'MEM
'$include:'mem_library/mem_lib.bm'

'FILES
'$include:'file_library/file_helpers.bm'

'GUI
'$include:'gui_library/gui_lib.bm'

'CLI
'$include:'cli/cli_display.bm'
'$include:'cli/cli_functions.bm'
'$include:'cli/cli_parse_command.bm'

'CLI-GUI WRAPPER
'$include:'cli_gui_lib/cli_gui_wrapper.bm'

'FTP
'$include:'ftp_library/ftp_lib.bm'

'DIALOGS
'$include:'dialogs/about.bm'
'$include:'dialogs/delete_file.bm'
'$include:'dialogs/dialog_simple.bm'
'$include:'dialogs/ftp_connect.bm'
'$include:'dialogs/help.bm'
'$include:'dialogs/main_dialog.bm' -- contains main as well as various other functions
'$include:'dialogs/prompt.bm'
'$include:'dialogs/recieve_file.bm'
'$include:'dialogs/rename_file.bm'
'$include:'dialogs/send_file.bm'
''$include:'dialogs/settings.bm'
