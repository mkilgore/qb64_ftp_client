'GUI Library
'Copyright Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

CONST GUI_VER$ = ".85"

CONST GUI_DEBUG = 0 'Set to -1 to turn on debug mode

'CONST values coresponding to a element type
CONST GUI_BOX = 1
CONST GUI_INPUT_BOX = 2
CONST GUI_TEXT_BOX = 3
CONST GUI_LIST_BOX = 4
CONST GUI_DROP_DOWN = 5
CONST GUI_CHECKBOX = 6
CONST GUI_MENU = 7
CONST GUI_BUTTON = 8
CONST GUI_RADIO_BUTTON = 9
CONST GUI_LABEL = 10

'Flags for GUI_element_type
CONST GUI_FLAG_UPDATED =            &H00000001       '&B1
CONST GUI_FLAG_SKIP =               &H00000002       '&B10
CONST GUI_FLAG_SHADOW =             &H00000004       '&B100
CONST GUI_FLAG_DIALOG =             &H00000008       '&B1000
CONST GUI_FLAG_HIDE =               &H00000010       '&B10000
CONST GUI_FLAG_SCROLL_V =           &H00000020       '&B100000
CONST GUI_FLAG_SCROLL_H =           &H00000040       '&B1000000
CONST GUI_FLAG_SCROLL_IS_HELD_V =   &H00000080       '&B10000000
CONST GUI_FLAG_SCROLL_IS_HELD_H =   &H00000100       '&B100000000
CONST GUI_FLAG_DROP_FLAG =          &H00000200       '&B1000000000
CONST GUI_FLAG_CHECKED =            &H00000400       '&B10000000000
CONST GUI_FLAG_MENU_OPEN =          &H00000800       '&B100000000000
CONST GUI_FLAG_MENU_ALT =           &H00001000       '&B1000000000000
CONST GUI_FLAG_MENU_CHOSEN =        &H00002000       '&B10000000000000
CONST GUI_FLAG_MENU_LAST_ON_RIGHT = &H00004000       '&B100000000000000


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
  '0 -- Nothing
  '1 -- Box                  -- Draws a plain box with nothing inside
  '2 -- Input-Box            -- Box is forced to 3 rows, single line input
  '3 -- text-box             -- Multi-line input
  '4 -- List-Box             -- Multiple lines -- Lists lines and allows one to be selected
  '5 -- Drop-down            -- Displays as one line, but when clicked on a box appears with multiple selecteable items
  '6 -- CheckBox             -- Displays a label along with an empty or filled Box, which can be toggled by clicking on it
  '7 -- Menu handler         -- Indicates this element is a menu (Menus are a bit more complex -- see documentation)
  '8 -- Button               -- Just a simple button
  '9 -- Radio button         -- Like a checkbox, but they can be linked together so that only one in a group is selectable at a time
  '10 - Label                -- Just plain text (Prints text at row1, col1). skip is set by default
  '      V      -- not implemented just yet
  ' -- Combo Box

  row1 AS INTEGER 'location
  col1 AS INTEGER
  row2 AS INTEGER
  col2 AS INTEGER

  flags AS _UNSIGNED LONG 'Coresponds to the above flags

  c as GUI_element_colors_type
  'mcolor as GUI_color_type 'Used for drawing most things on screen
  'selcolor as GUI_color_type 'Used when drawing things such as the selected text
  'scroll_color as GUI_color_type 'Normally used for scroll bars

  ' Just a number indicating the layering.
  ' Default layer is zero. If you need something to be ontop of something else, put it in a higher layer
  layer AS _BYTE

  text AS MEM_string_type 'text drawn/edited in a Input-Box

  text_position AS INTEGER 'position of the cursor in the input
  'text_offset AS INTEGER 'We display the string in the box starting at the text_offset character, to account for scrolling to the right
  text_sel_row1 AS INTEGER
  text_sel_row2 AS INTEGER
  text_sel_col1 AS INTEGER
  text_sel_col2 AS INTEGER

  scroll_offset_vert AS INTEGER 'current scroll offset -- calculated in draw_gui function
  scroll_offset_hors AS INTEGER

  scroll_loc_hors AS INTEGER 'current location of scroll-bar
  scroll_loc_vert AS INTEGER

  scroll_max_hors AS INTEGER 'Max number of characters in a line -- If 0 then will be automatically calculated (Which is a bit slower)
  'The length variable is used in place of a "scroll_max_vert" variable

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

  'If this GUI is currently selected, then you should do a:
  'LOCATE cur_row, cur_col, 1
  'to locate the cursor
  
  rnum as _UNSIGNED INTEGER
END TYPE

'shared variables for mouse
COMMON SHARED GUI_MX AS INTEGER, GUI_MY AS INTEGER, GUI_BUT AS INTEGER, GUI_MSCROLL AS INTEGER, GUI_BUTFLAG AS INTEGER
COMMON SHARED GUI_CUR_ROW AS INTEGER, GUI_CUR_COL AS INTEGER, GUI_alt_flag AS INTEGER, GUI_ctl_flag AS INTEGER, GUI_shift_flag AS INTEGER
COMMON SHARED GUI_DRAG_TIMER AS DOUBLE, GUI_LAST_USED_RNUM AS LONG

'default colors -- Values are set by GUI_init and are changable at any time
COMMON SHARED GUI_DEFAULT_COLOR_BOX as GUI_element_colors_type, GUI_DEFAULT_COLOR_INPUT as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_COLOR_TEXT as GUI_element_colors_type, GUI_DEFAULT_COLOR_LIST as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_COLOR_DROP as GUI_element_colors_type, GUI_DEFAULT_COLOR_CHECKBOX as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_COLOR_MENU as GUI_element_colors_type, GUI_DEFAULT_COLOR_BUTTON as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_COLOR_RADIO as GUI_element_colors_type, GUI_DEFAULT_COLOR_LABEL as GUI_element_colors_type

'Default colors for dialogs
COMMON SHARED GUI_DEFAULT_DIALOG_COLOR_BOX as GUI_element_colors_type, GUI_DEFAULT_DIALOG_COLOR_INPUT as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_DIALOG_COLOR_TEXT as GUI_element_colors_type, GUI_DEFAULT_DIALOG_COLOR_LIST as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_DIALOG_COLOR_DROP as GUI_element_colors_type, GUI_DEFAULT_DIALOG_COLOR_CHECKBOX as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_DIALOG_COLOR_MENU as GUI_element_colors_type, GUI_DEFAULT_DIALOG_COLOR_BUTTON as GUI_element_colors_type
COMMON SHARED GUI_DEFAULT_DIALOG_COLOR_RADIO as GUI_element_colors_type, GUI_DEFAULT_DIALOG_COLOR_LABEL as GUI_element_colors_type
COMMON SHARED GUI_MOUSE_QUEUE$

DIM SHARED GUI_alt_codes$(51) ' thanks to Galleon for alt-code stuff
