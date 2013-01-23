'FTP Client
'Copyright Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.
TYPE GUI_menu_item_type
  nam as string_type
  'support will be added later
  'modifier as STRING * 2 'INKEY$ return
  sub_menu as _MEM 'mem pointing to a menu_type
END TYPE

TYPE GUI_menu_type
  items as array_type 'array of menu_items
  wid as INTEGER 'width of this menu -- if 0 then will be determined automatically based on items
END TYPE

CONST GUI_BOX = 1
CONST GUI_INPUT_BOX = 2
CONST GUI_TEXT_BOX = 3
CONST GUI_LIST_BOX = 4
CONST GUI_DROP_DOWN = 5
CONST GUI_CHECKBOX = 6
CONST GUI_MENU = 7
CONST GUI_BUTTON = 8

TYPE GUI_element_type
  nam AS string_type 'name of item

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
  
  ' V -- not implemented just yet
  ' -- Radio Buttons?
  ' -- Combo Box

  row1 AS INTEGER 'location
  col1 AS INTEGER
  row2 AS INTEGER
  col2 AS INTEGER

  c1 AS _BYTE 'forcolor
  c2 AS _BYTE 'backcolor

  sc1 AS _BYTE 'selected color (Has a few different meanings depending on the object)
  sc2 AS _BYTE
  
  ' Just a number indicating the layering.
  ' Lowest later is 0. If you need something to be ontop of something else, put it in a higher layer
  layer AS _UNSIGNED _BYTE 
  
  skip AS _BYTE ' if -1 then will be skipped by TAB key
  
  shadow AS _BYTE ' if -1 then a shadow will be drawn around the box
  
  pressed AS _BYTE ' set if button pressed -- needs to be reset if you intend to do something else


  'text_box AS _BYTE '-1 then drawn as textbox (input box) -- always as row2 = row1 + 2
  
  text AS string_type 'text drawn/edited in a Input-Box
  text_position AS INTEGER 'position of the cursor in the input
  text_offset AS INTEGER 'We display the string in the box starting at the text_offset character, to account for scrolling to the right
  hide AS _BYTE 'text will be drawn as "****" instead of "test" -- use for passwords, etc.

  scroll AS _BYTE ' If set then scroll bar(s) are drawn
  'scroll = 0 -- no scroll bars
  'scroll = 1 -- Vertical scroll bar only
  'scroll = 2 -- Horisontal scroll bar only
  'scroll = 3 -- Vertical and Horisontal scroll bars
  scroll_offset_vert AS INTEGER 'current scroll offset -- calculated in draw_gui function
  scroll_offset_hors AS INTEGER
  scroll_loc_hors AS INTEGER 'current location of scroll-bar
  scroll_loc_vert AS INTEGER
  scroll_max_hors AS INTEGER 'Max number of characters in a line -- If 0 then will be automatically calculated (Which is a bit slower)
  'The length variable is used in place of a "scroll_max_vert" variable
  
  length AS INTEGER ' Length of string array
  selected AS INTEGER 'selected line in list-box, drop-down, etc.
  
  lines AS array_type ' Array to store strings for list-box, drop-down, etc.
  
  checked AS _BYTE 'If set then the check-box is checked
  
  drop_flag AS _BYTE ' If drop_flag is set, then the drop-down box is showing
  
  'Updated only applies to selected gui element, to ease the ease of checking.
  'You can assume that unless you change the values directly, no other gui's accept the selected gui
  'will be changed.
  updated AS _BYTE 'If this is set, it indicates screen should be redrawn to reflect a change in this object

  cur_row AS INTEGER
  cur_col AS INTEGER
  'If this GUI is currently selected, then you should do a:
  'LOCATE cur_row, cur_col, 1
  'to locate the cursor
END TYPE

'shared variables for mouse
COMMON SHARED GUI_mx AS INTEGER, GUI_my AS INTEGER, GUI_but AS INTEGER, GUI_mtimer AS SINGLE, GUI_mscroll AS INTEGER
COMMON SHARED GUI_cur_row AS INTEGER, GUI_cur_col AS INTEGER
