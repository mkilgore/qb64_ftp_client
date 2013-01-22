'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

'Basically -- You just do what you want. It's fairly simple.
'I wouldn't mind a mention if you use this code, but it's by no means required.

'DECLARE LIBRARY "SDLNet_Temp_Header"
'    FUNCTION bytes_left& (a AS LONG)
'END DECLARE

'DECLARE LIBRARY
'  FUNCTION fopen%& (file_name as string, mode as string) 'Mode "w" will create an empty file for writing
'END DECLARE

'Thanks to DAV and the Wiki for this code
'DECLARE LIBRARY
'  FUNCTION GetLogicalDriveStringsA(BYVAL nBuff AS LONG, lpbuff AS STRING)
'END DECLARE

$SCREENHIDE
$CONSOLE

CONST VER$ = "0.96"

'$include:'mem_library/mem_lib.bi'
'$include:'gui_library/gui_lib.bi'
'$include:'ftp_library/ftp_lib.bi'
'$include:'dialogs/prompt.bi'

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

CONST BOXES = 3 'Don't change  -- number of GUI elements in main dialog
CONST g_menu_c = 5 'Number of global menu choices

DIM SHARED boxes(BOXES) AS box_type, selected_box
DIM SHARED Remote_files(500) AS filedir_type, Local_files(1000) AS filedir_type 'Change this number for more files
DIM SHARED global_menu_sel, menu_sel, menu_max_len(g_menu_c), temp_menu_sel, menux AS box_type

'$include:'dialogs/settings.bi'

scrnw = 80 'Default screen size. -- Is overwritten if a Config file is found
scrnh = 25 'Smaller then 80x25 is not recommended or garentied to work

crlf$ = CHR$(13) + CHR$(10) 'end character
status$ = "Not Connected." 'default status message

a$ = "QWERTYUIOP????ASDFGHJKL?????ZXCVBNM" 'Credit to Galleon for the ALT key code stuff.
DIM SHARED alt_codes$(LEN(a$) + 16)
FOR x = 1 TO LEN(a$)
  alt_codes$(x + 15) = MID$(a$, x, 1)
NEXT x

_TITLE "FTP Client -- QB64"

CONFIG = -1 'If 0, it won't check for a config file
CLI = 0 'Start Command Line only if -1.

IF INSTR(_OS$, "[LINUX]") OR INSTR(_OS$, "[MACOSX]") THEN
  opper$ = "NIX"
  'Local_dir$ = "/" 'Root
  sep$ = "/"
  temp_dir$ = "/tmp"
ELSE
  opper$ = "WIN"
  'Local_dir$ = "C:\" 'C Drive
  sep$ = "\"
  temp_dir$ = ENVIRON$("temp")
END IF

'$include:'help/setup_help.bm'

'check COMMAND$
IF COMMAND$ > "" THEN
  cmdarg$ = LCASE$(COMMAND$)
  IF INSTR(cmdarg$, "-cli") THEN
    CLI = -1
  END IF
  IF INSTR(cmdarg$, "-gui") THEN
    CLI = 0
  END IF
  IF INSTR(cmdarg$, "-config") THEN
    CONFIG = -1
  END IF
  IF INSTR(cmdarg$, "-noconfig") THEN
    CONFIG = 0
  END IF
  IF INSTR(cmdargs$, "-h") OR INSTR(cmdargs$, "--help") THEN

  END IF
END IF

IF CLI THEN
  command_line
  SYSTEM
ELSE
  _CONSOLE OFF
  _SCREENSHOW
END IF

'Load config file
IF CONFIG THEN
  read_config_file
END IF

LOCATE , , 0
butflag = 0

setup_main_GUI

dim s as string_type

allocate_array boxes(1).multi_line, 120, LEN(s)
allocate_array boxes(2).multi_line, 120, LEN(s)

DIM SHARED Global_Menu$(g_menu_c), Menu$(g_menu_c, 9), Menun(g_menu_c)
g = 1
Global_Menu$(g) = " #File ": n = 1
Menu$(g, n) = " #Connect              ": n = n + 1
Menu$(g, n) = " #Disconnect           ": n = n + 1
Menu$(g, n) = " C#ommand Line         ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " E#xit                 "
Menun(g) = n

g = g + 1: Global_Menu$(g) = " #Local ": n = 1
Menu$(g, n) = " #Refresh Files         ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " R#ename File           ": n = n + 1
Menu$(g, n) = " #Delete File           ": n = n + 1
Menu$(g, n) = " #Show Hidden           ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " #Make Directory        ": n = n + 1
Menu$(g, n) = " Re#name Directory      ": n = n + 1
Menu$(g, n) = " De#lete Directory      "
Menun(g) = n

g = g + 1: Global_Menu$(g) = " #Remote ": n = 1
Menu$(g, n) = " #Refresh Files         ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " R#ename File           ": n = n + 1
Menu$(g, n) = " #Delete File           ": n = n + 1
Menu$(g, n) = " #Show Hidden           ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " #Makes Directory       ": n = n + 1
Menu$(g, n) = " Re#name Directory      ": n = n + 1
Menu$(g, n) = " De#lete Directory      "
Menun(g) = n

g = g + 1: Global_Menu$(g) = " #Transfer ": n = 1
Menu$(g, n) = " #Send File        ": n = n + 1
Menu$(g, n) = " #Recieve File     "
Menun(g) = n

g = g + 1: Global_Menu$(g) = " #Help ": n = 1
Menu$(g, n) = " #Help                ": n = n + 1
Menu$(g, n) = " #Change Settings     ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " #About               "
Menun(g) = n

FOR x = 1 TO g_menu_c
  FOR y = 1 TO Menun(x)
    IF LEN(Menu$(x, y)) > menu_max_len(x) THEN
      menu_max_len(x) = LEN(Menu$(x, y))
    END IF
  NEXT y
NEXT x

RANDOMIZE TIMER
status$ = "Not Connected."

main

free_gui_array boxes()
END

error_flag: 'rudimentary error checking. Simple but effective and only requires one error trap
err_flag = -1
RESUME NEXT

'Help data
'$include:'./help/help_data.bi'


'INCLUDING LIBRARY CODE AND OTHERS

'SETTINGS
'$include:'settings.bm'

'MEM
'$include:'mem_library/mem_lib.bm'

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
'$include:'dialogs/settings.bm'
