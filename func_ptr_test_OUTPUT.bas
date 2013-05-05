DIM SHARED GUI__QB64__EMPTY_MEM AS _MEM











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

CONST GUI__QB64__SUB_FUNC_1 = 1
CONST GUI__QB64__SUB_FUNC_2 = 2

TYPE GUI_Object
  
  f AS _UNSIGNED LONG
  fun AS _OFFSET
  
END TYPE

DIM o as _OFFSET

o = GUI_Object_new%&

$CHECKING:OFF
CALL__OFFSET  _MEMGET(GUI__QB64__EMPTY_MEM, O + _OFFSET(GUI_OBJECT.FUN, TYPE), _OFFSET) , O
$CHECKING:ON



GUI_attach_func o, FUNC_2_ptr%&



$CHECKING:OFF
CALL__OFFSET  _MEMGET(GUI__QB64__EMPTY_MEM, O + _OFFSET(GUI_OBJECT.FUN, TYPE), _OFFSET) , O
$CHECKING:ON









FUNCTION GUI_Object_new%& ()
DIM o as _OFFSET
o = MEM_MALLOC%&(LEN(GUI_Object, TYPE))

GUI_attach_func o, FUNC_1_ptr%&
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, O+ _OFFSET(GUI_OBJECT.F, TYPE),  2 AS LONG
$CHECKING:ON
GUI_Object_new%& = o

END FUNCTION

SUB GUI_attach_func (this as _OFFSET, f as _OFFSET)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_OBJECT.FUN, TYPE),  F
$CHECKING:ON

END SUB



SUB FUNC_1 (this as _OFFSET)
$CHECKING:OFF
PRINT _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_OBJECT.F, TYPE), LONG) 
$CHECKING:ON

END SUB

SUB FUNC_2 (this as _OFFSET)
$CHECKING:OFF
PRINT _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_OBJECT.F, TYPE), LONG)  * 4
$CHECKING:ON

END SUB




















FUNCTION MEM_get_str$ (s AS MEM_string)
$CHECKING:OFF
IF s.is_allocated <> 0 AND s.length > 0 THEN
  get_s$ = space$(s.length)
  MEM_MEMCPY _OFFSET(get_s$), s.mem, s.length
  
  
  
END IF
MEM_get_str$ = get_s$
$CHECKING:ON

END FUNCTION

SUB MEM_put_str (s AS MEM_string, stri$)
$CHECKING:OFF
IF NOT s.is_allocated OR s.allocated < LEN(stri$) THEN
  IF s.is_allocated THEN MEM_FREE s.mem 
  
  s.mem = MEM_MALLOC%&(LEN(stri$) + 10)
  s.allocated = LEN(stri$) + 10
  s.is_allocated = -1
END IF

MEM_MEMCPY s.mem, _OFFSET(stri$), len(stri$)
s.length = LEN(stri$)
$CHECKING:ON

END SUB

FUNCTION MEM_get_str_array$ (a AS MEM_array, array_number)
DIM s AS MEM_string
$CHECKING:OFF

MEM_MEMCPY _OFFSET(s), a.mem + array_number * MEM_SIZEOF_MEM_STRING, MEM_SIZEOF_MEM_STRING

$CHECKING:ON

MEM_get_str_array$ = MEM_get_str$(s)

END FUNCTION

SUB MEM_put_str_array (a AS MEM_array, array_number, s$)
$CHECKING:OFF
DIM st as MEM_string

MEM_MEMCPY _OFFSET(st), a.mem + array_number * MEM_SIZEOF_MEM_STRING, MEM_SIZEOF_MEM_STRING
MEM_put_str st, s$
MEM_MEMCPY a.mem + array_number * MEM_SIZEOF_MEM_STRING, _OFFSET(st), MEM_SIZEOF_MEM_STRING


$CHECKING:ON

END SUB









SUB MEM_allocate_array (a AS MEM_array, number_of_elements, element_size)
$CHECKING:OFF
IF NOT a.is_allocated THEN
  
  a.element_size = element_size
  a.length = number_of_elements 
  a.is_allocated = -1
  a.allocated = (a.length + 1) * element_size
  
  a.mem = MEM_MALLOC%&((a.length + 1) * element_size)
  MEM_MEMSET a.mem, 0, (a.length + 1) * element_size
  
  
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
ELSE 
  a.length = number_of_elements + 1:
  IF (number_of_elements + 1) * a.element_size < a.allocated THEN EXIT SUB
  temp = a.mem
  
  a.mem = MEM_MALLOC%&((number_of_elements + 1) * a.element_size)
  
  MEM_MEMSET a.mem, 0, (number_of_elements + 1) * a.element_size
  
  MEM_MEMCPY a.mem, temp, a.allocated
  
  s.allocated = (number_of_elements + 1) * a.element_size
  MEM_FREE temp
END IF

$CHECKING:ON

END SUB

SUB MEM_allocate_string_array (a as MEM_array, number_of_elements)

MEM_allocate_array a, number_of_elements, MEM_SIZEOF_MEM_STRING

END SUB

SUB MEM_free_string_array (a as MEM_array)
DIM s as MEM_string
$CHECKING:OFF
if a.is_allocated then
  FOR x = 1 to a.length 
    
    MEM_MEMCPY _OFFSET(s), a.mem + MEM_SIZEOF_MEM_STRING * (x - 1), MEM_SIZEOF_MEM_STRING
    MEM_free_string s
  next x
  
  MEM_FREE a.mem
  a.is_allocated = 0
  a.allocated = 0
end if
$CHECKING:ON

END SUB

SUB MEM_free_array (a as MEM_array)
$CHECKING:OFF
if a.is_allocated then
  
  MEM_FREE a.mem
  a.is_allocated = 0
  a.allocated = 0
end if
$CHECKING:ON

END SUB

SUB MEM_free_string (s as MEM_string)
$CHECKING:OFF
if s.is_allocated then
  
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
MEM_MEMCPY _OFFSET(l), o, LEN(l)
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

DECLARE CUSTOMTYPE LIBRARY "func_ptr_test_OUTPUT"
  FUNCTION MEM_FREE_ptr%& ()
  FUNCTION MEM_MEMCPY_ptr%& ()
  FUNCTION MEM_MEMSET_ptr%& ()
  FUNCTION MEM_MEMMOVE_ptr%& ()
  FUNCTION GUI_ATTACH_FUNC_ptr%& ()
  FUNCTION FUNC_1_ptr%& ()
  FUNCTION FUNC_2_ptr%& ()
  FUNCTION MEM_PUT_STR_ptr%& ()
  FUNCTION MEM_PUT_STR_ARRAY_ptr%& ()
  FUNCTION MEM_ALLOCATE_ARRAY_ptr%& ()
  FUNCTION MEM_REALLOCATE_ARRAY_ptr%& ()
  FUNCTION MEM_ALLOCATE_STRING_ARRAY_ptr%& ()
  FUNCTION MEM_FREE_STRING_ARRAY_ptr%& ()
  FUNCTION MEM_FREE_ARRAY_ptr%& ()
  FUNCTION MEM_FREE_STRING_ptr%& ()
  SUB call__OFFSET( BYVAL va AS _OFFSET, A AS _OFFSET)
  SUB call__OFFSET__OFFSET_LONG( BYVAL va AS _OFFSET, A AS _OFFSET, B AS _OFFSET, C AS LONG)
  SUB call__OFFSET_LONG_LONG( BYVAL va AS _OFFSET, A AS _OFFSET, B AS LONG, C AS LONG)
  SUB call__OFFSET__OFFSET( BYVAL va AS _OFFSET, A AS _OFFSET, B AS _OFFSET)
  SUB call_MEM_STRING_STRING( BYVAL va AS _OFFSET, A AS MEM_STRING, B AS STRING)
  SUB call_MEM_ARRAY_SINGLE_STRING( BYVAL va AS _OFFSET, A AS MEM_ARRAY, B AS SINGLE, C AS STRING)
  SUB call_MEM_ARRAY_SINGLE_SINGLE( BYVAL va AS _OFFSET, A AS MEM_ARRAY, B AS SINGLE, C AS SINGLE)
  SUB call_MEM_ARRAY_SINGLE( BYVAL va AS _OFFSET, A AS MEM_ARRAY, B AS SINGLE)
  SUB call_MEM_ARRAY( BYVAL va AS _OFFSET, A AS MEM_ARRAY)
  SUB call_MEM_STRING( BYVAL va AS _OFFSET, A AS MEM_STRING)
END DECLARE
