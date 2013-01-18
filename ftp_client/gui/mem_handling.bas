FUNCTION get_str$ (s AS string_type)
$CHECKING:OFF
IF s.is_allocated <> 0 AND s.length > 0 THEN
  FOR x = 1 TO s.length
    get_s$ = get_s$ + _MEMGET(s.mem, s.mem.OFFSET + x - 1, STRING * 1)
  NEXT x
END IF
get_str$ = get_s$
$CHECKING:ON
END FUNCTION

SUB put_str (s AS string_type, stri$)
$CHECKING:OFF
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
DIM s AS string_type, m AS _MEM
$CHECKING:OFF
m = _MEM(s)
_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(string_type), LEN(string_type) TO m, m.OFFSET
$CHECKING:ON
get_str_array$ = get_str$(s)
END FUNCTION

SUB get_str_type_array (a AS array_type, array_number, st AS string_type)
DIM m AS _MEM
$CHECKING:OFF
m = _MEM(st)
_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(string_type), LEN(string_type) TO m, m.OFFSET
$CHECKING:ON
END SUB

SUB put_str_array (a AS array_type, array_number, s AS string_type)
$CHECKING:OFF
_MEMCOPY s.mem, s.mem.OFFSET, LEN(string_type) TO a.mem, a.mem.OFFSET + array_number * LEN(string_type)
$CHECKING:ON
END SUB

SUB get_filedir_type_array (a AS array_type, array_number, f AS filedir_type)
DIM m AS _MEM
$CHECKING:OFF
m = _MEM(f)
_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(filedir_type), LEN(filedir_type) TO m, m.OFFSET
$CHECKING:ON
END SUB

SUB put_filedir_type_array (a AS array_type, array_number, f AS filedir_type)
DIM m AS _MEM
$CHECKING:OFF
m = _MEM(f)
_MEMCOPY m, m.OFFSET, LEN(filedir_type) TO a.mem, a.mem.OFFSET + array_number * LEN(filedir_type)
$CHECKING:ON
END SUB

FUNCTION get_file_name$ (a AS array_type, array_number)
'If array of filedir, fast way to get filename info
DIM f AS filedir_type, m AS _MEM
$CHECKING:OFF
m = _MEM(f)
_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(filedir_type), LEN(filedir_type) TO m, m.OFFSET
get_file_name$ = get_str$(f.nam)
$CHECKING:ON
END FUNCTION

FUNCTION get_retr (a AS array_type, array_number)
DIM f AS filedir_type, m AS _MEM
$CHECKING:OFF
m = _MEM(f)
_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(filedir_type), LEN(filedir_type) TO m, m.OFFSET
get_retr = f.flag_retr
$CHECKING:ON
END FUNCTION

FUNCTION get_cwd (a AS array_type, array_number)
DIM f AS filedir_type, m AS _MEM
$CHECKING:OFF
m = _MEM(f)
_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(filedir_type), LEN(filedir_type) TO m, m.OFFSET
get_cwd = f.flag_cwd
$CHECKING:ON
END FUNCTION

FUNCTION get_dir$ (a AS array_type, array_number)
DIM f AS filedir_type, m AS _MEM
$CHECKING:OFF
m = _MEM(f)
_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(filedir_type), LEN(filedir_type) TO m, m.OFFSET
get_dir$ = f.dir
$CHECKING:ON
END FUNCTION

SUB allocate_array (a AS array_type, number_of_elements, element_size)
$CHECKING:OFF
IF NOT a.is_allocated THEN
  'not already allocated
ELSE
  a.element_size = element_size
  a.length = number_of_elements
  a.is_allocated = -1
  a.allocated = number_of_elements * element_size
  a.mem = _MEMNEW(number_of_elements * element_size)
END IF
$CHECKING:ON

END SUB

SUB reallocate_array (a AS array_type, number_of_elements)

DIM temp AS _MEM
$CHECKING:OFF
IF NOT a.is_allocated THEN
  IF a.element_size > 0 THEN allocate_array a, number_of_elements, a.element_size ELSE ERROR 255
ELSE 'reallocate
  IF number_of_elements * a.element_size < a.allocated THEN a.length = number_of_elements: EXIT SUB
  temp = a.mem
  a.mem = _MEMNEW(number_of_elements * a.element_size)
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
$CHECKING:OFF
if a.is_allocated then
  _MEMFREE a.mem
  a.is_allocated = 0
  a.allocated = 0
end if
$CHECKING:ON
END SUB

SUB free_string (s as string_type)
$CHECKING:OFF
if s.is_allocated then
  _memfree s.mem
  s.is_allocated = 0
  s.allocated = 0
end if
$CHECKING:on
END SUB
