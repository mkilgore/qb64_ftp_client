'MEM Library
'Copyright Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

'CONST MEM_MEM_FOR_SIZEOF AS _MEM

!!if not defined __MEM_LIBRARY_MEM_LIB_BI__
!!define __MEM_LIBRARY_MEM_LIB_BI__

DECLARE CUSTOMTYPE LIBRARY
  FUNCTION MEM_MALLOC%& ALIAS malloc (BYVAL bytes as LONG)
  FUNCTION MEM_REALLOC%& ALIAS realloc (BYVAL src as _OFFSET, BYVAL size as LONG)
  SUB MEM_FREE ALIAS free (BYVAL off as _OFFSET)
  SUB MEM_MEMCPY ALIAS memcpy (BYVAL dest as _OFFSET, BYVAL src as _OFFSET, BYVAL bytes as LONG)
  SUB MEM_MEMSET ALIAS memset (BYVAL dest as _OFFSET, BYVAL value as LONG, BYVAL bytes as LONG)
  SUB MEM_MEMMOVE ALIAS memmove (BYVAL dest as _OFFSET, BYVAL src AS _OFFSET, BYVAL bytes AS LONG)
END DECLARE

CONST MEM_SIZEOF_OFFSET = 4
CONST MEM_SIZEOF_MEM = 28

CONST MEM_SIZEOF_MEM_STRING = MEM_SIZEOF_OFFSET + 4 + 4 + 1
TYPE MEM_string
  mem AS _OFFSET
  length AS LONG
  allocated AS LONG
  is_allocated AS _BYTE
END TYPE

CONST MEM_SIZEOF_MEM_ARRAY = MEM_SIZEOF_OFFSET + 4 + 4 + 1 + 2
TYPE MEM_array
  mem AS _OFFSET
  length AS LONG
  allocated AS LONG
  is_allocated AS _BYTE
  element_size AS INTEGER
END TYPE

DIM SHARED MEM_FAKEMEM AS _MEM

!!endif
