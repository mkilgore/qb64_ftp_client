'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

SUB update_scrn () 'updates screen
COLOR 7, 1
FOR x = 2 TO _HEIGHT(0) - 1
  LOCATE x, 1
  PRINT SPACE$(_WIDTH(0));
NEXT x
COLOR status_c1, status_c2
LOCATE _HEIGHT(0), 1
PRINT SPACE$(_WIDTH(0));
LOCATE _HEIGHT(0), 1
PRINT "Status: "; status$;
if selected_Box = 1 then
  boxes(1).sc1 = main_gui_sel_c1
  boxes(1).sc2 = main_gui_sel_c2
  boxes(2).sc1 = file_non_sel
  boxes(2).sc2 = main_gui_c2
elseif selected_Box = 2 then
  boxes(2).sc1 = main_gui_sel_c1
  boxes(2).sc2 = main_gui_sel_c2
  boxes(1).sc1 = file_non_sel
  boxes(1).sc2 = main_gui_c2
else
  boxes(1).sc1 = file_non_sel
  boxes(1).sc2 = main_gui_c2
  boxes(2).sc1 = file_non_sel
  boxes(2).sc2 = main_gui_c2
end if
draw_box boxes(1), selected_box = 1
draw_box boxes(2), selected_box = 2
COLOR main_gui_c1, main_gui_c2
LOCATE _HEIGHT(0) - 1, 1
PRINT SPACE$(_WIDTH(0));
LOCATE _HEIGHT(0) - 1, 1
leng = _WIDTH(0) \ 2 - 1
IF LEN(Local_dir$) < leng THEN
  PRINT Local_dir$;
ELSE
  IF INSTR(Local_dir$, ":") THEN
    'Windows dir
    dir$ = LEFT$(Local_dir$, 3) + "..." + RIGHT$(Local_dir$, leng - 6)
  ELSE
    dir$ = "/..." + RIGHT$(Local_dir$, leng - 4)
  END IF
  PRINT dir$;
END IF
LOCATE _HEIGHT(0) - 1, leng + 3
IF LEN(Remote_dir$) < leng THEN
  PRINT Remote_dir$;
ELSE
  IF INSTR(Local_dir$, ":") THEN
    dir$ = LEFT$(Remote_dir$, 3) + "..." + RIGHT$(Remote_dir$, leng - 6)
  ELSE
    dir$ = "/..." + RIGHT$(Remote_dir$, leng - 4)
  END IF
  PRINT dir$;
END IF

IF selected_box = 3 THEN
  IF global_menu_sel > 0 AND temp_menu_sel = 0 THEN
    COLOR menu_c1, menu_c2
    LOCATE 1, 1
    PRINT SPACE$(_WIDTH(0));
    LOCATE 1, 1
    PRINT "  ";
    FOR x = 1 TO g_menu_c
      IF global_menu_sel = x THEN COLOR menu_sel_c1, menu_sel_c2: k = menu_sel_c1 ELSE COLOR menu_c1, menu_c2: k = menu_c1
      print_menu_no_hilight Global_Menu$(x)
    NEXT x
    draw_box menux, 0
    FOR x = 1 TO Menun(global_menu_sel)
      LOCATE menux.row1 + x, menux.col1 + 1
      IF menu_sel = x THEN
        COLOR menu_sel_c1, menu_sel_c2: k = menu_sel_c1
      ELSE
        COLOR menu_c1, menu_c2: k = menu_c1
      END IF
      IF Menu$(global_menu_sel, x) = "-" THEN
        p = POS(0): LOCATE , p - 1
        PRINT CHR$(195); STRING$(menu_max_len(global_menu_sel) - 1, 196); CHR$(180);
      ELSE
        print_menu Menu$(global_menu_sel, x) + SPACE$(menu_max_len(global_menu_sel) - LEN(Menu$(global_menu_sel, x))), k
      END IF
    NEXT x
  ELSE
    COLOR menu_c1, menu_c2
    LOCATE 1, 1
    PRINT SPACE$(_WIDTH(0));
    LOCATE 1, 1
    PRINT "  ";
    FOR x = 1 TO g_menu_c
      IF temp_menu_sel = x THEN COLOR menu_sel_c1, menu_sel_c2: k = menu_sel_c1 ELSE COLOR menu_c1, menu_c2: k = menu_c1
      print_menu Global_Menu$(x), k
    NEXT x
  END IF
ELSE
  COLOR menu_c1, menu_c2
  LOCATE 1, 1
  PRINT SPACE$(_WIDTH(0));
  LOCATE 1, 1
  PRINT "  ";
  FOR x = 1 TO g_menu_c
    print_menu_no_hilight Global_Menu$(x)
  NEXT x
END IF

END SUB

SUB print_files (b AS box_type, f() AS filedir_type) 'Displays files f() in box b()
'DIM s as string_type
if b.length > b.multi_line.length then
  reallocate_array b.multi_line, b.length + 2
end if
FOR x = 1 to b.multi_line.length 'b.row2 - b.row1 - 1
  if x <= b.length then
    k$ = get_Str$(f(x).nam)
    if len(k$) > b.col2 - b.col1 - 4 then
      k$ = mid$(k$, 1, b.col2 - b.col1 - 4)
    else
      k$ = k$ + space$((b.col2 - b.col1 - 4) - len(k$))
    end if
    if f(x).flag_cwd and f(x).flag_retr then
      k$ = k$ + "LNK"
    elseif f(x).flag_cwd then
      k$ = k$ + "DIR"
    else
      k$ = k$ + "   "
    end if
    put_str_array b.multi_line, x - 1, k$
  else
    put_str_array b.multi_line, x - 1, ""
  end if
next x

'free_string s
'COLOR b.c1, b.c2
'FOR x = 1 TO b.row2 - b.row1 - 1
'  LOCATE x + b.row1, b.col1 + 1
'  IF x + b.offset = b.selected AND selected THEN COLOR b.sc1, b.sc2 ELSE IF x + b.offset = b.selected THEN COLOR file_non_sel, b.c2 ELSE COLOR b.c1, b.c2
'  IF x + b.offset <= b.length THEN PRINT USING "\" + SPACE$(b.col2 - b.col1 - 8) + "\ \ \ "; get_str$(f(x + b.offset).nam); f(x + b.offset).dir; ELSE PRINT SPACE$(b.col2 - b.col1 - 1);
'NEXT x
END SUB
