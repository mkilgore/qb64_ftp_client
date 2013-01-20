'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

SUB read_config_file () 'If a Config file exists, then it loads the settings from it
'config file a bit advanced. still not really though. Made to be editable outside of the program
ON ERROR GOTO error_flag
IF opper$ = "NIX" THEN
  OPEN "./FTP_Config.cfg" FOR INPUT AS #1
ELSE
  OPEN "FTP_config.cfg" FOR INPUT AS #1
END IF
IF err_flag THEN
  CLOSE #1
  EXIT SUB
END IF

IF LOF(1) > 0 THEN
  DO WHILE NOT EOF(1)
    LINE INPUT #1, lin$
    lin$ = RTRIM$(LTRIM$(lin$))
    IF LEFT$(lin$, 1) <> "#" THEN
      var$ = LCASE$(LTRIM$(RTRIM$(MID$(lin$, 1, INSTR(lin$, "=") - 1))))
      val$ = LTRIM$(RTRIM$(MID$(lin$, INSTR(lin$, "=") + 1)))
      IF var$ = "box_c1" THEN
        box_c1 = VAL(val$)
      ELSEIF var$ = "box_c2" THEN
        box_c2 = VAL(val$)
      ELSEIF var$ = "box_sel_c1" THEN
        box_sel_c1 = VAL(val$)
      ELSEIF var$ = "box_sel_c2" THEN
        box_sel_c2 = VAL(val$)
      ELSEIF var$ = "file_non_sel" THEN
        file_non_sel = VAL(val$)
      ELSEIF var$ = "main_gui_c1" THEN
        main_gui_c1 = VAL(val$)
      ELSEIF var$ = "main_gui_c2" THEN
        main_gui_c2 = VAL(val$)
      ELSEIF var$ = "main_gui_sel_c1" THEN
        main_gui_sel_c1 = VAL(val$)
      ELSEIF var$ = "main_gui_sel_c2" THEN
        main_gui_sel_c2 = VAL(val$)
      ELSEIF var$ = "menu_c1" THEN
        menu_c1 = VAL(val$)
      ELSEIF var$ = "menu_c2" THEN
        menu_c2 = VAL(val$)
      ELSEIF var$ = "menu_char_c" THEN
        menu_char_c = VAL(val$)
      ELSEIF var$ = "menu_sel_c1" THEN
        menu_sel_c1 = VAL(val$)
      ELSEIF var$ = "menu_sel_c2" THEN
        menu_sel_c2 = VAL(val$)
      ELSEIF var$ = "scrnh" THEN
        scrnh = VAL(val$)
      ELSEIF var$ = "scrnw" THEN
        scrnw = VAL(val$)
      ELSEIF var$ = "status_c1" THEN
        status_c1 = VAL(val$)
      ELSEIF var$ = "status_c2" THEN
        status_c2 = VAL(val$)
      ELSEIF var$ = "scrnh" THEN
        scrnh = VAL(val$)
      ELSEIF var$ = "scrnw" THEN
        scrnw = VAL(val$)
      END IF
    END IF
  LOOP
END IF
CLOSE #1
END SUB

SUB write_config_file () 'Makes a Config file
IF opper$ = "NIX" THEN
  OPEN "./FTP_Config.cfg" FOR OUTPUT AS #1
ELSE
  OPEN "FTP_Config.cfg" FOR OUTPUT AS #1
END IF
PRINT #1, "# Configuration file for QB64 FTP Client"
PRINT #1, ""
PRINT #1, "box_c1="; box_c1
PRINT #1, "box_c2="; box_c2
PRINT #1, "box_sel_c1="; box_sel_c1
PRINT #1, "box_Sel_c2="; box_sel_c2
PRINT #1, "file_non_sel="; file_non_sel
PRINT #1, "main_gui_c1="; main_gui_c1
PRINT #1, "main_gui_c2="; main_gui_c2
PRINT #1, "main_gui_sel_c1="; main_gui_sel_c1
PRINT #1, "main_gui_sel_c2="; main_gui_sel_c2
PRINT #1, "menu_char_c="; menu_char_c
PRINT #1, "menu_c1="; menu_c1
PRINT #1, "menu_c2="; menu_c2
PRINT #1, "menu_sel_c1="; menu_sel_c1
PRINT #1, "menu_Sel_c2="; menu_sel_c2
PRINT #1, "status_c1="; status_c1
PRINT #1, "status_c2="; status_c2
PRINT #1, "scrnh="; scrnh
PRINT #1, "scrnw="; scrnw
CLOSE #1

END SUB
