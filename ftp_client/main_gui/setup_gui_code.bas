'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

SUB setup_main_GUI () 'sets up the main GUI
'if scrn& <> 0 then _FREEIMAGE scrn& 'prevent memory leak
'scrn& = _NEWIMAGE(scrnw, scrnh, 0)
'SCREEN scrn&

'boxes(1).nam = "Local"
put_str boxes(1).nam, "Local"
boxes(1).col1 = 1
boxes(1).col2 = _WIDTH(0) \ 2
boxes(1).row1 = 2
boxes(1).row2 = _HEIGHT(0) - 2
boxes(1).c1 = main_gui_c1
boxes(1).c2 = main_gui_c2
boxes(1).sc1 = main_gui_sel_c1
boxes(1).sc2 = main_gui_sel_c2
boxes(1).scroll = -1
'boxes(1).length = 0
boxes(1).selected = 1
boxes(1).multi_text_box = -1

'boxes(2).nam = "Remote"
put_str boxes(2).nam, "Remote"
boxes(2).col1 = _WIDTH(0) \ 2 + 1
boxes(2).col2 = _WIDTH(0)
boxes(2).row1 = 2
boxes(2).row2 = _HEIGHT(0) - 2
boxes(2).c1 = main_gui_c1
boxes(2).c2 = main_gui_c2
boxes(2).sc1 = main_gui_sel_c1
boxes(2).sc2 = main_gui_sel_c2
boxes(2).scroll = -1
'boxes(2).length = 0
boxes(2).selected = 0
boxes(2).multi_text_box = -1

'boxes(3).nam = "MENU" 'Not actually drawn on the screen
put_str boxes(3).nam, "MENU"
boxes(3).row1 = 1
boxes(3).row2 = 1
boxes(3).col1 = 1
boxes(3).col2 = scrnw
boxes(3).menu = -1

menux.c1 = menu_c1
menux.c2 = menu_c2


END SUB
