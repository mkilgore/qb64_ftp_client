'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

SUB Connect_To_FTP () 'GUI for connecting to FTP and opens the connection with FTP server
selected_gui = 1
DIM main_ide AS box_type
'main_ide.nam = "Connect to FTP Server"
put_str main_ide.nam, "Connect to FTP Server"
main_ide.c1 = box_c1
main_ide.c2 = box_c2
main_ide.text_box = -1
main_ide.shadow = -1
rows = 12
cols = 46
main_ide.row1 = _HEIGHT(0) \ 2 - rows \ 2
main_ide.row2 = main_ide.row1 + rows
main_ide.col1 = _WIDTH(0) \ 2 - cols \ 2
main_ide.col2 = main_ide.col1 + cols

DIM gui(5) AS box_type
'DIM gui_text$(3)
r = main_ide.row1 + 1
c = main_ide.col1 + 4

gui(1).row1 = main_ide.row1 + 1
gui(1).col1 = main_ide.col1 + 3
gui(1).row2 = gui(1).row1 + 2
gui(1).col2 = gui(1).col1 + 40
gui(1).text_box = -1
gui(1).c1 = box_c1
gui(1).c2 = box_c2
gui(1).sc1 = box_c1
gui(1).sc2 = box_c2
'gui(1).nam = "Server"
put_str gui(1).nam, "Server"

gui(2).row1 = gui(1).row2 + 1
gui(2).col1 = gui(1).col1
gui(2).row2 = gui(2).row1 + 2
gui(2).col2 = gui(2).col1 + 40
gui(2).text_box = -1
gui(2).c1 = box_c1
gui(2).c2 = box_c2
gui(2).sc1 = box_c1
gui(2).sc2 = box_c2
'gui(2).nam = "Username"
put_str gui(2).nam, "Username"

gui(3).row1 = gui(2).row2 + 1
gui(3).col1 = gui(2).col1
gui(3).row2 = gui(3).row1 + 2
gui(3).col2 = gui(3).col1 + 40
gui(3).text_box = -1
gui(3).c1 = box_c1
gui(3).c2 = box_c2
gui(3).sc1 = box_c1
gui(3).sc2 = box_c2
'gui(3).nam = "Password"
put_str gui(3).nam, "Password"
gui(3).hide = -1

gui(4).row1 = gui(3).row1 + 3
'gui(4).nam = "Connect"
put_str gui(4).nam, "Connect"
gui(4).col1 = main_ide.col1 + cols \ 3 - LEN(get_str$(gui(4).nam)) \ 2
gui(4).button = -1
gui(4).c1 = box_c1
gui(4).c2 = box_c2
gui(4).sc1 = box_sel_c1
gui(4).sc2 = box_sel_c2

gui(5).row1 = gui(4).row1
'gui(5).nam = "Quit"
put_str gui(5).nam, "Quit"
gui(5).col1 = gui(4).col1 + cols \ 3 - LEN(get_str$(gui(5).nam)) \ 2
gui(5).button = -1
gui(5).c1 = box_c1
gui(5).c2 = box_c2
gui(5).sc1 = box_sel_c1
gui(5).sc2 = box_sel_c2
LOCATE , , 1
locrow = 1
loccol = 1

update = -1
exit_gui_flag = 0
DO
  _LIMIT 500
  m = mouse_range(gui(), 5)
  IF m <> selected_gui AND m > 0 THEN selected_gui = m: update = -1
  IF gui(selected_gui).updated THEN gui(selected_gui).updated = 0: update = -1
  IF but THEN
    IF selected_gui = 4 THEN
      server$ = get_str$(gui(1).text) 'gui_text$(1)
      IF INSTR(server$, ":") THEN
        port$ = MID$(server$, INSTR(server$, ":") + 1)
        server$ = MID$(server$, 1, INSTR(server$, ":") - 1)
      ELSE
        port$ = "21"
      END IF
      username$ = get_str$(gui(2).text) ' gui_text$(2)
      password$ = get_str$(gui(3).text) 'gui_text$(3)

      Start_ftp_connect
      IF is_connected THEN LOCATE , , 0: _DISPLAY: exit_gui_flag = -1
      update = -1
    ELSEIF selected_gui = 5 THEN
      LOCATE , , 0
      _DISPLAY
      exit_gui_flag = -1
    END IF
  END IF
  a$ = INKEY$
  IF a$ > "" THEN
    test = update_input_boxes(gui(), selected_gui, a$)
    IF test THEN
      update = -1
    ELSE
      SELECT CASE a$
        CASE CHR$(9)
          selected_gui = selected_gui + 1
          IF selected_gui > 5 THEN selected_gui = 1
          update = -1
        CASE CHR$(13)
          IF selected_gui <= 3 THEN
            selected_gui = selected_gui + 1
            update = -1
          ELSEIF selected_gui > 3 THEN
            IF selected_gui = 4 THEN
              'GOSUB connect
              server$ = get_str$(gui(1).text) 'gui_text$(1)
              IF INSTR(server$, ":") THEN
                port$ = MID$(server$, INSTR(server$, ":") + 1)
                server$ = MID$(server$, 1, INSTR(server$, ":") - 1)
              ELSE
                port$ = "21"
              END IF
              username$ = get_str$(gui(2).text) 'gui_text$(2)
              password$ = get_str$(gui(3).text) 'gui_text$(3)

              Start_ftp_connect
              IF is_connected THEN LOCATE , , 0: _DISPLAY: exit_gui_flag = -1
              update = -1
            ELSE
              LOCATE , , 0
              _DISPLAY
              exit_gui_flag = -1

            END IF
          END IF
      END SELECT
    END IF
  END IF
  IF update THEN
    _DISPLAY
    update = 0
    update_scrn
    draw_box main_ide, 0
    FOR x = 1 TO 5
      draw_box gui(x), selected_gui = x
      IF x < 4 AND selected_gui = x THEN
        locrow = gui(x).row1 + 1
        loccol = gui(x).col1 + gui(x).text_position - gui(x).text_offset + 1
      ELSEIF selected_gui = x THEN
        locrow = gui(x).row1
        loccol = gui(x).col1 + 1
      END IF
    NEXT x

    LOCATE locrow, loccol
    _AUTODISPLAY
  END IF
LOOP until exit_gui_flag

free_gui_element main_ide
free_gui_array gui()
END SUB

SUB rename_file_GUI (local_or_remote) 'Renames a local or remote file
'local_or_remote = 0 -- local file rename
'local_or_remote = 1 -- remote file rename

IF local_or_remote = 0 AND is_connected = 0 THEN
  dialog_disp "Please connect to a server first."
  EXIT SUB
END IF

gui_num = 3 '1 text box, 3 buttons
DIM box AS box_type, gui(gui_num) AS box_type
'box.nam = "Rename file"
put_str box.nam, "Rename file"
box.row1 = _HEIGHT(0) \ 2 - 3
box.row2 = box.row1 + 6
box.col1 = _WIDTH(0) \ 2 - 30
box.col2 = box.col1 + 60
box.shadow = -1
box.c1 = box_c1
box.c2 = box_c2
box.text_box = -1

'gui(1).nam = "File Name"
put_str gui(1).nam, "File Name"
gui(1).row1 = box.row1 + 1
gui(1).row2 = gui(1).row1 + 2
gui(1).col1 = box.col1 + 5
gui(1).col2 = box.col2 - 5
gui(1).c1 = box_c1
gui(1).c2 = box_c2
gui(1).text_box = -1

IF local_or_remote = 1 THEN
  'gui(2).nam = "Local File"
  put_str gui(2).nam, "Local File"
  gui(2).row1 = box.row2 - 1
  gui(2).c1 = box_c1
  gui(2).c2 = box_c2
  gui(2).sc1 = box_sel_c1
  gui(2).sc2 = box_sel_c2
  gui(2).button = -1
ELSE
  'IF is_connected THEN
  'gui(2).nam = "Remote File"
  put_str gui(2).nam, "Remove File"
  gui(2).row1 = box.row2 - 1
  gui(2).c1 = box_c1
  gui(2).c2 = box_c2
  gui(2).sc1 = box_sel_c1
  gui(2).sc2 = box_sel_c2
  gui(2).button = -1
END IF

'gui(3).nam = "Close"
put_str gui(3).nam, "Close"
gui(3).row1 = box.row2 - 1
gui(3).c1 = box_c1
gui(3).c2 = box_c2
gui(3).sc1 = box_sel_c1
gui(3).sc2 = box_sel_c2
gui(3).button = -1

blen = box.col2 - box.col1
b = blen \ 3
gui(2).col1 = b - LEN(get_str$(gui(2).nam)) \ 2 + box.col1
gui(3).col1 = b * 2 - LEN(get_str$(gui(3).nam)) \ 2 + box.col1
'END IF

update = -1
selected_box = 1
LOCATE , , 1
locrow = 1
loccol = 1
IF local_or_remote = 1 THEN put_str gui(1).text, RTRIM$(get_str$(Local_files(boxes(1).selected).nam)) ELSE put_str gui(1).text, RTRIM$(get_str$(Remote_files(boxes(2).selected).nam))
DO
  _LIMIT 500
  m = mouse_range(gui(), gui_num)
  IF m <> selected_box AND m > 0 THEN selected_box = m: update = -1
  IF gui(selected_box).updated THEN gui(selected_box).updated = 0: update = -1
  IF update THEN
    _DISPLAY
    update = 0
    draw_box box, 0
    FOR x = 1 TO gui_num
      draw_box gui(x), selected_box = x
      'IF x = 1 THEN
      '  LOCATE gui(x).row1 + 1, gui(x).col1 + 1
      '  PRINT RIGHT$(filename$, (gui(x).col2 - gui(x).col1) - 2);
      'END IF
      IF x = selected_box THEN
        IF selected_box = 1 THEN
          locrow = gui(x).row1 + 1
          loccol = gui(x).col1 + gui(x).text_position - gui(x).text_offset + 1

          'locrow = gui(x).row1 + 1
          'loccol = gui(x).col1 + LEN(RIGHT$(filename$, (gui(x).col2 - gui(x).col1) - 2)) + 1
        ELSE
          locrow = gui(x).row1
          loccol = gui(x).col1 + 1
        END IF
      END IF
    NEXT x
    LOCATE locrow, loccol
    _AUTODISPLAY
  END IF
  k$ = INKEY$
  update = update_input_boxes(gui(), selected_box, k$)
  SELECT CASE k$
    CASE CHR$(9) 'tab
      selected_box = (selected_box MOD gui_num) + 1: update = -1
    CASE CHR$(13)
      IF selected_box = 1 THEN
      ELSEIF selected_box = 2 THEN
        IF local_or_remote = 1 THEN
          'rename local file
          GOSUB rename_local_file
        ELSE
          Rename_remote_file_dir RTRIM$(get_str$(Remote_files(boxes(2).selected).nam)), get_str$(gui(1).text), -1
        END IF
        exit_flag = -1
      ELSEIF selected_box = 3 THEN
        exit_flag = -1
      END IF
    CASE CHR$(27)
      exit_flag = -1
  END SELECT
  IF but THEN
    IF selected_box = 2 THEN
      IF local_or_remote = 1 THEN
        GOSUB rename_local_file
      ELSE
        Rename_remote_file_dir RTRIM$(get_str$(Remote_files(boxes(2).selected).nam)), get_str$(gui(1).text), -1
      END IF
      exit_flag = -1
    ELSEIF selected_box = 3 THEN
      exit_flag = -1
    END IF
  END IF
LOOP UNTIL exit_flag
_DISPLAY
LOCATE , , 0
EXIT SUB

rename_local_file:
ON ERROR GOTO error_flag
err_flag = 0
NAME RTRIM$(get_str$(Local_files(boxes(1).selected).nam)) AS get_str$(gui(1).text)
IF err_flag THEN
  dialog_disp "Error changing name of Local file..."
END IF
refresh_Local_files
exit_flag = -1
RETURN
END SUB

SUB settings_dialog () 'Displays a dialog to change settings
gui_num = 9
DIM main_box AS box_type, gui(gui_num) AS box_type
DIM drop_down AS box_type, ddsel(3), ddarr$(3, 20), ddlen(3)
DIM drop_flag AS INTEGER, selsav(8, 2) AS INTEGER, backup(8, 2) AS INTEGER, rowback AS INTEGER, colback AS INTEGER
'DIM text$(2)
rowback = scrnh
colback = scrnw

ddarr$(1, 1) = "GUI Colors"
ddarr$(1, 2) = "GUI Selection Colors"
ddarr$(1, 3) = "Status Strip Colors"
ddarr$(1, 4) = "Menu Colors"
ddarr$(1, 5) = "Menu Selection Colors"
ddarr$(1, 6) = "Dialog Colors"
ddarr$(1, 7) = "Dialog Selection Colors"
ddarr$(1, 8) = "Etc. Colors"
selsav(1, 1) = main_gui_c1 + 1
selsav(1, 2) = main_gui_c2 + 1
selsav(2, 1) = main_gui_sel_c1 + 1
selsav(2, 2) = main_gui_sel_c2 + 1
selsav(3, 1) = status_c1 + 1
selsav(3, 2) = status_c2 + 1
selsav(4, 1) = menu_c1 + 1
selsav(4, 2) = menu_c2 + 1
selsav(5, 1) = menu_sel_c1 + 1
selsav(5, 2) = menu_sel_c2 + 1
selsav(6, 1) = box_c1 + 1
selsav(6, 2) = box_c2 + 1
selsav(7, 1) = box_sel_c1 + 1
selsav(7, 2) = box_sel_c2 + 1
selsav(8, 1) = menu_char_c + 1
selsav(8, 2) = file_non_sel + 1
FOR x = 1 TO 8
  FOR y = 1 TO 2
    backup(x, y) = selsav(x, y)
  NEXT y
NEXT x
ddarr$(2, 1) = "Black"
ddarr$(2, 2) = "Dark Blue"
ddarr$(2, 3) = "Dark Green"
ddarr$(2, 4) = "Dark Cyan"
ddarr$(2, 5) = "Dark Red"
ddarr$(2, 6) = "Dark Magenta"
ddarr$(2, 7) = "Dark Yellow"
ddarr$(2, 8) = "Light Gray"
ddarr$(2, 9) = "Dark Grey"
ddarr$(2, 10) = "Blue"
ddarr$(2, 11) = "Green"
ddarr$(2, 12) = "Cyan"
ddarr$(2, 13) = "Red"
ddarr$(2, 14) = "Magenta"
ddarr$(2, 15) = "Yellow"
ddarr$(2, 16) = "White"
ddarr$(3, 1) = "Black"
ddarr$(3, 2) = "Dark Blue"
ddarr$(3, 3) = "Dark Green"
ddarr$(3, 4) = "Dark Cyan"
ddarr$(3, 5) = "Dark Red"
ddarr$(3, 6) = "Dark Magenta"
ddarr$(3, 7) = "Dark Yellow"
ddarr$(3, 8) = "Light Gray"
ddarr$(3, 9) = "Dark Grey"
ddarr$(3, 10) = "Blue"
ddarr$(3, 11) = "Green"
ddarr$(3, 12) = "Cyan"
ddarr$(3, 13) = "Red"
ddarr$(3, 14) = "Magenta"
ddarr$(3, 15) = "Yellow"
ddarr$(3, 16) = "White"
ddlen(1) = 8
ddsel(1) = 1
ddlen(2) = 16
ddsel(2) = selsav(1, 1)
ddlen(3) = 8
ddsel(3) = selsav(1, 2)

GOSUB setup_box 'sets up gui cords and colors. it's a gosub because it is used again in the main loop


main_box.text_box = -1
'main_box.nam = "Settings"
put_str main_box.nam, "Settings"
main_box.shadow = -1

gui(1).text_box = -1
'gui(1).nam = ""
put_str gui(1).nam, ""
gui(1).shadow = -1

gui(2).drop_down = -1

gui(3).drop_down = -1

gui(4).drop_down = -1

gui(5).text_box = -1
'gui(5).nam = "Rows"
put_str gui(5).nam, "Rows"
put_str gui(5).text, LTRIM$(RTRIM$(STR$(scrnh)))

gui(6).text_box = -1
'gui(6).nam = "Columns"
put_str gui(6).nam, "Columns"
put_str gui(6).text, LTRIM$(RTRIM$(STR$(scrnw)))

gui(7).button = -1
'gui(7).nam = "Change"
put_str gui(7).nam, "Change"

gui(8).button = -1
'gui(8).nam = "Save"
put_str gui(8).nam, "Save"

gui(9).button = -1
'gui(9).nam = "Exit"
put_str gui(9).nam, "Exit"

update = -1
curr = 1
curc = 1
exit_flag = 0
loaded = 1
DO
  _LIMIT 1000
  m = mouse_range(gui(), gui_num)
  IF gui(s_box).updated THEN gui(s_box).updated = 0: update = -1
  IF m > 0 THEN
    IF (s_box = m AND m < 5 AND m > 1) THEN ' OR (m < 5 AND m > 1 AND my = gui(m).col2 - 1) THEN
      IF drop_flag = 0 THEN
        drop_flag = -1
        gui(1).row1 = gui(m).row1
        gui(1).row2 = gui(1).row1 + ddlen(m - 1) + 1
        IF gui(1).row2 > _HEIGHT(0) THEN gui(1).row2 = _HEIGHT(0)
        gui(1).col1 = gui(m).col1
        gui(1).col2 = gui(m).col2
        gui(1).selected = ddsel(m - 1)
        gui(s_box).d_flag = 0
        gui(m).d_flag = -1
      ELSE
        drop_flag = 0
        gui(m).d_flag = 0
        gui(1).row1 = 0
        gui(1).row2 = 0
        gui(1).col1 = 0
        gui(1).col2 = 0
        gui(1).c1 = 0

      END IF
    ELSEIF m = 1 THEN
      m = s_box
      IF my > gui(1).row1 THEN
        IF ddsel(m - 1) = my - gui(1).row1 THEN

          drop_flag = 0
          gui(s_box).d_flag = 0
          gui(1).row1 = 0
          gui(1).row2 = 0
          gui(1).col1 = 0
          gui(1).col2 = 0
        ELSE
          ddsel(m - 1) = my - gui(1).row1
          selsav(loaded, 1) = ddsel(2)
          selsav(loaded, 2) = ddsel(3)

        END IF
      END IF
    ELSE
      gui(s_box).d_flag = 0
      drop_flag = 0
      gui(1).row1 = 0
      gui(1).row2 = 0
      gui(1).col1 = 0
      gui(1).col2 = 0

    END IF
    s_box = m
    update = -1
  END IF
  IF but THEN 'mouse click
    IF drop_flag AND m <> s_box THEN
      drop_flag = 0
      gui(s_box).d_flag = 0
      update = -1
      gui(1).row1 = 0
      gui(1).row2 = 0
      gui(1).col1 = 0
      gui(1).col2 = 0


    END IF
  END IF
  IF ddsel(1) = 8 THEN ddlen(3) = 16 ELSE ddlen(3) = 8
  IF s_box = 2 THEN
    IF ddsel(s_box - 1) <> loaded THEN
      ddsel(2) = selsav(ddsel(s_box - 1), 1)
      ddsel(3) = selsav(ddsel(s_box - 1), 2)
      loaded = ddsel(s_box - 1)
      update = -1
    END IF
    selsav(loaded, 1) = ddsel(2)
    selsav(loaded, 2) = ddsel(3)
  END IF
  IF update THEN
    update = 0
    _DISPLAY
    update_scrn
    draw_box main_box, 0
    FOR x = 2 TO gui_num
      IF x < 5 THEN
        put_str gui(x).nam, LEFT$(ddarr$(x - 1, ddsel(x - 1)), gui(x).col2 - gui(x).col1)
      END IF
      draw_box gui(x), s_box = x
      'IF x = 5 OR x = 6 THEN COLOR gui(x).c1, gui(x).c2: LOCATE gui(x).row1 + 1, gui(x).col1 + 1: PRINT text$(x - 4);
      IF s_box = x THEN
        IF x < 5 OR x > 6 THEN 'dropdown or button
          curr = gui(x).row1
          curc = gui(x).col1 + 1
        ELSEIF x = 5 OR x = 6 THEN 'text boxes
          curr = gui(x).row1 + 1
          curc = gui(x).col1 + gui(x).text_position - gui(x).text_offset + 1
          'curr = gui(x).row1 + 1
          'curc = gui(x).col1 + LEN(text$(x - 4)) + 1
        END IF
      END IF
    NEXT x
    IF CONFIG = 0 THEN
      COLOR box_c1, box_c2
      s$ = "Note: right now CONFIG = 0. If this is default, run Client with -config 1"
      's$ = "Loaded=:" + STR$(loaded)
      LOCATE main_box.row2 - 1, main_box.col1 + 1
      PRINT s$;
    END IF
    IF ddsel(1) < 8 THEN
      COLOR selsav(ddsel(1), 1) - 1, selsav(ddsel(1), 2) - 1
      t$ = "Example Text in Selected Colors"
      LOCATE main_box.row1 + 6, main_box.col1 + (main_box.col2 - main_box.col1) \ 2 - LEN(t$) / 2
      PRINT t$;
    ELSE
      COLOR selsav(4, 1) - 1, selsav(4, 2) - 1
      LOCATE main_box.row1 + 6, main_box.col1 + 4
      PRINT " M";
      COLOR selsav(8, 1) - 1
      PRINT "e";
      COLOR selsav(4, 1) - 1
      PRINT "nu ALT character color ";

      COLOR selsav(8, 2) - 1, selsav(1, 2) - 1
      LOCATE main_box.row1 + 6, main_box.col1 + 30
      PRINT "   Selected GUI item.  ";
    END IF
    IF drop_flag THEN
      draw_box gui(1), 0
      draw_box gui(s_box), 1
      FOR x = 1 TO ddlen(s_box - 1)
        IF x <> ddsel(s_box - 1) THEN COLOR gui(1).c1, gui(1).c2 ELSE COLOR gui(1).sc1, gui(1).sc2: curr = gui(1).row1 + x: curc = gui(1).col1 + 1
        LOCATE gui(1).row1 + x, gui(1).col1 + 1
        PRINT LEFT$(ddarr$(s_box - 1, x) + SPACE$(gui(1).col2 - gui(1).col1 - 1), gui(1).col2 - gui(1).col1 - 1);
      NEXT x
    END IF
    IF in_test THEN
      k = prompt_dialog("Keep these settings?", 10, YES_BUTTON OR NO_BUTTON, NO_BUTTON)
      IF k = NO_BUTTON THEN
        scrnw = colback
        scrnh = rowback
        main_gui_c1 = backup(1, 1) - 1
        main_gui_c2 = backup(1, 2) - 1
        main_gui_sel_c1 = backup(2, 1) - 1
        main_gui_sel_c2 = backup(2, 2) - 1
        status_c1 = backup(3, 1) - 1
        status_c2 = backup(3, 2) - 1
        menu_c1 = backup(4, 1) - 1
        menu_c2 = backup(4, 2) - 1
        menu_sel_c1 = backup(5, 1) - 1
        menu_sel_c2 = backup(5, 2) - 1
        box_c1 = backup(6, 1) - 1
        box_c2 = backup(6, 2) - 1
        box_sel_c1 = backup(7, 1) - 1
        box_sel_c2 = backup(7, 2) - 1
        menu_char_c = backup(8, 1) - 1
        file_non_sel = backup(8, 2) - 1

        FOR x = 1 TO 8
          FOR y = 1 TO 2
            selsav(x, y) = backup(x, y)
          NEXT y
        NEXT x
        put_str gui(5).text, LTRIM$(STR$(scrnh))
        put_str gui(6).text, LTRIM$(STR$(scrnw))
        setup_main_GUI
        GOSUB setup_box
        update_scrn
      ELSE
        colback = scrnw
        rowback = scrnh
        FOR x = 1 TO 8
          FOR y = 1 TO 2
            backup(x, y) = selsav(x, y)
          NEXT y
        NEXT x
      END IF
      in_test = 0
      update = -1
    END IF
    _AUTODISPLAY
    LOCATE curr, curc, 1
  END IF
  k$ = INKEY$
  tes = update_input_boxes(gui(), s_box, k$)
  IF tes THEN update = -1
  SELECT CASE k$
    CASE CHR$(0) + CHR$(72) 'up
      IF drop_flag THEN
        IF ddsel(s_box - 1) > 1 THEN
          ddsel(s_box - 1) = ddsel(s_box - 1) - 1
          selsav(loaded, 1) = ddsel(2)
          selsav(loaded, 2) = ddsel(3)

          update = -1
        END IF
      END IF
    CASE CHR$(0) + CHR$(80) 'down
      IF drop_flag THEN
        IF ddsel(s_box - 1) < ddlen(s_box - 1) THEN
          ddsel(s_box - 1) = ddsel(s_box - 1) + 1
          selsav(loaded, 1) = ddsel(2)
          selsav(loaded, 2) = ddsel(3)

          update = -1
        END IF
      ELSEIF s_box > 1 AND s_box < 5 THEN
        drop_flag = -1
        gui(1).row1 = gui(s_box).row1
        gui(1).row2 = gui(1).row1 + ddlen(s_box - 1) + 1
        IF gui(1).row2 > _HEIGHT(0) THEN gui(1).row2 = _HEIGHT(0)
        gui(1).col1 = gui(s_box).col1
        gui(1).col2 = gui(s_box).col2
        gui(1).selected = ddsel(s_box - 1)
        gui(s_box).d_flag = -1
        update = -1
      END IF
    CASE CHR$(13)
      IF drop_flag THEN
        gui(s_box).d_flag = 0
        drop_flag = 0
        gui(1).row1 = 0
        gui(1).row2 = 0
        gui(1).col1 = 0
        gui(1).col2 = 0
        update = -1
      ELSEIF s_box > 5 THEN
        but = -1
        m = s_box
      END IF
    CASE CHR$(9)
      IF drop_flag THEN
        gui(s_box).d_flag = 0
        drop_flag = 0
        gui(1).row1 = 0
        gui(1).row2 = 0
        gui(1).col1 = 0
        gui(1).col2 = 0
      END IF
      s_box = (s_box MOD gui_num) + 1
      IF s_box = 1 THEN s_box = 2
      update = -1
    CASE CHR$(27)
      exit_flag = -1
  END SELECT
  IF but THEN
    IF m = 1 THEN

    ELSEIF m = 7 THEN
      scrnh = VAL(get_str$(gui(5).text))
      scrnw = VAL(get_str$(gui(6).text))
      main_gui_c1 = selsav(1, 1) - 1
      main_gui_c2 = selsav(1, 2) - 1
      main_gui_sel_c1 = selsav(2, 1) - 1
      main_gui_sel_c2 = selsav(2, 2) - 1
      status_c1 = selsav(3, 1) - 1
      status_c2 = selsav(3, 2) - 1
      menu_c1 = selsav(4, 1) - 1
      menu_c2 = selsav(4, 2) - 1
      menu_sel_c1 = selsav(5, 1) - 1
      menu_sel_c2 = selsav(5, 2) - 1
      box_c1 = selsav(6, 1) - 1
      box_c2 = selsav(6, 2) - 1
      box_sel_c1 = selsav(7, 1) - 1
      box_sel_c2 = selsav(7, 2) - 1
      menu_char_c = selsav(8, 1) - 1
      file_non_sel = selsav(8, 2) - 1

      setup_main_GUI
      GOSUB setup_box
      update_scrn
      update = -1
      in_test = -1
    ELSEIF m = 8 THEN
      k = prompt_dialog("Save current settings to FTP_Config.cfg in current directory?" + CHR$(13) + "Note: Make sure to apply your settings by clicking" + CHR$(13) + "the 'change' button before saving.", 0, YES_BUTTON OR NO_BUTTON, NO_BUTTON)
      IF k = YES_BUTTON THEN
        write_config_file
      END IF
    ELSEIF m = 9 THEN
      exit_flag = -1
    END IF
  END IF
LOOP UNTIL exit_flag
LOCATE , , 0
free_gui_element main_box
free_gui_array gui()
EXIT SUB

setup_box:
main_box.row1 = _HEIGHT(0) \ 2 - 8
main_box.row2 = _HEIGHT(0) \ 2 + 8
main_box.col1 = _WIDTH(0) \ 2 - 30
main_box.col2 = _WIDTH(0) \ 2 + 30
gui(2).row1 = main_box.row1 + 1
gui(2).col1 = main_box.col1 + 10
gui(2).col2 = gui(2).col1 + 40
gui(3).row1 = main_box.row1 + 3
gui(3).col1 = main_box.col1 + 5
gui(3).col2 = gui(3).col1 + 20
gui(4).row1 = main_box.row1 + 3
gui(4).col1 = main_box.col2 - 25
gui(4).col2 = gui(4).col1 + 20
gui(5).row1 = main_box.row2 - 6
gui(5).row2 = gui(5).row1 + 2
gui(5).col1 = main_box.col1 + 2
gui(5).col2 = gui(5).col1 + (main_box.col2 - main_box.col1) \ 2 - 3
gui(6).row1 = main_box.row2 - 6
gui(6).row2 = gui(6).row1 + 2
gui(6).col1 = gui(5).col2 + 2
gui(6).col2 = main_box.col2 - 2
gui(7).row1 = main_box.row2 - 2
gui(7).col1 = (main_box.col2 - main_box.col1) / 4 + main_box.col1 - 4
gui(8).row1 = main_box.row2 - 2
gui(8).col1 = ((main_box.col2 - main_box.col1) / 4) * 2 + main_box.col1 - 3
gui(9).row1 = main_box.row2 - 2
gui(9).col1 = ((main_box.col2 - main_box.col1) / 4) * 3 + main_box.col1 - 3
main_box.c1 = box_c1
main_box.c2 = box_c2
gui(1).c1 = box_c1
gui(1).c2 = box_c2
gui(1).sc1 = box_sel_c1
gui(1).sc2 = box_sel_c2
gui(2).c1 = box_c1
gui(2).c2 = box_c2
gui(2).sc1 = box_sel_c1
gui(2).sc2 = box_sel_c2
gui(3).c1 = box_c1
gui(3).c2 = box_c2
gui(3).sc1 = box_sel_c1
gui(3).sc2 = box_sel_c2
gui(4).c1 = box_c1
gui(4).c2 = box_c2
gui(4).sc1 = box_sel_c1
gui(4).sc2 = box_sel_c2
gui(5).c1 = box_c1
gui(5).c2 = box_c2
gui(6).c1 = box_c1
gui(6).c2 = box_c2
gui(7).c1 = box_c1
gui(7).c2 = box_c2
gui(7).sc1 = box_sel_c1
gui(7).sc2 = box_sel_c2
gui(8).c1 = box_c1
gui(8).c2 = box_c2
gui(8).sc1 = box_sel_c1
gui(8).sc2 = box_sel_c2
gui(9).c1 = box_c1
gui(9).c2 = box_c2
gui(9).sc1 = box_sel_c1
gui(9).sc2 = box_sel_c2

RETURN
END SUB

SUB about_dialog () 'Displays 'about' box
DIM box AS box_type, ok_button(1) AS box_type
'box.nam = "About"
put_str box.nam, "About"
box.row1 = _HEIGHT(0) \ 2 - 3
box.row2 = box.row1 + 7
box.col1 = _WIDTH(0) \ 2 - 20
box.col2 = _WIDTH(0) \ 2 + 20
box.shadow = -1
box.c1 = box_c1
box.c2 = box_c2
box.text_box = -1

ok_button(1).button = -1
ok_button(1).row1 = box.row2 - 1
'ok_button(1).nam = "Close"
put_str ok_button(1).nam, "Close"
ok_button(1).col1 = box.col1 + (box.col2 - box.col1) \ 2 - 2
ok_button(1).c1 = box_c1
ok_button(1).c2 = box_c2
ok_button(1).sc1 = box_sel_c1
ok_button(1).sc2 = box_sel_c2

update = -1
exit_gui_flag = 0
DO: _LIMIT 100
  m = mouse_range(ok_button(), 1)
  IF update THEN
    update = 0
    draw_box box, 0
    draw_box ok_button(1), 1
    COLOR box_c1, box_c2
    d$ = "FTP Client version " + VER$
    LOCATE box.row1 + 2, _WIDTH(0) \ 2 - LEN(d$) \ 2
    PRINT d$;
    d$ = "Written by Matt Kilgore in QB64"
    LOCATE box.row1 + 4, _WIDTH(0) \ 2 - LEN(d$) \ 2
    PRINT d$;
    _AUTODISPLAY
    LOCATE ok_button(1).row1, ok_button(1).col1 + 1, 1
  END IF
  IF m = 1 OR INKEY$ > "" THEN: LOCATE , , 0: exit_gui_flag = -1
LOOP until exit_gui_flag
free_gui_element box
free_gui_array ok_button()
END SUB

SUB delete_file_GUI (local_or_remote AS INTEGER)
'meaning of local_or_remote:
'local_or_remote = 1 -- local
'local_or_remote = 0 -- remote

IF local_or_remote = 0 AND is_connected = 0 THEN
  dialog_disp "Please connect to a server first."
  EXIT SUB
END IF

IF local_or_remote = 0 THEN
  file$ = RTRIM$(get_str$(Remote_files(boxes(2).selected).nam))
ELSE
  file$ = RTRIM$(get_str$(Local_files(boxes(1).selected).nam))
END IF

IF file$ = ".." THEN EXIT SUB 'we can't delete '..'

prompt$ = "Do you really want to delete " + file$ + "?"
response = prompt_dialog(prompt$, 0, YES_BUTTON OR NO_BUTTON, NO_BUTTON)

IF response = YES_BUTTON THEN
  IF local_or_remote = 1 THEN
    delete_local_file file$
  ELSE
    delete_remote_file file$
  END IF
END IF


END SUB

