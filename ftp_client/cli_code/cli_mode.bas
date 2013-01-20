'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

SUB command_line () 'Command line implimentation
_AUTODISPLAY

IF CLI THEN
  _DEST _CONSOLE
END IF

cmd_mode = -1
exit_key$ = CHR$(27)
COLOR 7, 0
CLS
prompt$ = "FTP> "

DIM f$(5)
f$(1) = "FTP Command Line Ver:" + VER$
f$(2) = "Written in QB64 by Matt Kilgore"
f$(3) = "Type 'HELP' for a list of commands"
f$(4) = "Type 'HELP command' for help on 'command'"
FOR x = 1 TO UBOUND(f$)
  PRINT f$(x)
NEXT x
get_new_dir
DO
  cmd$ = ""
  PRINT prompt$;
  row = CSRLIN
  col = POS(0)
  update = -1
  cursor = 1
  exit_flag = 0
  IF NOT CLI THEN
    DO
      IF update THEN
        update = 0
        IF row + (LEN(cmd$) + col) \ _WIDTH(0) > _HEIGHT(0) - 1 THEN
          LOCATE _HEIGHT(0)
          DO
            PRINT
            row = row - 1
          LOOP UNTIL row + (LEN(cmd$) + col) \ _WIDTH(0) <= _HEIGHT(0) - 1
        END IF
        LOCATE row, col
        PRINT LEFT$(cmd$, _WIDTH(0) - col + 1);
        IF LEN(cmd$) + col > _WIDTH(0) THEN
          FOR x = 1 TO ((LEN(cmd$) + col) \ _WIDTH(0))
            LOCATE row + x, 1
            PRINT MID$(cmd$ + SPACE$(_WIDTH(0)), x * _WIDTH(0) - col + 2, _WIDTH(0));
          NEXT x
        END IF
        IF LEN(cmd$) + col <= _WIDTH(0) THEN PRINT " ";
        LOCATE row + (col + cursor - 2) \ (_WIDTH(0)), (col + cursor - 2) MOD _WIDTH(0) + 1, 1
      END IF
      a$ = INKEY$
      SELECT CASE a$
        CASE " " TO "~"
          IF LEN(cmd$) < 300 THEN
            cmd$ = MID$(cmd$, 1, cursor - 1) + a$ + MID$(cmd$, cursor)
            cursor = cursor + 1
            update = -1
          END IF
        CASE CHR$(8)
          IF cursor > 1 THEN
            cmd$ = MID$(cmd$, 1, cursor - 2) + MID$(cmd$, cursor)
            cursor = cursor - 1
            update = -1
          END IF
        CASE CHR$(0) + CHR$(75)
          IF cursor > 1 THEN cursor = cursor - 1: update = -1
        CASE CHR$(0) + CHR$(77)
          IF cursor <= LEN(cmd$) THEN cursor = cursor + 1: update = -1
        CASE CHR$(22)
          cmd$ = MID$(cmd$, 1, cursor - 1) + _CLIPBOARD$ + MID$(cmd$, cursor)
          cmd$ = LEFT$(cmd$, 300)
          update = update + 1
        CASE CHR$(13), exit_key$
          exit_flag = -1
          PRINT
        CASE CHR$(9) 'Tab menu
          'cmd$ = LTRIM$(RTRIM$(cmd$))
          Ucmd$ = UCASE$(LTRIM$(RTRIM$(cmd$)))
          PRINT
          IF INSTR(Ucmd$, " ") THEN
          ELSE
            PRINT "Possible Commands:"
            FOR x = 1 TO cmds
              IF LEFT$(commands$(x), LEN(Ucmd$)) = Ucmd$ THEN
                PRINT commands$(x),
              END IF
            NEXT x
            PRINT
          END IF
          PRINT prompt$;
          row = CSRLIN
          col = POS(0)
          update = -1
      END SELECT
    LOOP UNTIL exit_flag
  ELSE
    LINE INPUT ; cmd$
  END IF
  IF cmd$ > "" THEN
    cmd$ = LTRIM$(RTRIM$(cmd$))
    Ucmd$ = UCASE$(cmd$)
    'do something based on cmd$, or Ucmd$
    IF LEFT$(Ucmd$, 7) = "SCRIPT " THEN
      echo_flag = -1
      ON ERROR GOTO error_flag
      err_flag = 0
      OPEN MID$(cmd$, 8) FOR INPUT AS #1
      IF err_flag THEN
        CLOSE #1
        PRINT "Error opening script file."
      ELSE
        IF LOF(1) > 0 THEN
          DO
            LINE INPUT #1, cmd$
            'Ucmd$ = UCASE$(cmd$)
            IF UCASE$(cmd$) <> "@ECHO ON" AND UCASE$(cmd$) <> "@ECHO OFF" THEN
              IF echo_flag THEN PRINT prompt$; cmd$
              Run_Cmd cmd$
            ELSEIF UCASE$(cmd$) = "@ECHO ON" THEN
              echo_flag = -1
            ELSEIF UCASE$(cmd$) = "@ECHO OFF" THEN
              echo_flag = 0
            END IF
          LOOP UNTIL EOF(1) OR cmd_mode = 0
          CLOSE #1
        END IF
      END IF
    ELSE
      Run_Cmd cmd$
    END IF
  END IF
LOOP UNTIL a$ = exit_key$ OR cmd_mode = 0
IF NOT CLI THEN _DISPLAY
cmd_mode = 0
LOCATE , , 0
END SUB

SUB Run_Cmd (cmd$) 'Runs Command Line command cmd$
ucmd$ = UCASE$(cmd$)
IF LEFT$(ucmd$, 5) = "ECHO " THEN
  PRINT MID$(cmd$, 6)
ELSEIF LEFT$(ucmd$, 5) = "HELP " THEN
  c$ = MID$(ucmd$, 6)
  FOR x = 1 TO cmd_count
    IF commands$(x) = c$ THEN
      PRINT "HELP ON " + c$ + " COMMAND:"
      PRINT
      FOR m = 1 TO helplen(x)
        h$ = help$(x, m)
        IF NOT CLI THEN
          DO
            IF LEN(h$) > _WIDTH(0) THEN
              st = 0
              FOR s = _WIDTH(0) TO 1 STEP -1
                IF MID$(h$, s, 1) = " " THEN
                  st = s
                  EXIT FOR
                END IF
              NEXT s
              m$ = MID$(h$, 1, st)
              h$ = MID$(h$, st + 1)
            ELSE
              m$ = h$
              h$ = ""
            END IF
            PRINT m$
          LOOP UNTIL h$ = ""
        ELSE
          PRINT h$
        END IF
      NEXT m
    END IF
  NEXT x
ELSEIF LEFT$(ucmd$, 4) = "HELP" THEN
  PRINT "Commands:"
  FOR x = 1 TO cmd_count
    PRINT commands$(x),
  NEXT x
  PRINT
ELSEIF LEFT$(ucmd$, 4) = "EXIT" THEN
  cmd_mode = 0
  EXIT SUB
ELSEIF LEFT$(ucmd$, 7) = "CONNECT" THEN
  txt$ = MID$(cmd$, 9)
  IF txt$ > "" THEN
    IF INSTR(txt$, "@") THEN
      server$ = MID$(txt$, INSTR(txt$, "@") + 1)
      left_s$ = MID$(txt$, 1, INSTR(txt$, "@") - 1)
    ELSE
      server$ = txt$
      left_s$ = ""
    END IF
    IF INSTR(server$, ":") THEN
      port$ = MID$(server$, INSTR(server$, ":") + 1)
      server$ = MID$(server$, 1, INSTR(server$, ":") - 1)
    ELSE
      port$ = "21"
    END IF
    IF left_s$ > "" THEN
      IF INSTR(left_s$, ":") THEN
        username$ = MID$(left_s$, 1, INSTR(left_s$, ":") - 1)
        password$ = MID$(left_s$, INSTR(left_s$, ":") + 1)
      ELSE
        username$ = left_s$
        password$ = ""
      END IF
    ELSE
      username$ = "anonymous"
      password$ = ""
    END IF

    Start_ftp_connect
  ELSE
    PRINT "Please call this command with paramaters for the FTP server to connect to"
    PRINT
  END IF
ELSEIF LEFT$(ucmd$, 4) = "LDIR" THEN
  IF LEN(ucmd$) > 4 THEN
    flags$ = MID$(cmd$, 5)
  ELSE
    flags$ = ""
  END IF
  CLI_List_Local_Files flags$
ELSEIF LEFT$(ucmd$, 3) = "LCD" THEN
  IF LEN(ucmd$) > 3 THEN
    ON ERROR GOTO error_flag
    err_flag = 0
    CHDIR MID$(cmd$, 5)
    IF err_flag THEN
      PRINT "Couldn't change to directory."
    END IF
    get_new_dir
  ELSE
    PRINT "Please specefy a directory to change to."
  END IF
ELSEIF LEFT$(ucmd$, 3) = "DIR" THEN
  k$ = MID$(ucmd$, 4)
  IF INSTR(k$, "--NLIST") THEN
    unlist = -1
    flags$ = ""
  ELSE
    unlist = 0
    flags$ = MID$(cmd$, 4)
  END IF
  CLI_List_Remote_Files unlist, flags$
ELSEIF LEFT$(ucmd$, 2) = "CD" THEN
  di$ = MID$(cmd$, 3)
  IF di$ > "" THEN
    change_remote_dir di$
  ELSE
    PRINT "Please include a directory to change to"
  END IF
ELSEIF LEFT$(ucmd$, 3) = "PWD" THEN
  IF is_connected THEN Get_remote_dir: PRINT Remote_dir$ ELSE PRINT "Please connect to a FTP server first."
ELSEIF LEFT$(ucmd$, 4) = "LPWD" THEN
  get_new_dir
  PRINT Local_dir$
ELSEIF LEFT$(ucmd$, 6) = "STATUS" THEN
  PRINT status$
ELSEIF LEFT$(ucmd$, 5) = "PAUSE" THEN
  PRINT "Press any key to continue..."
  DO: LOOP UNTIL INKEY$ > ""
ELSEIF LEFT$(ucmd$, 6) = "SCRIPT" THEN
  echo_flag = -1
  ON ERROR GOTO error_flag
  err_flag = 0
  OPEN MID$(cmd$, 8) FOR INPUT AS #1
  IF err_flag THEN
    CLOSE #1
    PRINT "Error opening script file."
  ELSE
    IF LOF(1) > 0 THEN
      DO
        LINE INPUT #1, cmd$
        'Ucmd$ = UCASE$(cmd$)
        IF UCASE$(cmd$) <> "@ECHO ON" AND UCASE$(cmd$) <> "@ECHO OFF" THEN
          IF echo_flag THEN PRINT prompt$; cmd$
          Run_Cmd cmd$
        ELSEIF UCASE$(cmd$) = "@ECHO ON" THEN
          echo_flag = -1
        ELSEIF UCASE$(cmd$) = "@ECHO OFF" THEN
          echo_flag = 0
        END IF
      LOOP UNTIL EOF(1) OR cmd_mode = 0
      CLOSE #1
    END IF
  END IF
ELSEIF LEFT$(ucmd$, 7) = "LRENAME" THEN
  n$ = RTRIM$(LTRIM$(MID$(cmd$, 8)))
  IF n$ > "" THEN
    IF LEFT$(n$, 1) = CHR$(34) THEN 'in quotes
      f_old$ = MID$(MID$(n$, 2), 1, INSTR(MID$(n$, 2), CHR$(34)) - 1)
      n$ = MID$(MID$(n$, 2), INSTR(MID$(n$, 2), CHR$(34)) + 1)
      n$ = MID$(n$, INSTR(n$, ","))
    ELSE
      f_old$ = MID$(n$, 1, INSTR(n$, ",") - 1)
      n$ = MID$(n$, INSTR(n$, ","))
    END IF
    IF n$ > "" THEN
      n$ = MID$(n$, 2)
      IF LEFT$(n$, 1) = CHR$(34) THEN
        f_new$ = MID$(MID$(n$, 2), 1, INSTR(MID$(n$, 2), CHR$(34)) - 1)
      ELSE
        f_new$ = LTRIM$(RTRIM$(n$))
      END IF
      ON ERROR GOTO error_flag
      err_flag = 0
      NAME f_old$ AS f_new$
      IF err_flag THEN
        PRINT "Error changing name of Local file..."
      END IF
      refresh_Local_files
    ELSE
      PRINT "Please include a second file name to change to"
    END IF
  ELSE
    PRINT "Please include a file name, and a file name to change to."
  END IF
ELSEIF LEFT$(ucmd$, 6) = "RENAME" THEN
  n$ = RTRIM$(LTRIM$(MID$(cmd$, 7)))
  IF n$ > "" THEN
    IF LEFT$(n$, 1) = CHR$(34) THEN 'in quotes
      f_old$ = MID$(MID$(n$, 2), 1, INSTR(MID$(n$, 2), CHR$(34)) - 1)
      n$ = MID$(MID$(n$, 2), INSTR(MID$(n$, 2), CHR$(34)) + 1)
      n$ = MID$(n$, INSTR(n$, ","))
    ELSE
      f_old$ = MID$(n$, 1, INSTR(n$, ",") - 1)
      n$ = MID$(n$, INSTR(n$, ","))
    END IF
    IF n$ > "" THEN
      n$ = RTRIM$(LTRIM$(MID$(n$, 2)))
      IF LEFT$(n$, 1) = CHR$(34) THEN
        f_new$ = MID$(MID$(n$, 2), 1, INSTR(MID$(n$, 2), CHR$(34)) - 1)
      ELSE
        f_new$ = LTRIM$(RTRIM$(n$))
      END IF
      IF is_connected THEN
        Rename_remote_file_dir f_old$, f_new$, -1
      ELSE
        dialog_disp "Please connect to a server first."
      END IF
    ELSE
      PRINT "Please include a second file name to change to"
    END IF
  ELSE
    PRINT "Please include a file name, and a file name to change to."
  END IF

ELSEIF LEFT$(ucmd$, 3) = "GET" THEN
  fil$ = RTRIM$(LTRIM$(MID$(cmd$, 4)))
  IF LEFT$(fil$, 1) = CHR$(34) THEN
    fil$ = MID$(fil$, 2)
    fil$ = MID$(fil$, 1, INSTR(fil$, CHR$(34)) - 1)
  END IF
  IF fil$ > "" THEN
    get_file fil$
  ELSE
    PRINT "Please include a file name."
  END IF
ELSEIF LEFT$(ucmd$, 3) = "PUT" THEN
  fil$ = RTRIM$(LTRIM$(MID$(cmd$, 4)))
  IF LEFT$(fil$, 1) = CHR$(34) THEN
    fil$ = MID$(fil$, 2)
    fil$ = MID$(fil$, 1, INSTR(fil$, CHR$(34)) - 1)
  END IF
  IF fil$ > "" THEN
    send_file fil$
  ELSE
    PRINT "Please include a file name."
  END IF
ELSE
  PRINT "Command or file not found..."
END IF

END SUB

SUB CLI_List_Local_Files (flags$) 'Lists the Local files in the current dir in the command line
IF NOT CLI THEN
  f$ = temp_dir$ + sep$ + "filetemp.tmp"
  IF opper$ = "NIX" THEN
    SHELL _HIDE "ls " + flags$ + " > " + f$
  ELSEIF opper$ = "WIN" THEN
    SHELL _HIDE "cmd /c DIR " + flags$ + " > " + f$
  END IF
  OPEN f$ FOR INPUT AS #1
  c = 0
  DO WHILE NOT EOF(1)
    LINE INPUT #1, a$
    PRINT a$
    IF LEN(a$) > 0 THEN
      c = c + (LEN(a$) - 1) \ _WIDTH(0) + 1
    ELSE
      c = c + 1
    END IF
    IF c MOD (_HEIGHT(0) - 2) = 0 THEN
      PRINT "Press any key to continue...";
      DO: LOOP UNTIL INKEY$ > ""
      PRINT
    END IF
  LOOP
  CLOSE #1
ELSE
  IF opper$ = "NIX" THEN
    SHELL _HIDE "ls " + flags$ '+ " > " + f$
  ELSEIF opper$ = "WIN" THEN
    SHELL _HIDE "cmd /c DIR " '+ flags$ + " > " + f$
  END IF
END IF
END SUB

SUB CLI_List_Remote_Files (use_nlist, flags$) 'List files on remote directory
IF NOT is_connected THEN PRINT "Please connect to a server first...": EXIT SUB

start_PASV_mode
IF data_connect& = 0 THEN PRINT "Could not start PASV mode...": EXIT SUB

IF NOT use_nlist THEN upd$ = "LIST " + flags$ + crlf$
IF use_nlist THEN upd$ = "NLST" + crlf$

PUT command_connect&, , upd$
a2$ = get_response_code$
n$ = LEFT$(a2$, 3)
SELECT CASE n$
  CASE "450", "500", "501", "502", "530"
    PRINT "Error, server doesn't support " + LEFT$(upd$, LEN(upd$) - 1)
    EXIT SUB
END SELECT

t# = TIMER
DO: _LIMIT 1000
  GET data_connect&, , a$
  dirs$ = dirs$ + a$
  GET command_connect&, , b$
  b2$ = b2$ + b$
LOOP UNTIL INSTR(b2$, crlf$) OR TIMER - t# > 10 OR NOT _CONNECTED(data_connect&)

CLOSE data_connect&
IF TIMER - t# > 10 THEN
  PRINT "Error: Server timed out when sending the Directory/Files list"
  EXIT SUB
END IF
IF b2$ = "" THEN b2$ = get_response_code$
n$ = LEFT$(b2$, 3)
SELECT CASE n$
  CASE "226", "250"
    c = 0
    d$ = dirs$
    DO
      a$ = MID$(d$, 1, INSTR(d$, crlf$) - 1)
      d$ = MID$(d$, INSTR(d$, crlf$) + 2)

      PRINT a$
      IF LEN(a$) > 0 THEN
        c = c + (LEN(a$) - 1) \ _WIDTH(0) + 1
      ELSE
        c = c + 1
      END IF
      IF c MOD (_HEIGHT(0) - 2) = 0 AND CLI = 0 THEN
        PRINT "Press any key to continue...";
        DO: LOOP UNTIL INKEY$ > ""
        PRINT
      END IF
    LOOP UNTIL d$ = ""
  CASE "425", "426", "451"
    PRINT "Error, server doesn't support " + LEFT$(upd$, LEN(upd$) - 1)
    EXIT SUB

END SELECT

END SUB
