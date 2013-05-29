
$SCREENHIDE
$CONSOLE

CONST PRE_PROCESS_VERSION$ = ".10"

DIM SHARED MEM_FAKEMEM AS _MEM

DECLARE CUSTOMTYPE LIBRARY
  FUNCTION MEM_MALLOC%& alias malloc (BYVAL bytes as LONG)
  FUNCTION MEM_REALLOC%& ALIAS realloc (BYVAL src as _OFFSET, BYVAL size as LONG)
  SUB MEM_FREE ALIAS free (BYVAL off as _OFFSET)
  SUB MEM_MEMCPY ALIAS memcpy (BYVAL dest as _OFFSET, BYVAL src as _OFFSET, BYVAL bytes as LONG)
  SUB MEM_MEMSET ALIAS memset (BYVAL dest as _OFFSET, BYVAL value as LONG, BYVAL bytes as LONG)
  SUB MEM_MEMMOVE ALIAS memmove (BYVAL dest as _OFFSET, BYVAL src AS _OFFSET, BYVAL bytes AS LONG)
END DECLARE

TYPE MEM_String
  mem as _OFFSET
  length AS LONG
  allocated AS LONG
  is_allocated AS _BYTE
END TYPE

TYPE MEM_Array
  mem AS _OFFSET
  length AS LONG
  allocated AS LONG
  is_allocatd AS _BYTE
  element_size AS INTEGER
END TYPE

DECLARE LIBRARY "unistd"
  SUB getcwd(s as STRING, BYVAL l as LONG)
END DECLARE

CONST BYTE_TYPE = 1
CONST INTEGER_TYPE = 2
CONST LONG_TYPE = 3
CONST SINGLE_TYPE = 4
CONST DOUBLE_TYPE = 5
CONST INTEGER64_TYPE = 6
CONST STRING_TYPE = 8
CONST OFFSET_TYPE = 9
CONST FLOAT_TYPE = 10

CONST MAKE_TYPE   = &H0000000007F
CONST IS_UNSIGNED = &H00000000080 
CONST IS_UDT      = &H000000FFF00
CONST MAKE_UDT    = &H00000000100
CONST STRING_SIZE = &HFFFFFF00000
CONST MAKE_STRING = &H00000100000


TYPE FILE_Data
  dat AS MEM_Array
END TYPE

TYPE source_line
  l AS MEM_String
END TYPE

TYPE const_type
  nam   AS MEM_String
  value AS MEM_String
END TYPE

TYPE main_type_node
  type_nam        AS MEM_String
  first_type_node AS _OFFSET
  members         AS LONG
  full_size       AS LONG
END TYPE

TYPE sub_type_node
  member_nam     AS MEM_String
  next_node      AS _OFFSET
  size           AS LONG
  size_to_member AS LONG
END TYPE

TYPE SUB_FUNC
  subfunc AS LONG
  nam     AS MEM_String
  typ     AS LONG
  source  AS MEM_String
END TYPE

TYPE OBJECT
  nam      AS MEM_String
  abstract AS LONG
  traits   AS MEM_Array
  inherit  AS LONG
  flags    AS MEM_Array
  public   AS MEM_Array
  private  AS MEM_Array
END TYPE

TYPE trait
  nam as MEM_String
END TYPE

TYPE declare_library
  lib       AS MEM_String
  sub_funcs AS MEM_Array
END TYPE

TYPE SOURCE_copy
  consts      AS MEM_Array 'Array of const_type
  main_source AS MEM_Array 'Array of source_line
  types       AS MEM_Array 'Array of main_type_node
  SUB_func    AS MEM_Array 'Array of SUB_FUNC
  Objects     AS MEM_Array 'Array of OBJECT
  Traits      AS MEM_Array 'Array of TRAIT
  libs        AS MEM_Array 'Array of declare_library
  header      AS MEM_Array 'Array of MEM_Strings
END TYPE

DIM SHARED QB64_SOURCE_FILE$
DIM SHARED orig_source AS SOURCE_Copy
REDIM SHARED source$()

'Beginning of program
handle_command COMMAND$



pre_process QB64_SOURCE_FILE$, source$()

init_source orig_source
load_source source$(), orig_source

handle_objects orig_source

handle_at_commands orig_source



SUB handle_command (c$)
  
END SUB

SUB pre_process (file$, source$())

END SUB

SUB init_source (src AS SOURCE_copy)

END SUB

SUB load_source (source$(), src AS SOURCE_copy)

END SUB

SUB handle_objects (src AS SOURCE_copy)

END SUB

SUB handle_at_commands (src AS SOURCE_copy)

END SUB


FUNCTION MEM_get_str$ (s AS MEM_string)
$CHECKING:OFF
IF s.is_allocated <> 0 AND s.length > 0 THEN
  get_s$ = space$(s.length)
  MEM_MEMCPY _OFFSET(get_s$), s.mem, s.length
  'FOR x = 1 TO s.length
  '  get_s$ = get_s$ + _MEMGET(MEM_FAKEMEM, s.mem + x - 1, STRING * 1)
  'NEXT x
END IF
MEM_get_str$ = get_s$
$CHECKING:ON
END FUNCTION

SUB MEM_put_str (s AS MEM_string, stri$)
$CHECKING:OFF
IF NOT s.is_allocated OR s.allocated < LEN(stri$) THEN
  IF s.is_allocated THEN MEM_FREE s.mem '_MEMFREE s.mem
  's.mem = _MEMNEW(LEN(stri$) + 10) 'allocate 10 extra bytes
  s.mem = MEM_MALLOC%&(LEN(stri$) + 10)
  s.allocated = LEN(stri$) + 10
  s.is_allocated = -1
END IF
'_MEMPUT s.mem, s.mem.OFFSET, stri$
MEM_MEMCPY s.mem, _OFFSET(stri$), len(stri$)
s.length = LEN(stri$)
$CHECKING:ON
END SUB

FUNCTION MEM_get_str_array$ (a AS MEM_array, array_number)
DIM s AS MEM_string
$CHECKING:OFF
'_MEMGET MEM_FAKEMEM, a.mem + array_number * MEM_SIZEOF_MEM_STRING, s
MEM_MEMCPY _OFFSET(s), a.mem + array_number * MEM_SIZEOF_MEM_STRING, MEM_SIZEOF_MEM_STRING
'_MEMCOPY a.mem, a.mem.OFFSET + array_number * LEN(string_type), LEN(string_type) TO m, m.OFFSET
$CHECKING:ON

MEM_get_str_array$ = MEM_get_str$(s)
END FUNCTION

SUB MEM_put_str_array (a AS MEM_array, array_number, s$)
$CHECKING:OFF
DIM st as MEM_string
'_MEMGET MEM_FAKEMEM, a.mem + array_number * MEM_SIZEOF_MEM_STRING, st
MEM_MEMCPY _OFFSET(st), a.mem + array_number * MEM_SIZEOF_MEM_STRING, MEM_SIZEOF_MEM_STRING
MEM_put_str st, s$
MEM_MEMCPY a.mem + array_number * MEM_SIZEOF_MEM_STRING, _OFFSET(st), MEM_SIZEOF_MEM_STRING
'_MEMPUT a.mem, a.mem.OFFSET + array_number * MEM_SIZEOF_MEM_STRING, st

$CHECKING:ON
END SUB

SUB MEM_allocate_array (a AS MEM_array, number_of_elements, element_size)
$CHECKING:OFF
IF NOT a.is_allocated THEN
  'not already allocated
  a.element_size = element_size
  a.length = number_of_elements 'add one to make it go from 0 to number_of_elements as BASIC programers would expect
  a.is_allocated = -1
  a.allocated = (a.length + 1) * element_size
  'a.mem = _MEMNEW((a.length + 1) * element_size)
  a.mem = MEM_MALLOC%&((a.length + 1) * element_size)
  MEM_MEMSET a.mem, 0, (a.length + 1) * element_size
  
  '_MEMFILL a.mem, a.mem.OFFSET, (a.length + 1) * element_size, 0 as _byte
elseif a.element_size = element_size then
  MEM_reallocate_array a, number_of_elements
END IF
$CHECKING:ON

END SUB

SUB MEM_reallocate_array (a AS MEM_array, number_of_elements)

DIM temp AS _OFFSET
$CHECKING:OFF
IF NOT a.is_allocated THEN
  IF a.element_size > 0 THEN MEM_allocate_array a, number_of_elements, a.element_size ELSE ERROR 255
ELSE 'reallocate
  a.length = number_of_elements + 1:
  IF (number_of_elements + 1) * a.element_size < a.allocated THEN EXIT SUB
  temp = a.mem
  'a.mem = _MEMNEW((number_of_elements + 1) * a.element_size)
  a.mem = MEM_MALLOC%&((number_of_elements + 1) * a.element_size)
  
  MEM_MEMSET a.mem, 0, (number_of_elements + 1) * a.element_size
  '_MEMFILL a.mem, a.mem.OFFSET, (number_of_elements + 1) * a.element_Size, 0 as _BYTE
  MEM_MEMCPY a.mem, temp, a.allocated
  '_MEMCOPY temp, temp.OFFSET, a.allocated TO a.mem, a.mem.OFFSET
  s.allocated = (number_of_elements + 1) * a.element_size
  MEM_FREE temp
END IF

$CHECKING:ON
END SUB

SUB MEM_allocate_string_array (a as MEM_array, number_of_elements)
'DIM s as MEM_string
MEM_allocate_array a, number_of_elements, MEM_SIZEOF_MEM_STRING
END SUB

SUB MEM_free_string_array (a as MEM_array)
DIM s as MEM_string
$CHECKING:OFF
if a.is_allocated then
  FOR x = 1 to a.length 'Free each individual string
    's = _MEMGET(a.mem, a.mem.OFFSET + MEM_SIZEOF_MEM_STRING * (x - 1), MEM_string)
    MEM_MEMCPY _OFFSET(s), a.mem + MEM_SIZEOF_MEM_STRING * (x - 1), MEM_SIZEOF_MEM_STRING
    MEM_free_string s
  next x
  '_MEMFREE a.mem
  MEM_FREE a.mem
  a.is_allocated = 0
  a.allocated = 0
end if
$CHECKING:ON
END SUB

SUB MEM_free_array (a as MEM_array)
$CHECKING:OFF
if a.is_allocated then
  '_MEMFREE a.mem
  MEM_FREE a.mem
  a.is_allocated = 0
  a.allocated = 0
end if
$CHECKING:ON
END SUB

SUB MEM_free_string (s as MEM_string)
$CHECKING:OFF
if s.is_allocated then
  '_memfree s.mem
  MEM_FREE s.mem
  s.is_allocated = 0
  s.allocated = 0
end if
$CHECKING:on
END SUB

FUNCTION MEM_int_from_off% (o as _OFFSET)
$checking:off
DIM i as INTEGER
MEM_MEMCPY _OFFSET(i), o, LEN(i)
MEM_int_from_off% = i
$checking:on
END FUNCTION

FUNCTION MEM_long_from_off& (o as _OFFSET)
$checking:off
DIM l as LONG
MEM_MEMCPY _OFFSET(l), o, 4 'LEN(l)
MEM_long_from_off& = l
$checking:on
END FUNCTION

FUNCTION MEM_byte_from_off%% (o as _OFFSET)
$checking:off
DIM b as _byte
MEM_MEMCPY _OFFSET(b), o, LEN(b)
MEM_byte_from_off%% = b
$checking:on
END FUNCTION

FUNCTION MEM_int64_from_off&& (o as _OFFSET)
$checking:off
DIM i as _INTEGER64
MEM_MEMCPY _OFFSET(i), o, LEN(i)
MEM_ini64_from_off&& = i
$checking:on
END FUNCTION

FUNCTION MEM_MALLOC0%& (bytes as LONG)
$CHECKING:OFF
DIM o as _OFFSET
o = MEM_MALLOC%&(bytes)
MEM_MEMSET o, 0, bytes
$CHECKING:ON
END FUNCTION

