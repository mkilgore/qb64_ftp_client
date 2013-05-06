DIM SHARED GUI__QB64__EMPTY_MEM AS _MEM
CONST GUI_ELEMENT_FLAG_UPDATED = 1
CONST GUI_ELEMENT_FLAG_VISIBLE = 2
CONST GUI_ELEMENT_FLAG_ACTIVE = 4
CONST GUI_ELEMENT_FLAG_SKIP = 8
CONST GUI_ELEMENT_FLAG_INTERNAL = 16
CONST GUI_EVENT_KEY = 1
CONST GUI_EVENT_MOUSE = 2
CONST GUI_BUTTON = 1
CONST GUI_ELEMENT_BUTTON_FLAG_PRESSED = 1
CONST GUI_FRAME = 2
CONST GUI_ELEMENT_FRAME_FLAG_SHADOW = 1
CONST GUI_WINDOW = 3











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


CONST GUI_TRUE       = -1
CONST GUI_FALSE      = 0
CONST GUI_NULL       = 0
CONST GUI_IMAGE_NULL = -1

TYPE GUI_dimension
  row AS _UNSIGNED LONG 
  col as _UNSIGNED LONG
  wid AS _UNSIGNED LONG
  hei AS _UNSIGNED LONG
END TYPE

TYPE GUI_color
  f as _unsigned _byte
  b as _unsigned _byte
END TYPE



TYPE GUI_ref_object
  ref_count AS _UNSIGNED LONG
  delete AS _OFFSET 
END TYPE





TYPE GUI_signal_Object
  
  signal_name AS MEM_string
  first_connection AS _OFFSET 
  next_signal as _OFFSET 
END TYPE

TYPE GUI_signal_connection
  
  notify_proc AS _OFFSET
  id as _UNSIGNED LONG
  dat AS _OFFSET
  next_connection AS _OFFSET 
END TYPE

TYPE GUI_signal
  ref as GUI_ref_object
  next_id AS _UNSIGNED LONG
  first_signal as _OFFSET 
END TYPE





TYPE GUI_event
  obj as GUI_ref_object
  event_type AS _UNSIGNED LONG
  source as _OFFSET 
  modifiers AS _UNSIGNED LONG
END TYPE





TYPE GUI_Element
  s as GUI_signal
  dimension AS GUI_dimension
  flags AS _UNSIGNED LONG
ELEMENT_TYPE AS _UNSIGNED LONG
  img AS LONG 
  parent AS _OFFSET
  drw AS _OFFSET

END TYPE





TYPE GUI_event_key 
  e as GUI_event 
  key_code AS _UNSIGNED LONG  
  
  flags AS _UNSIGNED INTEGER
END TYPE





TYPE GUI_event_mouse 
  e as GUI_event
  
  
  row2 AS _UNSIGNED LONG 
  col2 AS _UNSIGNED LONG
  flags as INTEGER
  count as INTEGER
END TYPE







TYPE GUI_element_container
  ele as GUI_Element
  element AS _OFFSET
  flags as _UNSIGNED LONG
  
    
  
END TYPE























TYPE GUI_element_button_color
  sel as GUI_color
  normal as GUI_color
END TYPE


TYPE GUI_element_button
  ele as GUI_element_container
  text as MEM_string
  theme AS GUI_element_button_color
  flags AS _UNSIGNED LONG
END TYPE





TYPE GUI_element_frame
  ele as GUI_element_Container
  flags as _UNSIGNED LONG 
  nam as MEM_String
END TYPE





TYPE GUI_element_window
  ele AS GUI_element_Container
  focus as _UNSIGNED LONG
  flags AS _UNSIGNED LONG 
  title as MEM_String
  
END TYPE



DIM Win AS _OFFSET, button as _OFFSET, ele AS LONG, m as MEM_String, of as _OFFSET

Win = GUI_element_window_new_with_size_title%&(25, 80, "Hey!")

button = GUI_element_button_new_with_text%&("Hi!")
GUI_element_set_location button, 20, 15

GUI_element_container_add Win, button
GUI_element_show Win
GUI_element_window_set_as_screen win

GUI_signal_add_new_signal button, "pressed1"
GUI_signal_add_new_signal button, "pressed2"
GUI_signal_add_new_signal button, "pressed3"

of = _OFFSET(m)

handle_id = GUI_signal_connect&(button, "pressed1", TEST_SIGNAL1_ptr%&, of)




print handle_id

DO
  _LIMIT 60

  a$ = inkey$
  if a$ > "" then
    MEM_put_str m, a$
    GUI_signal_emit button, "pressed1"
  end if
LOOP until a$ = chr$(27)

SUB Test_signal1 (this as _OFFSET, dat as _OFFSET)
DIM m as MEM_String
MEM_MEMCPY _OFFSET(m), dat, LEN(MEM_String, TYPE)
print MEM_get_str$(m);

END SUB

SUB Test_signal2 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
if count = 0 then count = 1
count = count + 1

  LOCATE 3, 2
  print count


END SUB

SUB Test_signal3 (this as _OFFSET, dat as _OFFSET)
STATIC count AS _INTEGER64
if count = 0 then count = 1
count = count + 1

  LOCATE 4, 2
  print count


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
MEM_MEMCPY _OFFSET(l), o, 4 
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






SUB GUI_ref_object_init (this as _OFFSET)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_REF_OBJECT.REF_COUNT, TYPE),  0 AS LONG
$CHECKING:ON

END SUB

FUNCTION GUI_ref_Object_get_ref%& (this as _OFFSET)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_REF_OBJECT.REF_COUNT, TYPE),  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_REF_OBJECT.REF_COUNT, TYPE), LONG)  + 1 AS LONG
$CHECKING:ON
GUI_ref_Object_get_ref%& = this

END FUNCTION

SUB GUI_ref_Object_release_ref (this as _OFFSET)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_REF_OBJECT.REF_COUNT, TYPE),  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_REF_OBJECT.REF_COUNT, TYPE), LONG)  - 1 AS LONG
$CHECKING:ON
$CHECKING:OFF
IF _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_REF_OBJECT.REF_COUNT, TYPE), LONG)  = 0 THEN
$CHECKING:ON
$CHECKING:OFF
CALL__OFFSET  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_REF_OBJECT.DELETE, TYPE), _OFFSET) , THIS
$CHECKING:ON
end if

END SUB

SUB GUI_ref_Object_set_delete_proc (this as _OFFSET, pro AS _OFFSET)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_REF_OBJECT.DELETE, TYPE),  PRO
$CHECKING:ON

END SUB

SUB GUI_ref_Object_clear (this as _OFFSET)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_REF_OBJECT.REF_COUNT, TYPE),  0 AS LONG
$CHECKING:ON

END SUB

SUB GUI_ref_Object_delete (this as _OFFSET)
$CHECKING:OFF
CALL__OFFSET  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_REF_OBJECT.DELETE, TYPE), _OFFSET) , THIS
$CHECKING:ON

END SUB





SUB GUI_signal_init (this as _OFFSET)
GUI_ref_object_init this
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_SIGNAL.NEXT_ID, TYPE),  1 AS LONG
$CHECKING:ON

END SUB

SUB GUI_signal_clear (this as _OFFSET)
GUI_signal_clear_signals this
GUI_ref_object_clear this

END SUB

SUB GUI_signal_clear_signals (this as _OFFSET)


END SUB

SUB GUI_signal_disconnect (this as _OFFSET, n$, id as LONG)


END SUB

FUNCTION GUI_signal_connect& (this as _OFFSET, n$, pro as _OFFSET, dat as _OFFSET)
$CHECKING:OFF
DIM sig as _OFFSET, con as _OFFSET, m as MEM_string
DIM new_connect AS _offset
$CHECKING:OFF
SIG = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_SIGNAL.FIRST_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
DO while sig <> 0
$CHECKING:OFF
M = _MEMGET(GUI__QB64__EMPTY_MEM, SIG + _OFFSET(GUI_SIGNAL_OBJECT.SIGNAL_NAME, TYPE), MEM_STRING) 
$CHECKING:ON
  if MEM_get_str$(m) = n$ then

    new_connect = MEM_MALLOC%&(LEN(GUI_signal_connection, TYPE))
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, NEW_CONNECT+ _OFFSET(GUI_SIGNAL_CONNECTION.NOTIFY_PROC, TYPE),  PRO AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, NEW_CONNECT+ _OFFSET(GUI_SIGNAL_CONNECTION.ID, TYPE),  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_SIGNAL.NEXT_ID, TYPE), LONG)  AS LONG
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, NEW_CONNECT+ _OFFSET(GUI_SIGNAL_CONNECTION.DAT, TYPE),  DAT
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, NEW_CONNECT+ _OFFSET(GUI_SIGNAL_CONNECTION.NEXT_CONNECTION, TYPE),  _MEMGET(GUI__QB64__EMPTY_MEM, SIG + _OFFSET(GUI_SIGNAL_OBJECT.FIRST_CONNECTION, TYPE), _OFFSET)  AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, SIG+ _OFFSET(GUI_SIGNAL_OBJECT.FIRST_CONNECTION, TYPE),  NEW_CONNECT
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_SIGNAL.NEXT_ID, TYPE),  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_SIGNAL.NEXT_ID, TYPE), LONG)  + 1 AS LONG
$CHECKING:ON
$CHECKING:OFF
GUI_SIGNAL_CONNECT_PROC& = _MEMGET(GUI__QB64__EMPTY_MEM, NEW_CONNECT + _OFFSET(GUI_SIGNAL_CONNECTION.ID, TYPE), LONG) 
$CHECKING:ON
    exit function
  end if
$CHECKING:OFF
SIG = _MEMGET(GUI__QB64__EMPTY_MEM, SIG + _OFFSET(GUI_SIGNAL_OBJECT.NEXT_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
loop
$CHECKING:ON

END FUNCTION

SUB GUI_signal_add_new_signal (this as _OFFSET, n$)
DIM sig as _OFFSET, m as MEM_string, last as _OFFSET
sig = MEM_MALLOC%&(LEN(GUI_signal, TYPE))
MEM_put_str m, n$
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, SIG+ _OFFSET(GUI_SIGNAL_OBJECT.SIGNAL_NAME, TYPE),  M
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, SIG+ _OFFSET(GUI_SIGNAL_OBJECT.FIRST_CONNECTION, TYPE),  0 AS LONG
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, SIG+ _OFFSET(GUI_SIGNAL_OBJECT.NEXT_SIGNAL, TYPE),  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_SIGNAL.FIRST_SIGNAL, TYPE), _OFFSET)  AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_SIGNAL.FIRST_SIGNAL, TYPE),  SIG
$CHECKING:ON

END SUB

SUB GUI_signal_emit (this as _OFFSET, n$)
$CHECKING:OFF
DIM of as _OFFSET, m as MEM_string
DIM off2 AS _OFFSET, pro as _OFFSET
$CHECKING:OFF
OF = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_SIGNAL.FIRST_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
DO while of <> 0
$CHECKING:OFF
M = _MEMGET(GUI__QB64__EMPTY_MEM, OF + _OFFSET(GUI_SIGNAL_OBJECT.SIGNAL_NAME, TYPE), MEM_STRING) 
$CHECKING:ON
  if MEM_get_str$(m) = n$ then
    
$CHECKING:OFF
OFF2 = _MEMGET(GUI__QB64__EMPTY_MEM, OF + _OFFSET(GUI_SIGNAL_OBJECT.FIRST_CONNECTION, TYPE), _OFFSET) 
$CHECKING:ON
    DO WHILE off2 <> 0
$CHECKING:OFF
CALL__OFFSET__OFFSET  _MEMGET(GUI__QB64__EMPTY_MEM, OFF2 + _OFFSET(GUI_SIGNAL_CONNECTION.NOTIFY_PROC, TYPE), _OFFSET) , THIS, _MEMGET(GUI__QB64__EMPTY_MEM, OFF2 + _OFFSET(GUI_SIGNAL_CONNECTION.DAT, TYPE), _OFFSET) 
$CHECKING:ON
$CHECKING:OFF
OFF2 = _MEMGET(GUI__QB64__EMPTY_MEM, OFF2 + _OFFSET(GUI_SIGNAL_CONNECTION.NEXT_CONNECTION, TYPE), _OFFSET) 
$CHECKING:ON
    loop 
    EXIT SUB
  end if
$CHECKING:OFF
OF = _MEMGET(GUI__QB64__EMPTY_MEM, OF + _OFFSET(GUI_SIGNAL_OBJECT.NEXT_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
LOOP 
$CHECKING:ON


END SUB









SUB GUI_element_init (this as _OFFSET)
GUI_signal_init this
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.IMG, TYPE),  GUI_IMAGE_NULL AS LONG
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.PARENT, TYPE),  GUI_NULL AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DRW, TYPE),  GUI_NULL AS _OFFSET
$CHECKING:ON

END SUB

SUB GUI_element_clear (this as _OFFSET)
$CHECKING:OFF
IF _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG)  <> -1 THEN
$CHECKING:ON
$CHECKING:OFF
_FREEIMAGE _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG) 
$CHECKING:ON
end if
GUI_element_remove_parent this
GUI_signal_clear this

END SUB

FUNCTION GUI_element_get_element_type& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_GET_ELEMENT_TYPE& = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.ELEMENT_TYPE, TYPE), LONG) 
$CHECKING:ON

END FUNCTION

FUNCTION GUI_element_get_width& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_GET_WIDTH& = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.WID, TYPE), LONG) 
$CHECKING:ON

END FUNCTION

FUNCTION GUI_element_get_height& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_GET_HEIGHT& = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.HEI, TYPE), LONG) 
$CHECKING:ON

END FUNCTION

SUB GUI_element_show (this as _OFFSET)
GUI_element_FLAG_SET_VISIBLE this

END SUB

SUB GUI_element_hide (this as _OFFSET)
GUI_element_FLAG_UNSET_VISIBLE this

END SUB

SUB GUI_element_create_image (this as _OFFSET)
$CHECKING:OFF
IF _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG)  <> -1 THEN
$CHECKING:ON
$CHECKING:OFF
_FREEIMAGE _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG) 
$CHECKING:ON
end if
  
$CHECKING:OFF
I& = _NEWIMAGE(_MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.HEI, TYPE), LONG) , _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.WID, TYPE), LONG) , 0)
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.IMG, TYPE),  I&
$CHECKING:ON

END SUB

FUNCTION GUI_element_get_image& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_GET_IMAGE& = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG) 
$CHECKING:ON

END FUNCTION

SUB GUI_element_set_size (this AS _OFFSET, wid as _UNSIGNED LONG, hei AS _UNSIGNED LONG)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.WID, TYPE),  WID
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.HEI, TYPE),  HEI
$CHECKING:ON
GUI_element_create_image this

END SUB

SUB GUI_element_set_dimension_d (this AS _OFFSET, d as GUI_dimension)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION, TYPE),  D
$CHECKING:ON
GUI_element_create_image this

END SUB

SUB GUI_element_add_parent (this as _OFFSET, parent AS _OFFSET)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.PARENT, TYPE),  GUI_REF_OBJECT_GET_REF%&(PARENT) AS _OFFSET
$CHECKING:ON

END SUB

SUB GUI_element_remove_parent (this as _OFFSET)
$CHECKING:OFF
IF _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.PARENT, TYPE), _OFFSET)  <> 0 THEN
$CHECKING:ON
$CHECKING:OFF
GUI_REF_OBJECT_RELEASE_REF _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.PARENT, TYPE), _OFFSET) 
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.PARENT, TYPE),  0 AS _OFFSET
$CHECKING:ON
end if

END SUB

SUB GUI_element_set_draw_proc (this as _OFFSET, pro as _OFFSET)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DRW, TYPE),  PRO AS _OFFSET
$CHECKING:ON

END SUB


  SUB GUI_element_set_location (this as _OFFSET, row as _UNSIGNED LONG, col AS _UNSIGNED LONG)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.ROW, TYPE),  ROW
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.COL, TYPE),  COL
$CHECKING:ON

  END SUB
  
  SUB GUI_element_set_dimension (this AS _OFFSET, row as _UNSIGNED LONG, col as _UNSIGNED LONG, wid AS _UNSIGNED LONG, hei AS _UNSIGNED LONG)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.ROW, TYPE),  ROW
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.COL, TYPE),  COL
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.WID, TYPE),  WID
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.HEI, TYPE),  HEI
$CHECKING:ON
  GUI_element_create_image this

  END SUB
    
  FUNCTION GUI_element_get_row& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_GET_ROW& = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.ROW, TYPE), LONG) 
$CHECKING:ON

  END FUNCTION

  FUNCTION GUI_element_get_col& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_GET_COL& = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.COL, TYPE), LONG) 
$CHECKING:ON

  END FUNCTION














  SUB GUI_put_image (row AS LONG, col AS LONG, src as LONG, dest AS LONG)
  $CHECKING:OFF
  DIM img1 AS _MEM, img2 AS _MEM, x as LONG, wid1 AS LONG, wid2 AS LONG, hei AS LONG
  img1 = _MEMIMAGE(src)
  img2 = _MEMIMAGE(dest)
  wid1 = _WIDTH(src)
  wid2 = _WIDTH(dest)
  hei  = _HEIGHT(src)
  FOR x = 0 to hei - 1
    _MEMCOPY img1, img1.OFFSET + (x * wid1) * 2, wid1 * 2 TO img2, img2.OFFSET + ((x + row - 1) * wid2) * 2 + (col - 1) * 2
  NEXT x
  _MEMFREE img1
  _MEMFREE img2
  $CHECKING:ON

  END SUB
  




SUB GUI_element_container_init (this as _OFFSET)
GUI_element_init this

END SUB

SUB GUI_element_container_clear (this as _OFFSET)
$CHECKING:OFF
IF _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE), _OFFSET)  <> 0 THEN
$CHECKING:ON
  GUI_element_container_remove this
end if
GUI_element_clear this

END SUB

SUB GUI_element_container_add (this as _OFFSET, obj as _OFFSET)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE),  GUI_REF_OBJECT_GET_REF%&(OBJ) AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_CONTAINER.FLAGS, TYPE),  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.FLAGS, TYPE), LONG)  OR GUI_CONTAINER_FLAG_ADDED_ELEMENT AS LONG
$CHECKING:ON

END SUB

SUB GUI_element_container_remove (this as _OFFSET)
$CHECKING:OFF
GUI_REF_OBJECT_RELEASE_REF _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE), _OFFSET) 
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE),  0 AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_CONTAINER.FLAGS, TYPE),  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.FLAGS, TYPE), LONG)  AND NOT GUI_CONTAINER_FLAG_ADDED_ELEMENT AS LONG
$CHECKING:ON

END SUB

FUNCTION GUI_element_container_get_contained%& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_CONTAINER_GET_CONTAINED%& = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE), _OFFSET) 
$CHECKING:ON

END FUNCTION























FUNCTION GUI_element_button_new%& ()
GUI_element_button_new%& = GUI_element_button_new_with_text%&("")

END FUNCTION

FUNCTION GUI_element_button_new_with_text%& (n$)
DIM this as _OFFSET
this = MEM_MALLOC%&(LEN(GUI_element_button, TYPE))
MEM_MEMSET this, LEN(GUI_element_button, TYPE), 0
GUI_element_button_init this
GUI_element_button_set_text this, n$
GUI_element_button_new_with_text%& = this

END FUNCTION

SUB GUI_element_button_init (this as _OFFSET)
GUI_element_container_init this
GUI_element_set_element_type this, GUI_BUTTON
GUI_element_set_draw_proc this, GUI_ELEMENT_BUTTON_DRAW_ptr%&
GUI_ref_Object_set_delete_proc this, GUI_ELEMENT_BUTTON_DELETE_ptr%&

$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_BUTTON.THEME.SEL.F, TYPE),  0 AS LONG
$CHECKING:ON
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_BUTTON.THEME.SEL.B, TYPE),  7 AS LONG
$CHECKING:ON

END SUB

SUB GUI_element_button_delete (this as _OFFSET)
GUI_element_button_clear this
MEM_FREE this

END SUB

SUB GUI_element_button_clear (this as _OFFSET)
GUI_element_container_clear this

END SUB

SUB GUI_element_button_set_text (this as _OFFSET, t$)
DIM m as MEM_string
$CHECKING:OFF
M =  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_BUTTON.TEXT, TYPE), MEM_STRING) 
$CHECKING:ON
MEM_put_str m, t$
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_BUTTON.TEXT, TYPE),  M
$CHECKING:ON
GUI_element_set_size this, 1, len(t$) + 4
$CHECKING:OFF
CALL__OFFSET  _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DRW, TYPE), _OFFSET) , THIS
$CHECKING:ON

END SUB

SUB GUI_element_button_draw (this as _OFFSET)
DIM m as MEM_String
d& = _DEST
$CHECKING:OFF
_DEST _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG) 
$CHECKING:ON
$CHECKING:OFF
COLOR _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_BUTTON.THEME.SEL.F, TYPE), _BYTE) , _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_BUTTON.THEME.SEL.B, TYPE), _BYTE) 
$CHECKING:ON
$CHECKING:OFF
M = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_BUTTON.TEXT, TYPE), MEM_STRING) 
$CHECKING:ON
PRINT "< "; MEM_get_str$(m); " >";
_DEST d&

END SUB





FUNCTION GUI_element_frame_new%& ()
DIM this as _OFFSET
this = MEM_MALLOC%&(LEN(GUI_element_frame, TYPE))
MEM_MEMSET this, LEN(GUI_element_frame, TYPE), 0
GUI_element_frame_init this
GUI_ref_Object_set_delete_proc this, GUI_ELEMENT_FRAME_DELETE_ptr%&
GUI_element_frame_new%& = this

END FUNCTION

SUB GUI_element_frame_init (this as _OFFSET)
GUI_element_container_init this

END SUB

SUB GUI_element_frame_delete (this as _OFFSET)
GUI_element_frame_clear this
MEM_FREE this

END SUB

SUB GUI_element_frame_clear (this as _OFFSET)
DIM m as MEM_String
$CHECKING:OFF
M = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_FRAME.NAM, TYPE), MEM_STRING) 
$CHECKING:ON
MEM_free_string m
GUI_element_container_clear this

END SUB






FUNCTION GUI_element_window_new%&()
GUI_element_window_new%& = GUI_element_window_new_with_size_title%&(25, 80, "")

END FUNCTION


FUNCTION GUI_element_window_new_with_size%&(row as LONG, col AS LONG)
GUI_element_window_new_with_size%& = GUI_element_window_new_with_size_title%&(row, col, "")

END FUNCTION

FUNCTION GUI_element_window_new_with_size_title%&(row as LONG, col as LONG, title$)
DIM this as _OFFSET
this = MEM_MALLOC%&(LEN(GUI_element_window, TYPE))
MEM_MEMSET this, LEN(GUI_element_window, TYPE), 0

GUI_element_window_init this
GUI_element_window_set_size this, row, col
GUI_element_window_set_title this, title$
GUI_element_window_new_with_size_title%& = this

END FUNCTION

SUB GUI_element_window_init (this as _OFFSET)
GUI_element_container_init this
GUI_element_set_draw_proc this, GUI_ELEMENT_WINDOW_DRAW_ptr%&
GUI_ref_Object_set_delete_proc this, GUI_ELEMENT_WINDOW_DELETE_ptr%&

END SUB

SUB GUI_element_window_set_as_screen (this as _OFFSET)
GUI_element_show this
SCREEN GUI_element_get_image&(this)

END SUB

SUB GUI_element_window_set_size (this as _OFFSET, row, col)
GUI_element_set_size this, row, col

END SUB

SUB GUI_element_window_set_title (this as _OFFSET, t$)
DIM m as MEM_String
$CHECKING:OFF
M = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_WINDOW.TITLE, TYPE), MEM_STRING) 
$CHECKING:ON
MEM_put_str m, t$
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_WINDOW.TITLE, TYPE),  M
$CHECKING:ON

END SUB

SUB GUI_element_window_draw (this as _OFFSET)
DIM m as MEM_String
if GUI_ELEMENT_CFLAG_VISIBLE(this) then
$CHECKING:OFF
M = _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_WINDOW.TITLE, TYPE), MEM_STRING) 
$CHECKING:ON
  t$ = MEM_get_str$(m)
  _TITLE t$
$CHECKING:OFF
IF _MEMGET(GUI__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE), _OFFSET)  <> 0 THEN
$CHECKING:ON
    DIM o as _OFFSET 
    o = GUI_element_container_get_contained%&(this)
$CHECKING:OFF
CALL__OFFSET  _MEMGET(GUI__QB64__EMPTY_MEM, O + _OFFSET(GUI_ELEMENT.DRW, TYPE), _OFFSET) , O
$CHECKING:ON
    
    GUI_put_image GUI_element_get_row&(o), GUI_element_get_col&(o), GUI_element_get_image&(o), GUI_element_get_image&(this)
  end if
end if

END SUB

SUB GUI_element_window_delete (this as _OFFSET)
GUI_element_window_clear this
MEM_FREE this

END SUB

SUB GUI_element_window_clear (this as _OFFSET)
GUI_element_container_clear this

END SUB


FUNCTION GUI_ELEMENT_CFLAG_UPDATED(this as _OFFSET): GUI_ELEMENT_CFLAG_UPDATED = MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) AND 1
END FUNCTION
SUB GUI_ELEMENT_FLAG_SET_UPDATED(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) OR 1 AS LONG
$CHECKING:ON
END SUB
SUB GUI_ELEMENT_FLAG_UNSET_UPDATED(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) AND NOT 1 AS LONG
$CHECKING:ON
END SUB
SUB GUI_ELEMENT_FLAG_TOGGLE_UPDATED(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) XOR 1 AS LONG
$CHECKING:ON
END SUB
FUNCTION GUI_ELEMENT_CFLAG_VISIBLE(this as _OFFSET): GUI_ELEMENT_CFLAG_VISIBLE = MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) AND 2
END FUNCTION
SUB GUI_ELEMENT_FLAG_SET_VISIBLE(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) OR 2 AS LONG
$CHECKING:ON
END SUB
SUB GUI_ELEMENT_FLAG_UNSET_VISIBLE(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) AND NOT 2 AS LONG
$CHECKING:ON
END SUB
SUB GUI_ELEMENT_FLAG_TOGGLE_VISIBLE(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) XOR 2 AS LONG
$CHECKING:ON
END SUB
FUNCTION GUI_ELEMENT_CFLAG_ACTIVE(this as _OFFSET): GUI_ELEMENT_CFLAG_ACTIVE = MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) AND 4
END FUNCTION
SUB GUI_ELEMENT_FLAG_SET_ACTIVE(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) OR 4 AS LONG
$CHECKING:ON
END SUB
SUB GUI_ELEMENT_FLAG_UNSET_ACTIVE(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) AND NOT 4 AS LONG
$CHECKING:ON
END SUB
SUB GUI_ELEMENT_FLAG_TOGGLE_ACTIVE(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) XOR 4 AS LONG
$CHECKING:ON
END SUB
FUNCTION GUI_ELEMENT_CFLAG_SKIP(this as _OFFSET): GUI_ELEMENT_CFLAG_SKIP = MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) AND 8
END FUNCTION
SUB GUI_ELEMENT_FLAG_SET_SKIP(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) OR 8 AS LONG
$CHECKING:ON
END SUB
SUB GUI_ELEMENT_FLAG_UNSET_SKIP(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) AND NOT 8 AS LONG
$CHECKING:ON
END SUB
SUB GUI_ELEMENT_FLAG_TOGGLE_SKIP(this as _OFFSET)
$CHECKING:OFF
 _MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.flags, TYPE), MEM_long_from_off&(this + _OFFSET(GUI_ELEMENT.flags, TYPE)) XOR 8 AS LONG
$CHECKING:ON
END SUB
SUB GUI_ELEMENT_SET_ELEMENT_TYPE(this as _OFFSET, a AS _UNSIGNED LONG)
$CHECKING:OFF
_MEMPUT GUI__QB64__EMPTY_MEM, this + _OFFSET(GUI_ELEMENT.ELEMENT_TYPE, TYPE), a
$CHECKING:ON
END SUB
DECLARE CUSTOMTYPE LIBRARY "oop_ex_OUTPUT"
  FUNCTION MEM_FREE_ptr%& ()
  FUNCTION MEM_MEMCPY_ptr%& ()
  FUNCTION MEM_MEMSET_ptr%& ()
  FUNCTION MEM_MEMMOVE_ptr%& ()
  FUNCTION TEST_SIGNAL1_ptr%& ()
  FUNCTION TEST_SIGNAL2_ptr%& ()
  FUNCTION TEST_SIGNAL3_ptr%& ()
  FUNCTION MEM_PUT_STR_ptr%& ()
  FUNCTION MEM_PUT_STR_ARRAY_ptr%& ()
  FUNCTION MEM_ALLOCATE_ARRAY_ptr%& ()
  FUNCTION MEM_REALLOCATE_ARRAY_ptr%& ()
  FUNCTION MEM_ALLOCATE_STRING_ARRAY_ptr%& ()
  FUNCTION MEM_FREE_STRING_ARRAY_ptr%& ()
  FUNCTION MEM_FREE_ARRAY_ptr%& ()
  FUNCTION MEM_FREE_STRING_ptr%& ()
  FUNCTION GUI_REF_OBJECT_INIT_ptr%& ()
  FUNCTION GUI_REF_OBJECT_RELEASE_REF_ptr%& ()
  FUNCTION GUI_REF_OBJECT_SET_DELETE_PROC_ptr%& ()
  FUNCTION GUI_REF_OBJECT_CLEAR_ptr%& ()
  FUNCTION GUI_REF_OBJECT_DELETE_ptr%& ()
  FUNCTION GUI_SIGNAL_INIT_ptr%& ()
  FUNCTION GUI_SIGNAL_CLEAR_ptr%& ()
  FUNCTION GUI_SIGNAL_CLEAR_SIGNALS_ptr%& ()
  FUNCTION GUI_SIGNAL_DISCONNECT_ptr%& ()
  FUNCTION GUI_SIGNAL_ADD_NEW_SIGNAL_ptr%& ()
  FUNCTION GUI_SIGNAL_EMIT_ptr%& ()
  FUNCTION GUI_ELEMENT_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_CLEAR_ptr%& ()
  FUNCTION GUI_ELEMENT_SHOW_ptr%& ()
  FUNCTION GUI_ELEMENT_HIDE_ptr%& ()
  FUNCTION GUI_ELEMENT_CREATE_IMAGE_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_SIZE_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_DIMENSION_D_ptr%& ()
  FUNCTION GUI_ELEMENT_ADD_PARENT_ptr%& ()
  FUNCTION GUI_ELEMENT_REMOVE_PARENT_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_DRAW_PROC_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_LOCATION_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_DIMENSION_ptr%& ()
  FUNCTION GUI_PUT_IMAGE_ptr%& ()
  FUNCTION GUI_ELEMENT_CONTAINER_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_CONTAINER_CLEAR_ptr%& ()
  FUNCTION GUI_ELEMENT_CONTAINER_ADD_ptr%& ()
  FUNCTION GUI_ELEMENT_CONTAINER_REMOVE_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_DELETE_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_CLEAR_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_SET_TEXT_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_DRAW_ptr%& ()
  FUNCTION GUI_ELEMENT_FRAME_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_FRAME_DELETE_ptr%& ()
  FUNCTION GUI_ELEMENT_FRAME_CLEAR_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_SET_AS_SCREEN_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_SET_SIZE_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_SET_TITLE_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_DRAW_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_DELETE_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_CLEAR_ptr%& ()
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
  SUB call__OFFSET_STRING_LONG( BYVAL va AS _OFFSET, A AS _OFFSET, B AS STRING, C AS LONG)
  SUB call__OFFSET_STRING( BYVAL va AS _OFFSET, A AS _OFFSET, B AS STRING)
  SUB call__OFFSET_GUI_DIMENSION( BYVAL va AS _OFFSET, A AS _OFFSET, B AS GUI_DIMENSION)
  SUB call__OFFSET_LONG_LONG_LONG_LONG( BYVAL va AS _OFFSET, A AS _OFFSET, B AS LONG, C AS LONG, D AS LONG, E AS LONG)
  SUB call_LONG_LONG_LONG_LONG( BYVAL va AS _OFFSET, A AS LONG, B AS LONG, C AS LONG, D AS LONG)
  SUB call__OFFSET_SINGLE_SINGLE( BYVAL va AS _OFFSET, A AS _OFFSET, B AS SINGLE, C AS SINGLE)
END DECLARE
