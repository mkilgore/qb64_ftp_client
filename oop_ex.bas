@define GUI_TEXT

'$include:'/mnt/data/git/qb64_ftp_client/mem_library/mem_lib.bi'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/gui_lib2.bi'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/elements/std_elements.bi'

DIM Win AS _OFFSET, button as _OFFSET, ele AS LONG

Win = GUI_element_window_new_with_size_title%&(25, 80, "Hey!")
GUI_element_show Win
GUI_element_window_set_as_screen win
button = GUI_element_button_new_with_text%&("Hi!")
GUI_element_set_location button, 20, 15

GUI_element_container_add Win, button

@call(_OFFSET) @(Win, GUI_element.drw, @PROC), Win

'@call(_OFFSET) @(button, GUI_element.drw, @PROC), button

'GUI_put_image GUI_element_get_row&(button), GUI_element_get_col&(button), GUI_element_get_image&(button), 0

'_PUTIMAGE (GUI_element_get_row&(button) + 1, GUI_element_get_col&(button) + 1), GUI_element_get_image&(button), 0
SLEEP

'GUI_put_image GUI_element_get_row&(button), GUI_element_get_col&(button), GUI_element_get_image&(button), 0

'SYSTEM

'$include:'/mnt/data/git/qb64_ftp_client/mem_library/mem_lib.bm'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/gui_lib2.bm'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/elements/std_elements.bm'
