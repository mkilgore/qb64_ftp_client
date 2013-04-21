'MEM Library
'Copyright Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

'CONST MEM_MEM_FOR_SIZEOF AS _MEM

CONST MEM_SIZEOF_MEM = 28

CONST MEM_SIZEOF_MEM_STRING = MEM_SIZEOF_MEM + 4 + 4 + 1
TYPE MEM_string
  mem AS _MEM
  length AS LONG
  allocated AS LONG
  is_allocated AS _BYTE
END TYPE

CONST MEM_SIZEOF_MEM_ARRAY = MEM_SIZEOF_MEM + 4 + 4 + 1 + 2
TYPE MEM_array
  mem AS _MEM
  length AS LONG
  allocated AS LONG
  is_allocated AS _BYTE
  element_size AS INTEGER
END TYPE
