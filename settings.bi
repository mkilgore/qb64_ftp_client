'FTP Client
'Copyright Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.
COMMON SHARED main_gui_c1 AS INTEGER, main_gui_c2 AS INTEGER
COMMON SHARED main_gui_sel_c1 AS INTEGER, main_gui_sel_c2 AS INTEGER
COMMON SHARED status_c1 AS INTEGER, status_c2 AS INTEGER
COMMON SHARED menu_c1 AS INTEGER, menu_c2 AS INTEGER
COMMON SHARED menu_sel_c1 AS INTEGER, menu_sel_c2 AS INTEGER
COMMON SHARED menu_char_c AS INTEGER, file_non_sel AS INTEGER
COMMON SHARED box_c1 AS INTEGER, box_c2 AS INTEGER
COMMON SHARED box_sel_c1 AS INTEGER, box_sel_c2 AS INTEGER

'colors
main_gui_c1 = 15
main_gui_c2 = 1
main_gui_sel_c1 = 0
main_gui_sel_c2 = 7
file_non_sel = 10
status_c1 = 0
status_c2 = 3
menu_c1 = 0
menu_c2 = 7
menu_sel_c1 = 7
menu_sel_c2 = 0
menu_char_c = 15
box_c1 = 0
box_c2 = 7
box_sel_c1 = 7
box_sel_c2 = 0

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
  sep$ = "/"
  temp_dir$ = "/tmp"
ELSE
  opper$ = "WIN"
  sep$ = "\"
  temp_dir$ = ENVIRON$("temp")
END IF

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
