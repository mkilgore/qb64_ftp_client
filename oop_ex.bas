
@define GUI_TEXT

'$include:'/mnt/data/git/qb64_ftp_client/mem_library/mem_lib.bi'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/gui_lib2.bi'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/elements/std_elements.bi'

DIM button as _OFFSET, ele AS LONG
button = GUI_element_button_new%&

print GUI_element_get_element_type&(button)

GUI_element_set_dimension button, 1, 1, 10, 10
print GUI_element_get_image&(button)
print GUI_element_get_row&(button)
print GUI_element_get_col&(button)
print GUI_element_get_width&(button)
print GUI_element_get_height&(button)

_DEST GUI_element_get_image&(button)

locate 1, 1
color 3, 4
print "Test!"

_DEST 0

'_PUTIMAGE (GUI_element_get_row&(button) + 1, GUI_element_get_col&(button) + 1), GUI_element_get_image&(button), 0
SLEEP

GUI_put_image GUI_element_get_row&(button), GUI_element_get_col&(button), GUI_element_get_image&(button), 0


'SYSTEM


'$include:'/mnt/data/git/qb64_ftp_client/mem_library/mem_lib.bm'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/gui_lib2.bm'
'$include:'/mnt/data/git/qb64_ftp_client/gui_library/elements/std_elements.bm'
