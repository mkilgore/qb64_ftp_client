SUB print_menu_no_hilight (a$) 'Prints a$ without the '#' and no hilighting
PRINT MID$(a$, 1, INSTR(a$, "#") - 1);
PRINT MID$(a$, INSTR(a$, "#") + 1);
END SUB

SUB print_menu (a$, s) 'Prints a$ with the character after '#' hilighted in bright white
PRINT MID$(a$, 1, INSTR(a$, "#") - 1);
COLOR menu_char_c
PRINT MID$(a$, INSTR(a$, "#") + 1, 1);
COLOR s
PRINT MID$(a$, INSTR(a$, "#") + 2);
END SUB

FUNCTION menu_len (a$) 'Length of menu item a$.
'Just takes one away from the length if the string has a '#'`
IF INSTR(a$, "#") THEN
  menu_len = LEN(a$) - 1
ELSE
  menu_len = LEN(a$)
END IF
END FUNCTION

FUNCTION menu_char$ (a$) 'Get's the hilighted character
menu_char$ = MID$(a$, INSTR(a$, "#") + 1, 1)
END FUNCTION
