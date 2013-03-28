'GUI Library
'Copyright Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

CONST GUI_VER$ = ".90"

CONST GUI_DEBUG = 0 'Set to -1 to turn on debug mode

'CONST values coresponding to a element type
CONST GUI_BOX           = 1
CONST GUI_INPUT_BOX     = 2
CONST GUI_TEXT_BOX      = 3
CONST GUI_LIST_BOX      = 4
CONST GUI_DROP_DOWN     = 5
CONST GUI_CHECKBOX      = 6
CONST GUI_MENU          = 7
CONST GUI_BUTTON        = 8
CONST GUI_RADIO_BUTTON  = 9
CONST GUI_LABEL         = 10
'CONST GUI_COMBO_BOX     = 11

'Flags for GUI_element_type
CONST GUI_FLAG_UPDATED            = &H00000001
CONST GUI_FLAG_SKIP               = &H00000002
CONST GUI_FLAG_SHADOW             = &H00000004
CONST GUI_FLAG_DIALOG             = &H00000008
CONST GUI_FLAG_HIDE               = &H00000010
CONST GUI_FLAG_SCROLL_V           = &H00000020
CONST GUI_FLAG_SCROLL_H           = &H00000040
CONST GUI_FLAG_SCROLL_IS_HELD_V   = &H00000080
CONST GUI_FLAG_SCROLL_IS_HELD_H   = &H00000100
CONST GUI_FLAG_DROP_FLAG          = &H00000200
CONST GUI_FLAG_CHECKED            = &H00000400
CONST GUI_FLAG_MENU_OPEN          = &H00000800
CONST GUI_FLAG_MENU_ALT           = &H00001000
CONST GUI_FLAG_MENU_CHOSEN        = &H00002000
CONST GUI_FLAG_MENU_LAST_ON_RIGHT = &H00004000

'Byte 1
CONST GUI_EVENT_MOUSE             = &H00000001
CONST GUI_EVENT_KEYBOARD          = &H00000002

'Byte 2
CONST GUI_EVENT_CHECK_CHANGED     =  1 * &H00000100

TYPE GUI_menu_item_type
  nam as MEM_string_type 'Displayed string for MENU choice
  ident as STRING * 5 'identifer string
  'The ident string will be returned in menu_choice
  'when a choice is chosen. Use the identifier to match
  'what menu choice they did. More reliable then mapping
  'choices to exact locations in the menu -- they change when you edit the menu

  'support for modifiers will be added at a later date, sorry.
  'modifier as STRING * 2 'INKEY$ return
  has_sub AS _BYTE 'If -1 then sub_menu is set
  sub_menu as _MEM 'Points to an array of GUI_menu_item_type
  sub_menu_length AS INTEGER
  sub_menu_open as _BYTE
  key_combo as MEM_string_type
  selected AS INTEGER 'current
END TYPE

TYPE GUI_color_type 'Holds color info -- forground and background
  fr as _BYTE
  bk as _BYTE
END TYPE

TYPE GUI_element_colors_type 'holds colors
  mcolor as GUI_color_type
  selcolor as GUI_color_type
  scroll_color as GUI_color_type
END TYPE

TYPE GUI_element_type
  nam AS MEM_string_type 'name of item
  element_type AS _BYTE
  row1 AS INTEGER 'location
  col1 AS INTEGER
  row2 AS INTEGER
  col2 AS INTEGER
  flags AS _UNSIGNED LONG 'Coresponds to the above flags
  'inheret AS _UNSIGNED LONG
  c as GUI_element_colors_type
  layer AS _BYTE
  text AS MEM_string_type 'text drawn/edited in a Input-Box
  text_position AS INTEGER 'position of the cursor in the input
  text_sel_row1 AS INTEGER
  text_sel_row2 AS INTEGER
  text_sel_col1 AS INTEGER
  text_sel_col2 AS INTEGER
  
  scroll_offset_vert AS INTEGER 'current scroll offset -- calculated in draw_gui function
  scroll_offset_hors AS INTEGER
  
  scroll_loc_hors AS INTEGER 'current location of scroll-bar
  scroll_loc_vert AS INTEGER
  scroll_max_hors AS INTEGER 'Max number of characters in a line -- If 0 then will be automatically calculated (Which is a bit slower)
  length AS INTEGER ' Length of string array
  selected AS INTEGER 'selected line in list-box, drop-down, etc.
  selected_old AS INTEGER
  lines AS MEM_array_type ' Array to store strings for list-box, drop-down, etc.
  menu as _MEM ' Points to an actual array of menu_items
  menu_padding as INTEGER 'Spaces padded before start of menu
  menu_choice AS STRING * 5

  group as INTEGER 'group number for radio buttons
  cur_row AS INTEGER
  cur_col AS INTEGER
  'This does not corespond to the displayed number of lines, just the real max allocation length of lines
  max_lines AS _UNSIGNED INTEGER 'If 0 then the lines array will automatically be reallocated, else we won't go over max_lines
  'parent AS _MEM
END TYPE

TYPE GUI_event_type
  event_type as _UNSIGNED LONG
  e_num as _UNSIGNED _BYTE
END TYPE

'shared variables for mouse
COMMON SHARED GUI_MX         AS INTEGER, GUI_MY             AS INTEGER, GUI_BUT         AS INTEGER,       GUI_MSCROLL  AS INTEGER, GUI_BUTFLAG    AS INTEGER
COMMON SHARED GUI_CUR_ROW    AS INTEGER, GUI_CUR_COL        AS INTEGER, GUI_alt_flag    AS INTEGER,       GUI_ctl_flag AS INTEGER, GUI_shift_flag AS INTEGER
COMMON SHARED GUI_DRAG_TIMER AS DOUBLE,  GUI_LAST_USED_RNUM AS LONG
'default colors -- Values are set by GUI_init and are changable at any time
COMMON SHARED GUI_DEFAULT_COLOR_BOX   as GUI_element_colors_type, GUI_DEFAULT_COLOR_INPUT    as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_COLOR_TEXT  as GUI_element_colors_type, GUI_DEFAULT_COLOR_LIST     as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_COLOR_DROP  as GUI_element_colors_type, GUI_DEFAULT_COLOR_CHECKBOX as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_COLOR_MENU  as GUI_element_colors_type, GUI_DEFAULT_COLOR_BUTTON   as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_COLOR_RADIO as GUI_element_colors_type, GUI_DEFAULT_COLOR_LABEL    as GUI_element_colors_type

'Default colors for dialogs
COMMON SHARED GUI_DEFAULT_DIALOG_COLOR_BOX   as GUI_element_colors_type, GUI_DEFAULT_DIALOG_COLOR_INPUT    as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_DIALOG_COLOR_TEXT  as GUI_element_colors_type, GUI_DEFAULT_DIALOG_COLOR_LIST     as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_DIALOG_COLOR_DROP  as GUI_element_colors_type, GUI_DEFAULT_DIALOG_COLOR_CHECKBOX as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_DIALOG_COLOR_MENU  as GUI_element_colors_type, GUI_DEFAULT_DIALOG_COLOR_BUTTON   as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_DIALOG_COLOR_RADIO as GUI_element_colors_type, GUI_DEFAULT_DIALOG_COLOR_LABEL    as GUI_element_colors_type
COMMON SHARED GUI_MOUSE_QUEUE$

DIM SHARED GUI_alt_codes$(51) ' thanks to Galleon for alt-code stuff
