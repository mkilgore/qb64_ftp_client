'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

FUNCTION get_str$ (s AS string_type)
'$CHECKING:OFF
IF s.is_allocated <> 0 AND s.length > 0 THEN
  FOR x = 1 TO s.length
    get_s$ = get_s$ + _MEMGET(s.mem, s.mem.OFFSET + x - 1, STRING * 1)
  NEXT x
END IF
get_str$ = get_s$
$CHECKING:ON
END FUNCTION

SUB put_str (s AS string_type, stri$)
'$CHECKING:OFF
IF NOT s.is_allocated OR s.allocated < LEN(stri$) THEN
  IF s.is_allocated THEN _MEMFREE s.mem
  s.mem = _MEMNEW(LEN(stri$) + 10) 'allocate 10 extra bytes
  s.allocated = LEN(stri$) + 10
  s.is_allocated = -1
END IF
_MEMPUT s.mem, s.mem.OFFSET, stri$
s.length = LEN(stri$)
$CHECKING:ON
END SUB

SUB add_character (b AS box_type, ch$)
t$ = get_str$(b.text)
t$ = MID$(t$, 1, b.text_position) + ch$ + MID$(t$, b.text_position + 1)
'print "T="; t$;
'_DISPLAY
'sleep
put_str b.text, t$
b.text_position = b.text_position + 1
IF b.text_position > b.text_offset + (b.col2 - b.col1 - 2) THEN
  b.text_offset = b.text_offset + 1
END IF

END SUB

SUB del_character (b AS box_type)
t$ = get_str$(b.text)
IF LEN(t$) > 0 AND b.text_position > 0 THEN
  t$ = MID$(t$, 1, b.text_position - 1) + MID$(t$, b.text_position + 1)
  put_str b.text, t$
  b.text_position = b.text_position - 1
  IF b.text_position < b.text_offset THEN
    b.text_offset = b.text_offset - 1
  END IF
END IF
END SUB


FUNCTION get_str_array$ (a AS array_type, array_number)
DIM s AS string_type
'$CHECKING:OFF
_MEMGET a.mem, a.mem.OFFSET + array_number * LEN(s), s
'_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(string_type), LEN(string_type) TO m, m.OFFSET
$CHECKING:ON

get_str_array$ = get_str$(s)
END FUNCTION

'KEEP IN MIND, ST's _MEM value points to the same location as the array's one does
'USING ST RIGHT AFTER GETTING IT WILL CHANGE THE VALUE IN ARRAY
'MAKE A SAFE COPY OF ST FIRST IF YOU PLAN ON CHANGING IT WITHOUT CHANGING ARRAY VALUE
'Safe value's can be made by put_str temp_str, get_str$(st)
'Allocates a new string into temp_Str that you can use that is seperate from the array
SUB get_str_type_array (a AS array_type, array_number, st AS string_type)
DIM m AS _MEM
'$CHECKING:OFF
m = _MEM(st)
_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(st), LEN(st) TO m, m.OFFSET
$CHECKING:ON
END SUB

'SUB put_str_array (a AS array_type, array_number, s AS string_type)
''$CHECKING:OFF
'_MEMCOPY s.mem, s.mem.OFFSET, LEN(string_type) TO a.mem, a.mem.OFFSET + array_number * LEN(string_type)
''$CHECKING:ON
'END SUB

SUB put_str_array (a AS array_type, array_number, s$)
'$CHECKING:OFF
DIM st as string_type
_MEMGET a.mem, a.mem.OFFSET + array_number * LEN(st), st
put_str st, s$
_MEMPUT a.mem, a.mem.OFFSET + array_number * LEN(st), st

$CHECKING:ON
END SUB

SUB get_filedir_type_array (a AS array_type, array_number, f AS filedir_type)
DIM m AS _MEM
'$CHECKING:OFF
m = _MEM(f)
_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(f), LEN(f) TO m, m.OFFSET
$CHECKING:ON
END SUB

SUB allocate_array (a AS array_type, number_of_elements, element_size)
'$CHECKING:OFF
IF NOT a.is_allocated THEN
  'not already allocated
  a.element_size = element_size
  a.length = number_of_elements
  a.is_allocated = -1
  a.allocated = number_of_elements * element_size
  a.mem = _MEMNEW(number_of_elements * element_size)
  _MEMFILL a.mem, a.mem.OFFSET, number_of_elements * element_size, 0 as _byte
elseif a.element_size = element_size then
  reallocate_array a, number_of_elements
END IF
$CHECKING:ON

END SUB

SUB reallocate_array (a AS array_type, number_of_elements)

DIM temp AS _MEM
'$CHECKING:OFF
IF NOT a.is_allocated THEN
  IF a.element_size > 0 THEN allocate_array a, number_of_elements, a.element_size ELSE ERROR 255
ELSE 'reallocate
  IF number_of_elements * a.element_size < a.allocated THEN a.length = number_of_elements: EXIT SUB
  temp = a.mem
  a.mem = _MEMNEW(number_of_elements * a.element_size)
  _MEMFILL a.mem, a.mem.OFFSET, number_of_elements * a.element_Size, 0 as _BYTE
  _MEMCOPY temp, temp.OFFSET, a.allocated TO a.mem, a.mem.OFFSET
  
  s.allocated = number_of_elements * a.element_size
  
  _MEMFREE temp
END IF

$CHECKING:ON
END SUB

SUB free_gui_array (b() as box_type)
for x = 1 to ubound(b)
  free_gui_element b(x)
next x
END SUB

SUB free_gui_element (b as box_type)
free_string b.nam
free_string b.text
free_array b.multi_line
END SUB

SUB free_array (a as array_type)
'$CHECKING:OFF
if a.is_allocated then
  _MEMFREE a.mem
  a.is_allocated = 0
  a.allocated = 0
end if
$CHECKING:ON
END SUB

SUB free_string (s as string_type)
'$CHECKING:OFF
if s.is_allocated then
  _memfree s.mem
  s.is_allocated = 0
  s.allocated = 0
end if
$CHECKING:on
END SUB
