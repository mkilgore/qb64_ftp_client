'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

FUNCTION move_to_next_gui (movement$, current_selected, gui() AS box_type, gui_num)
'function moves to next gui based on
selected_row = gui(current_selected).row1
selected_col = gui(current_selected).col1
new_col = -1 'distance from selected object
new_row = -1
new_gui = -1
'DIM choices(UBOUND(gui)) AS INTEGER
'things are judged by distance
'in event that there are more then one selected item, which normally happens, we select the closer object

SELECT CASE movement$
  CASE CHR$(0) + CHR$(72) 'up
    FOR x = 1 TO gui_num
      IF gui(x).row1 < selected_row AND gui(x).row1 >= new_row THEN
        IF gui(x).col1 = new_col THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        ELSEIF new_col = -1 THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        ELSEIF gui(x).col1 < new_col THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        END IF
      END IF
    NEXT x
  CASE CHR$(0) + CHR$(80) 'down
    FOR x = 1 TO gui_num
      IF gui(x).row1 > selected_row AND (gui(x).row1 <= new_row OR new_row = -1) THEN
        IF gui(x).col1 = new_col THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        ELSEIF new_col = -1 THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        ELSEIF gui(x).col1 < new_col THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        END IF
      END IF
    NEXT x
  CASE CHR$(0) + CHR$(75) 'left
    FOR x = 1 TO gui_num
      IF gui(x).col1 < selected_col AND (gui(x).col1 >= new_col) THEN
        IF gui(x).row1 = new_row THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        ELSEIF new_row = -1 THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        ELSEIF gui(x).row1 > new_row THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        END IF
      END IF
    NEXT x
  CASE CHR$(0) + CHR$(77) 'right
    FOR x = 1 TO gui_num
      IF gui(x).col1 > selected_col AND (gui(x).col1 <= new_col OR new_col = -1) THEN
        IF gui(x).row1 = new_row THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        ELSEIF new_row = -1 THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        ELSEIF gui(x).row1 < new_row THEN
          new_gui = x
          new_row = gui(x).row1
          new_col = gui(x).col1
        END IF
      END IF
    NEXT x
END SELECT
move_to_next_gui = new_gui
END FUNCTION

FUNCTION update_input_boxes (gui() AS box_type, sel AS INTEGER, ch$)
IF gui(sel).text_box THEN
  SELECT CASE ch$
    CASE " " TO "~"
      add_character gui(sel), ch$
      update_input_boxes = -1
    CASE CHR$(8)
      del_character gui(sel)
      update_input_boxes = -1
    CASE CHR$(0) + CHR$(75)
      IF gui(sel).text_position > 0 THEN
        gui(sel).text_position = gui(sel).text_position - 1
        IF gui(sel).text_position < gui(sel).text_offset THEN
          gui(sel).text_offset = gui(sel).text_offset - 1
        END IF
        update_input_boxes = -1
      END IF
    CASE CHR$(0) + CHR$(77)
      IF gui(sel).text_position < gui(sel).text.length THEN
        gui(sel).text_position = gui(sel).text_position + 1
        IF gui(sel).text_position > gui(sel).text_offset + (gui(sel).col2 - gui(sel).col1 - 1) THEN
          gui(sel).text_offset = gui(sel).text_offset + 1
        END IF
        update_input_boxes = -1
      END IF
  END SELECT
END IF
END FUNCTION

SUB draw_box (b AS box_type, sel) 'Draws box b -- this sub draws all the GUI parts
'Draws a box
IF b.text_box THEN
  IF b.shadow THEN
    FOR x = b.row1 + 1 TO b.row2 + 1
      FOR y = b.col1 + 2 TO b.col2 + 2
        chr = SCREEN(x, y)
        colo = SCREEN(x, y, 1)
        LOCATE x, y
        COLOR colo MOD 8, 0
        PRINT CHR$(chr);
      NEXT y
    NEXT x
  END IF
  IF b.scroll THEN b.scroll_loc = INT((b.offset) / (b.length - (b.row2 - b.row1 - 1)) * (b.row2 - b.row1 - 4) + b.row1 + 2)
  n$ = get_str$(b.nam)
  COLOR b.c1, b.c2
  LOCATE b.row1, b.col1
  PRINT CHR$(218); CHR$(196); n$; STRING$(b.col2 - b.col1 - 2 - LEN(n$), 196); CHR$(191);
  FOR x = b.row1 + 1 TO b.row2 - 1
    LOCATE x, b.col1
    COLOR b.c1, b.c2
    PRINT CHR$(179); SPACE$(b.col2 - b.col1 - 1);

    IF b.scroll = 0 THEN
      PRINT CHR$(179);
    ELSE
      COLOR 7
      SELECT CASE x
        CASE b.row1 + 1
          COLOR 0, 7
          PRINT CHR$(24);
        CASE b.row2 - 1
          COLOR 0, 7
          PRINT CHR$(25);
        CASE ELSE
          COLOR 0, 7
          IF b.scroll_loc = x THEN
            PRINT CHR$(219);
          ELSE
            PRINT CHR$(176);
          END IF
      END SELECT
    END IF
  NEXT x
  COLOR b.c1 MOD 8, b.c2
  LOCATE b.row2, b.col1
  PRINT CHR$(192); STRING$(b.col2 - b.col1 - 1, 196); CHR$(217);
  'if sel then color b.sc1, b.sc2 else COLOR b.c1, b.c2
  LOCATE b.row1 + 1, b.col1 + 1
  s$ = MID$(get_str$(b.text), b.text_offset + 1, b.col2 - b.col1 - 1)
  IF NOT b.hide THEN PRINT s$; ELSE PRINT STRING$(LEN(s$), "*");
ELSEIF b.multi_text_Box THEN
    IF b.shadow THEN
        FOR x = b.row1 + 1 TO b.row2 + 1
            FOR y = b.col1 + 2 TO b.col2 + 2
                chr = SCREEN(x, y)
                colo = SCREEN(x, y, 1)
                LOCATE x, y
                COLOR colo MOD 8, 0
                PRINT CHR$(chr);
            NEXT y
        NEXT x
    END IF
    IF b.scroll THEN b.scroll_loc = INT((b.offset) / (b.length -  (b.row2 - b.row1 - 1)) * (b.row2 - b.row1 - 4) + b.row1 + 2)
    n$ = get_str$(b.nam)
    COLOR b.c1, b.c2
    LOCATE b.row1, b.col1
    PRINT CHR$(218); CHR$(196); n$; STRING$(b.col2 - b.col1 - 2 - LEN(n$), 196); CHR$(191);
    FOR x = b.row1 + 1 TO b.row2 - 1
        LOCATE x, b.col1
        COLOR b.c1, b.c2
        PRINT CHR$(179); SPACE$(b.col2 - b.col1 - 1);

        IF b.scroll = 0 THEN
            PRINT CHR$(179);
        ELSE
            COLOR 7
            SELECT CASE x
                CASE b.row1 + 1
                    COLOR 0, 7
                    PRINT CHR$(24);
                CASE b.row2 - 1
                    COLOR 0, 7
                    PRINT CHR$(25);
                CASE ELSE
                    COLOR 0, 7
                    IF b.scroll_loc = x THEN
                        PRINT CHR$(219);
                    ELSE
                        PRINT CHR$(176);
                    END IF
            END SELECT
        END IF
    NEXT x
    COLOR b.c1 MOD 8, b.c2
    LOCATE b.row2, b.col1
    PRINT CHR$(192); STRING$(b.col2 - b.col1 - 1, 196); CHR$(217);
    'FOR x = 1 to b.multi_line.length
    '  PRINT get_str_array$(b.multi_line, x)
    '  sleep 
    'next x
    for x = 1 to b.row2 - b.row1 - 1
      locate x + b.row1, b.col1 + 1
      if (b.selected - b.offset) = (x) then
        color b.sc1, b.sc2
      else
        color b.c1, b.c2
      end if
      print mid$(get_str_array$(b.multi_line, x + b.offset - 1), 1, b.col2 - b.col1 -1);
      'print "LINE"; x ; ": "; mid$(get_str_array$(b.multi_line, x + b.text_offset - 1), 1, b.row2 - b.row1 - 1);
      'sleep
    next x
ELSEIF b.button THEN
  LOCATE b.row1, b.col1
  IF sel THEN COLOR b.sc1, b.sc2 ELSE COLOR b.c1 MOD 8, b.c2
  PRINT "<";
  'IF sel THEN COLOR b.selcol, b.c2 ELSE COLOR b.c1 MOD 8, b.c2
  'COLOR b.c1 MOD 8, b.c2
  PRINT get_str$(b.nam);
  IF sel THEN COLOR b.sc1, b.sc2 ELSE COLOR b.c1 MOD 8, b.c2
  PRINT ">";
ELSEIF b.checkbox THEN
  LOCATE b.row1, b.col1
  IF sel THEN COLOR b.sc1, b.sc2 ELSE COLOR b.c1 MOD 8, b.c2
  PRINT "[";
  IF b.checked THEN PRINT "X"; ELSE PRINT " ";
  PRINT "]";
  COLOR b.c1 MOD 8, b.c2
  PRINT get_str$(b.nam);
ELSEIF b.drop_down THEN
  _CONTROLCHR OFF

  LOCATE b.row1, b.col1
  COLOR b.c1, b.c2
  IF b.d_flag THEN PRINT CHR$(218); ELSE PRINT "[";
  IF sel THEN COLOR b.sc1, b.sc2
  PRINT LEFT$(get_str$(b.nam) + SPACE$(b.col2 - b.col1), b.col2 - b.col1 - 2); CHR$(31);
  COLOR b.c1, b.c2
  IF b.d_flag THEN PRINT CHR$(191); ELSE PRINT "]";

  _CONTROLCHR ON
END IF
END SUB


FUNCTION mouse_range (b() AS box_type, boxnum) 'Checks if mouse is in one of the boxes in b()
'Returns the array number if it is in one of them
mscroll = 0
DO WHILE _MOUSEINPUT
  mscroll = mscroll + _MOUSEWHEEL
  mx = _MOUSEX
  my = _MOUSEY
  but = _MOUSEBUTTON(1)
LOOP
IF but = -1 AND butflag = -1 THEN
  but = 0
  EXIT FUNCTION
ELSE
  butflag = 0
END IF
IF but = 0 THEN EXIT FUNCTION
butflag = -1
FOR x = 1 TO boxnum
  IF b(x).text_box THEN
    IF my <= b(x).row2 AND my >= b(x).row1 THEN
      IF mx >= b(x).col1 AND mx <= b(x).col2 THEN
        mouse_range = x
        IF my = b(x).row1 + 1 THEN
          IF mx > b(x).col1 + 1 AND mx < b(x).col2 - 1 THEN
            b(x).text_position = b(x).text_offset + mx - b(x).col1 - 1
            IF b(x).text_position > b(x).text.length THEN
              b(x).text_position = b(x).text.length
            END IF
            b(x).updated = -1
          END IF
        END IF
        EXIT FUNCTION
      END IF
    END IF
  ELSEIF b(x).menu then
    if my = b(x).row1 then
      b(x).updated = -1
      mouse_range = x
    end if
  ELSEIF b(x).multi_text_Box then
    IF my <= b(x).row2 AND my >= b(x).row1 THEN
      IF mx >= b(x).col1 AND mx <= b(x).col2 THEN
        mouse_range = x
        IF my = b(x).row1 + 1 THEN
          IF mx > b(x).col1 + 1 AND mx < b(x).col2 - 1 THEN
            b(x).text_position = b(x).text_offset + mx - b(x).col1 - 1
            IF b(x).text_position > b(x).text.length THEN
              b(x).text_position = b(x).text.length
            END IF
            b(x).updated = -1
          END IF
        END IF
        EXIT FUNCTION
      END IF
    END IF
  ELSEIF b(x).button THEN
    IF my = b(x).row1 AND mx >= b(x).col1 AND mx <= b(x).col1 + LEN(get_str$(b(x).nam)) + 1 THEN
      mouse_range = x
      EXIT FUNCTION
    END IF
  ELSEIF b(x).checkbox THEN
    IF my = b(x).row1 AND mx >= b(x).col1 AND mx <= b(x).col1 + 2 + LEN(get_str$(b(x).nam)) THEN
      mouse_range = x
      EXIT FUNCTION
    END IF
  ELSEIF b(x).drop_down THEN
    IF my = b(x).row1 AND mx >= b(x).col1 AND mx <= b(x).col2 THEN
      mouse_range = x
      EXIT FUNCTION
    END IF
  END IF
NEXT x
END FUNCTION

SUB dialog_disp (dialog$) 'Displays a dialog box with the text dialog$ inside
IF NOT cmd_mode THEN
  DIM box AS box_type
  'box.nam = ""
  put_str box.nam, ""
  box.row1 = _HEIGHT(0) \ 2 - 1
  box.row2 = _HEIGHT(0) \ 2 + 1
  box.col1 = _WIDTH(0) \ 2 - (LEN(dialog$) + 2) \ 2
  box.col2 = _WIDTH(0) \ 2 + (LEN(dialog$) + 2) \ 2
  box.shadow = -1
  box.c1 = box_c1
  box.c2 = box_c2
  box.text_box = -1
  draw_box box, 0
  LOCATE box.row1 + 1, _WIDTH(0) \ 2 - LEN(dialog$) \ 2
END IF
PRINT dialog$
IF NOT cmd_mode THEN
  _DISPLAY
  t# = TIMER
  DO: _LIMIT 100: LOOP UNTIL INKEY$ > "" OR TIMER - t# > 1.5
  free_gui_element box
END IF
END SUB

FUNCTION prompt_dialog (dialog$, tim, buttons, default)
'dialog$ will be printed above choices. If dialog$ contains CHR$(13), each one represents a new line
'tim is seconds still close
'if tim is reached, then default is returned
gui_num = 0
IF buttons AND OK_BUTTON THEN gui_num = gui_num + 1
IF buttons AND NO_BUTTON THEN gui_num = gui_num + 1
IF buttons AND CLOSE_BUTTON THEN gui_num = gui_num + 1
IF buttons AND CANCEL_BUTTON THEN gui_num = gui_num + 1
IF buttons AND YES_BUTTON THEN gui_num = gui_num + 1
DIM gui(gui_num) AS box_type, main_Box AS box_type
IF INSTR(dialog$, CHR$(13)) THEN
  rows_add = 0
  k$ = dialog$
  DO
    rows_add = rows_add + 1
    k$ = MID$(k$, INSTR((k$), CHR$(13)) + 1)
  LOOP UNTIL INSTR(k$, CHR$(13)) = 0
  rows_add = rows_add + 1
ELSE
  rows_add = 1
END IF

DIM rows$(rows_add)
IF INSTR(dialog$, CHR$(13)) THEN
  k$ = dialog$
  FOR x = 1 TO rows_add - 1
    rows$(x) = MID$(k$, 1, INSTR(k$, CHR$(13)) - 1)
    k$ = MID$(k$, INSTR(k$, CHR$(13)) + 1)
    IF LEN(rows$(x)) > box_width THEN box_width = LEN(rows$(x))
  NEXT x
  rows$(rows_add) = k$
  IF LEN(rows$(rows_add)) > box_width THEN box_width = LEN(rows$(rows_add))
ELSE
  rows$(1) = dialog$
  box_width = LEN(rows$(1))
END IF
box_width = box_width + 4

IF box_width < 40 THEN box_width = 40

'main_Box.nam = ""
put_str main_Box.nam, ""
main_Box.text_box = -1
main_Box.c1 = box_c1
main_Box.c2 = box_c2
main_Box.row1 = _HEIGHT(0) / 2 - 2
main_Box.row2 = main_Box.row1 + 3 + rows_add
IF tim > 0 THEN main_Box.row2 = main_Box.row2 + 1
main_Box.col1 = _WIDTH(0) / 2 - box_width \ 2
main_Box.col2 = main_Box.col1 + box_width
main_Box.shadow = -1

FOR x = 1 TO gui_num
  gui(x).button = -1
  gui(x).c1 = box_c1
  gui(x).c2 = box_c2
  gui(x).sc1 = box_sel_c1
  gui(x).sc2 = box_sel_c2
  gui(x).row1 = main_Box.row2 - 1
  gui(x).col1 = main_Box.col1 + ((main_Box.col2 - main_Box.col1) / (gui_num + 1)) * x
  IF NOT ok_flag AND (buttons AND OK_BUTTON) THEN
    ok_flag = -1
    'gui(x).nam = "OK"
    put_str gui(x).nam, "OK"
    gui(x).col1 = gui(x).col1 - 2
  ELSEIF NOT cancel_flag AND (buttons AND CANCEL_BUTTON) THEN
    cancel_flag = -1
    ' gui(x).nam = "CANCEL"
    put_str gui(x).nam, "CANCEL"
    gui(x).col1 = gui(x).col1 - 4
  ELSEIF NOT yes_flag AND (buttons AND YES_BUTTON) THEN
    yes_flag = -1
    ' gui(x).nam = "YES"
    put_str gui(x).nam, "YES"
    gui(x).col1 = gui(x).col1 - 2
  ELSEIF NOT no_flag AND (buttons AND NO_BUTTON) THEN
    no_flag = -1
    ' gui(x).nam = "NO"
    put_str gui(x).nam, "NO"
    gui(x).col1 = gui(x).col1 - 2
  ELSEIF NOT close_flag AND (buttons AND CLOSE_BUTTON) THEN
    close_flag = -1
    ' gui(x).nam = "CLOSE"
    put_str gui(x).nam, "CLOSE"
    gui(x).col1 = gui(x).col1 - 3
  END IF
NEXT x

update = -1
curr = 1
curc = 1
t# = TIMER
DO
  _LIMIT 100
  m = mouse_range(gui(), gui_num)
  IF m > 0 THEN
    s_box = m
    update = -1
    exit_flag = -1
  END IF
  IF update THEN
    update = 0
    _DISPLAY
    draw_box main_Box, 0
    COLOR box_c1, box_c2
    FOR x = 1 TO rows_add
      LOCATE main_Box.row1 + x, main_Box.col1 + (main_Box.col2 - main_Box.col1) / 2 - LEN(rows$(x)) / 2
      PRINT rows$(x);
    NEXT x
    'PRINT dialog$; STR$(gui_num);
    IF tim > 0 THEN
      s$ = "Dialog will close in" + STR$(tim - INT(TIMER - t#)) + " seconds..."
      LOCATE main_Box.row1 + 1 + rows_add, main_Box.col1 + (main_Box.col2 - main_Box.col1) / 2 - LEN(s$) / 2
      PRINT s$;
      LOCATE main_Box.row1 + 2 + rows_add, main_Box.col1
    ELSE
      LOCATE main_Box.row1 + 1 + rows_add, main_Box.col1
    END IF
    PRINT CHR$(195); STRING$(main_Box.col2 - main_Box.col1 - 1, 196); CHR$(180);
    FOR x = 1 TO gui_num
      draw_box gui(x), s_box = x
      IF s_box = x THEN
        curr = gui(x).row1
        curc = gui(x).col1 + 1
      END IF
    NEXT x
    _AUTODISPLAY
    LOCATE curr, curc, 1
  END IF
  a$ = INKEY$
  SELECT CASE a$
    CASE CHR$(9)
      s_box = (s_box MOD gui_num) + 1
      update = -1
    CASE CHR$(13)
      exit_flag = -1
    CASE CHR$(0) + CHR$(72), CHR$(0) + CHR$(80), CHR$(0) + CHR$(75), CHR$(0) + CHR$(77)
      new_gui = move_to_next_gui(a$, s_box, gui(), gui_num)
      IF new_gui > -1 THEN
        s_box = new_gui
        update = -1
      END IF
  END SELECT
  IF TIMER - t# > tsav THEN
    tsav = TIMER - t# + .2
    update = -1
  END IF
LOOP UNTIL exit_flag OR (TIMER - t# > tim AND tim > 0)
_DISPLAY
IF TIMER - t# > tim AND tim > 0 THEN
  prompt_dialog = default
ELSEIF get_str$(gui(s_box).nam) = "OK" THEN
  prompt_dialog = OK_BUTTON
ELSEIF get_str$(gui(s_box).nam) = "CLOSE" THEN
  prompt_dialog = CLOSE_BUTTON
ELSEIF get_str$(gui(s_box).nam) = "CANCEL" THEN
  prompt_dialog = CANCEL_BUTTON
ELSEIF get_str$(gui(s_box).nam) = "NO" THEN
  prompt_dialog = NO_BUTTON
ELSEIF get_str$(gui(s_box).nam) = "YES" THEN
  prompt_dialog = YES_BUTTON
END IF
LOCATE , , 0
free_gui_element main_box
free_gui_array gui()
END FUNCTION
