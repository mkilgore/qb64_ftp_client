'FTP Client
'Copyright Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.
TYPE menu_items
  nam as string_type
  'support will be added later
  'modifier as STRING * 2 'INKEY$ return
  sub_menus as _MEM 'mem pointing to a menu_type
END TYPE

TYPE menu_type
  items as array_type 'array of menu_items
  wid as INTEGER 'width of this menu -- if 0 then will be determined automatically based on items
END TYPE

TYPE box_type
  nam AS string_type

  row1 AS INTEGER 'location
  col1 AS INTEGER
  row2 AS INTEGER 'row2 not used for button/checkbox. for drop_down, it represents the number of rows in the selection box
  col2 AS INTEGER

  c1 AS _BYTE 'forcolor
  c2 AS _BYTE 'backcolor

  sc1 AS _BYTE 'selected color. -- not always used
  sc2 AS _BYTE

  text_box AS _BYTE '-1 then drawn as textbox (input box) -- always as row2 = row1 + 2
  text AS string_type 'text drawn inside the textbox
  text_position AS INTEGER 'position of the cursor
  text_offset AS INTEGER 'We display the string in the box starting at the text_offset character, to account for scrolling to the right
  hide AS _BYTE 'text will be drawn as "****" instead of "test"

  scroll AS _BYTE 'if -1 then scroll is drawn
  scroll_loc AS INTEGER 'various numbers needed to draw scroll

  multi_text_box AS _BYTE '-1 then drawn as a multiple line text-box (Not editable)
  selected AS INTEGER 'the line that is selected (Will be drawn in sc1,sc2

  length AS INTEGER 'number of options (now use multi_line.length

  offset AS INTEGER 'offset from the beginning that we will draw from
  shadow AS _BYTE 'if -1 then a shadow is drawn around the box

  button AS _BYTE 'if -1 then drawn as button.

  checkbox AS _BYTE 'if -1 then drawn as checkbox
  checked AS _BYTE 'represents checkbox state

  drop_down AS _BYTE 'drawn as drop_down.
  d_flag AS _BYTE 'if d_flag then dropdown box is drawn

  drop_row2 AS INTEGER 'bottom location of dropdown box
  
  menu as _byte
  

  updated AS INTEGER 'if set, then information about this box has been updated

  multi_line AS array_type 'string array for multi-line text boxes
END TYPE

'shared variables for mouse
COMMON SHARED mx AS INTEGER, my AS INTEGER, but, mtimer AS SINGLE, mscroll AS SINGLE
