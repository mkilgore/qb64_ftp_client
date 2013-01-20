'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

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
