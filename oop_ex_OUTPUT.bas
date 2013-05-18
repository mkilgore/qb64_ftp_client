$CONSOLE
DIM SHARED PARS__QB64__EMPTY_MEM AS _MEM
CONST OBJ_TYPE_INFO_FLAG_IS_ABSTRACT = 1
CONST GUI_EVENT_KEY = 1
CONST GUI_EVENT_MOUSE = 2
CONST GUI_ELEMENT_FLAG_UPDATED = 1
CONST GUI_ELEMENT_FLAG_VISIBLE = 2
CONST GUI_ELEMENT_FLAG_ACTIVE = 4
CONST GUI_ELEMENT_FLAG_SKIP = 8
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



CONST OBJ_NULL = 0














CONST OBJ_TYPE_PARENT_MAX = 40

TYPE OBJ_type_info
  base_size     AS LONG 
  class_size    AS LONG 
  init          AS _OFFSET
  class_init    AS _OFFSET
  destroy       AS _OFFSET
  parent        AS LONG
  flags         AS LONG
  class_copy      AS _OFFSET
  interface_count AS LONG 
  allocated_bytes  AS LONG
END TYPE

TYPE OBJ_type_interface_node
  iface        AS LONG 
  iface_off    AS _OFFSET 
END TYPE

TYPE OBJ_type_interface
  size    AS LONG
  flags   AS LONG
END TYPE

REDIM SHARED OBJ_TYPE_list(100) AS OBJ_type_info, OBJ_type_count AS LONG
REDIM SHARED OBJ_type_Interface_list(100) as OBJ_type_interface, OBJ_type_interface_count AS LONG

TYPE OBJ_Object
  vtable AS _OFFSET
  otype  AS LONG
END TYPE

TYPE OBJ_Object_class
  otype       AS LONG
  iface_off   AS _OFFSET
END TYPE




TYPE OBJ_ref_object
  parent AS OBJ_Object
  ref_count AS _UNSIGNED LONG
END TYPE

TYPE OBJ_ref_object_class 
  parent_class as OBJ_Object_class
  get_ref      AS  _OFFSET
  release_ref  AS  _OFFSET
END TYPE
















TYPE OBJ_signal_node
  signal_name       AS MEM_string
  id AS _UNSIGNED LONG
  first_connection AS _OFFSET
  next_signal as _OFFSET
END TYPE








TYPE OBJ_signal_connection_node
  notify_proc AS _OFFSET
  id as _UNSIGNED LONG
  dat AS _OFFSET
  next_connection AS _OFFSET 
END TYPE












TYPE OBJ_signal
  parent as OBJ_ref_object
  next_connection_id AS _UNSIGNED LONG
  next_signal_id AS _UNSIGNED LONG
  first_signal as _OFFSET 
END TYPE

TYPE OBJ_signal_class 
  parent_class AS OBJ_ref_Object_class

  disconnect_signal         AS  _OFFSET
  disconnect_connection     AS  _OFFSET

  get_signal_id             AS  _OFFSET
  connect_to_signal         AS  _OFFSET
  connect_to_signal_with_id AS  _OFFSET
  add_new_signal                AS  _OFFSET

  emit                      AS  _OFFSET
END TYPE








CONST GUI_VER$ = ".97" 



CONST GUI_TRUE       = -1
CONST GUI_FALSE      = 0
CONST GUI_NULL       = 0
CONST GUI_IMAGE_NULL = -1


CONST GUI_KEY_CODE_PAUSE            = 100019
CONST GUI_KEY_CODE_NUMLOCK          = 100300 
CONST GUI_KEY_CODE_CAPSLOCK         = 100301 
CONST GUI_KEY_CODE_SCROLLOCK        = 100302 
CONST GUI_KEY_CODE_RSHIFT           = 100303 
CONST GUI_KEY_CODE_LSHIFT           = 100304 
CONST GUI_KEY_CODE_RCTRL            = 100305 
CONST GUI_KEY_CODE_LCTRL            = 100306 
CONST GUI_KEY_CODE_RALT             = 100307 
CONST GUI_KEY_CODE_LALT             = 100308 
CONST GUI_KEY_CODE_RAPPLE           = 100309 
CONST GUI_KEY_CODE_LAPPLE           = 100310 
CONST GUI_KEY_CODE_LMETA            = 100311 
CONST GUI_KEY_CODE_RMETA            = 100312 
CONST GUI_KEY_CODE_ALT_GR           = 100313 
CONST GUI_KEY_CODE_COMPOSE          = 100314 
CONST GUI_KEY_CODE_HELP             = 100315 
CONST GUI_KEY_CODE_PRINT            = 100316 
CONST GUI_KEY_CODE_SYSREQ           = 100317 
CONST GUI_KEY_CODE_BREAK            = 100318 
CONST GUI_KEY_CODE_MENU             = 100319 
CONST GUI_KEY_CODE_POWER            = 100320 
CONST GUI_KEY_CODE_EURO             = 100321 
CONST GUI_KEY_CODE_UNDO             = 100322 
CONST GUI_KEY_CODE_KP0              = 100256 
CONST GUI_KEY_CODE_KP1              = 100257 
CONST GUI_KEY_CODE_KP2              = 100258 
CONST GUI_KEY_CODE_KP3              = 100259 
CONST GUI_KEY_CODE_KP4              = 100260 
CONST GUI_KEY_CODE_KP5              = 100261
CONST GUI_KEY_CODE_KP7              = 100263 
CONST GUI_KEY_CODE_KP8              = 100264 
CONST GUI_KEY_CODE_KP9              = 100265 
CONST GUI_KEY_CODE_KP_PERIOD        = 100266
CONST GUI_KEY_CODE_KP_DIVIDE        = 100267 
CONST GUI_KEY_CODE_KP_MULTIPLY      = 100268
CONST GUI_KEY_CODE_KP_MINUS         = 100269 
CONST GUI_KEY_CODE_KP_PLUS          = 100270 
CONST GUI_KEY_CODE_KP_ENTER         = 100271 
CONST GUI_KEY_CODE_KP_INSERT        = 200000 
CONST GUI_KEY_CODE_KP_END           = 200001 
CONST GUI_KEY_CODE_KP_DOWN          = 200002 
CONST GUI_KEY_CODE_KP_PAGE_DOWN     = 200003 
CONST GUI_KEY_CODE_KP_LEFT          = 200004 
CONST GUI_KEY_CODE_KP_MIDDLE        = 200005 
CONST GUI_KEY_CODE_KP_RIGHT         = 200006 
CONST GUI_KEY_CODE_KP_HOME          = 200007 
CONST GUI_KEY_CODE_KP_UP            = 200008 
CONST GUI_KEY_CODE_KP_PAGE_UP       = 200009 
CONST GUI_KEY_CODE_KP_DELETE        = 200010 
CONST GUI_KEY_CODE_SCROLL_LOCK_MODE = 200011 
CONST GUI_KEY_CODE_INSERT_MODE      = 200012
CONST GUI_KEY_CODE_TAB              = 9
CONST GUI_KEY_CODE_BACKSPACE        = 8
CONST GUI_KEY_CODE_F1               = 15104
CONST GUI_KEY_CODE_F2               = 15360
CONST GUI_KEY_CODE_F3               = 15616
CONST GUI_KEY_CODE_F4               = 15872
CONST GUI_KEY_CODE_F5               = 16128
CONST GUI_KEY_CODE_F6               = 16384
CONST GUI_KEY_CODE_F7               = 16640
CONST GUI_KEY_CODE_F8               = 16896
CONST GUI_KEY_CODE_F9               = 17152
CONST GUI_KEY_CODE_F10              = 17408
CONST GUI_KEY_CODE_F11              = 34048
CONST GUI_KEY_CODE_F12              = 34304
CONST GUI_KEY_CODE_ESC              = 27
CONST GUI_KEY_CODE_DEL              = 21248 
CONST GUI_KEY_CODE_END              = 20224 
CONST GUI_KEY_CODE_PGDN             = 20736
CONST GUI_KEY_CODE_INSERT           = 20992
CONST GUI_KEY_CODE_HOME             = 18176
CONST GUI_KEY_CODE_PGUP             = 18688
CONST GUI_KEY_CODE_UP               = 18432
CONST GUI_KEY_CODE_LEFT             = 19200
CONST GUI_KEY_CODE_DOWN             = 20480
CONST GUI_KEY_CODE_RIGHT            = 19712
CONST GUI_KEY_CODE_ENTER            = 13
CONST GUI_KEY_CODE_SPACE            = 32

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






TYPE GUI_event_interface 
  proc1 AS  _OFFSET
  proc2 AS  _OFFSET
  proc3 AS  _OFFSET
END TYPE




TYPE GUI_event
  obj as OBJ_ref_object
  event_type AS _UNSIGNED LONG
  source as _OFFSET 
  modifiers AS _UNSIGNED LONG
END TYPE

TYPE GUI_event_class
  parent_class AS OBJ_ref_object_class
END TYPE




TYPE GUI_event_key 
  e as GUI_event 
  key_code AS _UNSIGNED LONG  
  
  flags AS _UNSIGNED INTEGER
END TYPE




TYPE GUI_event_mouse_state 
  MROW as INTEGER
  MCOL AS INTEGER
  MRIGHT AS INTEGER
  MLEFT AS INTEGER
  MMIDDLE AS INTEGER
  MSCROLL AS INTEGER
END TYPE

TYPE GUI_event_mouse 
  e as GUI_event
  
  m as GUI_event_mouse_state
  row2 AS _UNSIGNED LONG 
  col2 AS _UNSIGNED LONG
  flags as INTEGER
  count as INTEGER
END TYPE









TYPE GUI_Element
  parent_obj as OBJ_signal
  
  nam       AS MEM_String
  dimension AS GUI_dimension
  flags     AS _UNSIGNED LONG
  img       AS LONG 
  parent    AS _OFFSET

END TYPE

TYPE GUI_Element_class 
  parent_class    AS OBJ_Signal_class
  drw             AS  _OFFSET
  create_image    AS  _OFFSET

  set_visible     AS  _OFFSET
  is_visible      AS  _OFFSET
  
  set_active      AS  _OFFSET
  is_active       AS  _OFFSET

  set_can_focus   AS  _OFFSET
  get_can_focus   AS  _OFFSET
  set_size        AS  _OFFSET
  get_image       AS  _OFFSET
  get_parent      AS  _OFFSET
  set_parent      AS  _OFFSET
  set_name        AS  _OFFSET
  get_name        AS  _OFFSET
  
  set_location    AS  _OFFSET
  set_dimension   AS  _OFFSET
  set_dimension_d AS  _OFFSET
  
  set_width       AS  _OFFSET
  get_width       AS  _OFFSET
  
  set_height      AS  _OFFSET
  get_height      AS  _OFFSET
  
  set_row         AS  _OFFSET
  set_col         AS  _OFFSET
  get_row         AS  _OFFSET
  get_col         AS  _OFFSET
END TYPE



TYPE GUI_element_container
  ele as GUI_Element
  element AS _OFFSET
  flags as _UNSIGNED LONG
END TYPE

TYPE GUI_element_container_class
  parent  AS GUI_element_class
END TYPE
























TYPE GUI_element_button_color
  sel as GUI_color
  normal as GUI_color
END TYPE


TYPE GUI_element_button
  ele as GUI_element_container
  theme AS GUI_element_button_color
  flags AS _UNSIGNED LONG
    text as MEM_string
END TYPE

TYPE GUI_element_button_class
  parent_class as GUI_element_container_class
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

TYPE GUI_element_window_class
  parent_class AS GUI_element_container_class
END TYPE




DIM Win AS _OFFSET, button as _OFFSET, ele AS LONG, m as MEM_String, of as _OFFSET

Win = GUI_element_window_new_s_title%&(25, 80, "Hey!")

button = GUI_element_button_new_text%&("Hi!")
GUI_element_set_location button, 20, 15

GUI_element_container_add Win, button

GUI_element_window_screen win


id = OBJ_signal_add_new_signal(button, "pressed1")
print id
sleep
id = OBJ_signal_add_new_signal(button, "pressed2")
id = OBJ_signal_add_new_signal(button, "pressed3")

of = _OFFSET(m)

$CHECKING:OFF
handle_id = OBJ_signal_connect_to_signal&(button, "pressed1", TEST_SIGNAL1_ptr%&, of)
$CHECKING:ON

print handle_id
sleep

$CHECKING:OFF
PRINT fc__OFFSET__OFFSET_LONG_LONG( TEST,ARG1, ARG2, ARG3)
$CHECKING:ON

DO
  _LIMIT 60
  a$ = inkey$
  if a$ > "" then
    MEM_put_str m, a$
    OBJ_signal_emit button, "pressed1"
  end if
LOOP until a$ = chr$(27)

SUB Test_signal1 (this as _OFFSET, dat as _OFFSET)
DIM m as MEM_String

MEM_MEMCPY _OFFSET(m), dat, LEN(MEM_String, TYPE)
print MEM_get_str$(m);

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

FUNCTION MEM_MALLOC0%& (bytes as LONG)
$CHECKING:OFF
DIM o as _OFFSET
o = MEM_MALLOC%&(bytes)
MEM_MEMSET o, 0, bytes
$CHECKING:ON

END FUNCTION














FUNCTION OBJ_is_instance_of& (this as _OFFSET, t as LONG)
$CHECKING:OFF
OTYPE = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_OBJECT.OTYPE, TYPE), LONG) 
$CHECKING:ON
  DO
    if otype = t then OBJ_is_instance_of& = -1: exit function
    otype = OBJ_type_list(otype).parent
  LOOP until otype = 0

END FUNCTION

FUNCTION OBJ_is_instance_of_interface& (this as _OFFSET, t as LONG)
  DIM class as _OFFSET, otype AS LONG
$CHECKING:OFF
OTYPE = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_OBJECT.OTYPE, TYPE), LONG) 
$CHECKING:ON
  if OBJ_type_list(otype).interface_count = 0 then exit function
  
$CHECKING:OFF
CLASS = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_OBJECT.VTABLE, TYPE), _OFFSET)  + OBJ_TYPE_LIST(OTYPE).CLASS_SIZE
$CHECKING:ON
  DO
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, CLASS + _OFFSET(OBJ_TYPE_INTERFACE_NODE.IFACE, TYPE), LONG)  = T THEN OBJ_IS_INSTANCE_OF_INTERFACE& = -1: EXIT FUNCTION
$CHECKING:ON
    class = class + LEN(OBJ_type_interface_node, TYPE)
  LOOP until otype = 0

END FUNCTION

FUNCTION OBJ_type_register_type& (t as OBJ_type_info)
  OBJ_type_count = OBJ_type_count + 1
  if OBJ_type_count > UBOUND(OBJ_type_list) then
    REDIM _PRESERVE OBJ_type_list(UBOUND(OBJ_type_list) + 100) AS OBJ_type_info
  end if
  
  OBJ_type_list(OBJ_type_count) = t
  OBJ_type_list(OBJ_type_count).class_copy = MEM_MALLOC0%&(t.class_size)
  OBJ_type_list(OBJ_type_count).allocated_bytes = t.class_size
  
  if t.parent > 0 then
    MEM_MEMCPY OBJ_type_list(OBJ_type_count).class_copy, OBJ_type_list(t.parent).class_copy, OBJ_type_list(t.parent).class_size
  end if
  
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, OBJ_TYPE_LIST(OBJ_TYPE_COUNT).CLASS_COPY+ _OFFSET(OBJ_OBJECT_CLASS.OTYPE, TYPE),  OBJ_TYPE_COUNT
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, OBJ_TYPE_LIST(OBJ_TYPE_COUNT).CLASS_COPY+ _OFFSET(OBJ_OBJECT_CLASS.IFACE_OFF, TYPE),  OBJ_TYPE_LIST(OBJ_TYPE_COUNT).CLASS_COPY + OBJ_TYPE_LIST(OBJ_TYPE_COUNT).CLASS_SIZE AS _OFFSET
$CHECKING:ON
  
$CHECKING:OFF
c__OFFSET  OBJ_type_list(OBJ_type_count).class_init, OBJ_type_list(OBJ_type_count).class_copy
$CHECKING:ON
  
  OBJ_type_register_type& = OBJ_type_count

END FUNCTION

FUNCTION OBJ_type_register_interface& (i as OBJ_type_interface)
  OBJ_type_interface_count = OBJ_type_interface_count + 1
  if OBJ_type_interface_count > UBOUND(OBJ_type_interface_list) then
    REDIM _PRESERVE OBJ_type_interface_list(UBOUND(OBJ_type_interface_list) + 100) AS OBJ_type_interface
  end if
  
  OBJ_type_interface_list(OBJ_type_interface_count) = i
  
  OBJ_type_register_interface& = OBJ_type_interface_count

END FUNCTION

FUNCTION OBJ_type_get_class_size& (t AS LONG)
  OBJ_type_get_class_size& = OBJ_type_list(t).class_size

END FUNCTION

FUNCTION OBJ_type_get_base_size& (t AS LONG)
  OBJ_type_get_base_size& = OBJ_type_list(t).base_size

END FUNCTION

FUNCTION OBJ_type_get_init%& (t AS LONG)
  OBJ_type_get_base_init%& = OBJ_type_list(t).init

END FUNCTION

FUNCTION OBJ_type_get_destroy%& (t as LONG)
  OBJ_type_get_destroy%& = OBJ_type_list(t).destroy

END FUNCTION

FUNCTION OBJ_type_get_parent& (t as LONG)
  OBJ_type_get_parent& = OBJ_type_list(t).parent

END FUNCTION

FUNCTION OBJ_type_allocate_new%& (t as LONG)
  DIM parent_list(OBJ_TYPE_PARENT_MAX) AS LONG, s_count AS LONG
  DIM this AS _OFFSET, class AS _OFFSET
  if (OBJ_type_list(t).flags AND OBJ_TYPE_INFO_FLAG_ABSTRACT) = 0 then
    this = MEM_MALLOC0%&(OBJ_type_list(t).base_size)
    class = OBJ_type_list(t).class_copy
    
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(OBJ_OBJECT.VTABLE, TYPE),  CLASS
$CHECKING:ON
    
    
    tn = t
    s_count = 1
    parent_list(s_count) = tn
    DO WHILE OBJ_type_list(tn).parent <> 0
      s_count = s_count + 1
      parent_list(s_count) = OBJ_type_list(tn).parent 
      tn = OBJ_type_list(tn).parent 
    loop
    FOR x = s_count to 1 STEP -1
      if OBJ_type_list(tn).init <> 0 then 
$CHECKING:OFF
c__OFFSET  OBJ_type_list(tn).init, this
$CHECKING:ON
      end if
    NEXT x
    OBJ_type_allocate_new%& = this
  else
DEBUG_PRINT  "Error: Can not instantiate type, abstract"
    OBJ_type_allocate_new%& = OBJ_NULL
  end if

END FUNCTION

FUNCTION OBJ_type_add_interface_to_class%& (class as _OFFSET, t AS LONG)
  
  DIM iface as _OFFSET, next_iface AS _OFFSET, otype AS LONG
  
  DIM old_size AS LONG, iface_size AS LONG, old AS _OFFSET, dest AS _OFFSET
  
$CHECKING:OFF
OTYPE = _MEMGET(PARS__QB64__EMPTY_MEM, CLASS + _OFFSET(OBJ_OBJECT_CLASS.OTYPE, TYPE), LONG) 
$CHECKING:ON
  iface = class + OBJ_type_list(otype).class_size 
  
  FOR x = 0 to OBJ_type_list(otype).interface_count - 1
    next_iface = iface + x * LEN(OBJ_type_interface_node, TYPE)
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, NEXT_IFACE + _OFFSET(OBJ_TYPE_INTERFACE_NODE.IFACE, TYPE), LONG)  = T THEN
$CHECKING:ON
$CHECKING:OFF
OBJ_TYPE_ADD_INTERFACE_TO_CLASS%& = _MEMGET(PARS__QB64__EMPTY_MEM, NEXT_IFACE + _OFFSET(OBJ_TYPE_INTERFACE_NODE.IFACE_OFF, TYPE), _OFFSET) 
$CHECKING:ON
      exit function
    end if
  next x
  
  OBJ_type_list(otype).interface_count = OBJ_type_list(otype).interface_count + 1
  old_size = OBJ_type_list(otype).allocated_bytes
  OBJ_type_list(otype).allocated_bytes = OBJ_type_list(otype).allocated_bytes + LEN(OBJ_type_interface_node, TYPE) + OBJ_type_interface_list(t).size
  
  class = MEM_REALLOC%&(class, OBJ_type_list(otype).allocated_bytes)
  
  if OBJ_type_list(otype).interface_count > 1 then
    
    iface_size = old_size - OBJ_type_list(otype).class_size - (OBJ_type_list(otype).interface_count - 1) * LEN(OBJ_type_interface_node, TYPE)
    old  = class + old_size
    dest = old + LEN(OBJ_type_interface_node, TYPE)
    MEM_MEMMOVE dest, old, iface_size
  end if
  
  
  for x = 0 to OBJ_type_list(otype).interface_count - 2
    next_iface = iface + x * LEN(OBJ_type_interface_node, TYPE)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, NEXT_IFACE+ _OFFSET(OBJ_TYPE_INTERFACE_NODE.IFACE_OFF, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, NEXT_IFACE + _OFFSET(OBJ_TYPE_INTERFACE_NODE.IFACE_OFF, TYPE), _OFFSET)  + LEN(OBJ_TYPE_INTERFACE_NODE, TYPE) AS _OFFSET
$CHECKING:ON
  next x
  
  next_iface = iface + (OBJ_type_list(otype).interface_count - 1) * LEN(OBJ_type_interface_node, TYPE)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, NEXT_IFACE+ _OFFSET(OBJ_TYPE_INTERFACE_NODE.IFACE, TYPE),  T AS LONG
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, NEXT_IFACE+ _OFFSET(OBJ_TYPE_INTERFACE_NODE.IFACE_OFF, TYPE),  CLASS + OBJ_TYPE_LIST(OTYPE).ALLOCATED_BYTES - OBJ_TYPE_INTERFACE_LIST(T).SIZE AS _OFFSET
$CHECKING:ON
  
$CHECKING:OFF
OBJ_TYPE_ADD_INTERFACE_TO_CLASS%& = _MEMGET(PARS__QB64__EMPTY_MEM, NEXT_IFACE + _OFFSET(OBJ_TYPE_INTERFACE_NODE.IFACE_OFF, TYPE), _OFFSET) 
$CHECKING:ON

END FUNCTION

FUNCTION OBJ_type_get_interface%& (class as _OFFSET, t as LONG)
  

END FUNCTION

FUNCTION OBJ_type_get_class%& (t as LONG)
  OBJ_type_get_class%& = OBJ_type_list(t).class_copy

END FUNCTION

FUNCTION OBJ_type_get_parent_class%& (t as LONG)
  OBJ_type_get_parent_class%& = OBJ_type_list(OBJ_type_list(t).parent).class_copy

END FUNCTION

FUNCTION OBJ_Object_get_type& ()
  STATIC otype AS LONG, t as OBJ_type_info
  if otype = 0 then
    t.base_size = LEN(OBJ_Object, TYPE)
    t.class_size = LEN(OBJ_Object_class, TYPE)
    t.init = 0
    t.destroy = 0
    t.parent = 0 
    t.flags = OBJ_TYPE_INFO_FLAG_ABSTRACT
    otype = OBJ_type_register_type&(t)
  end if
  OBJ_Object_get_type& = otype

END FUNCTION

FUNCTION OBJ_Object_get_class%& (this as _OFFSET)
$CHECKING:OFF
OBJ_OBJECT_GET_CLASS%& = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_OBJECT.VTABLE, TYPE), _OFFSET) 
$CHECKING:ON

END FUNCTION

FUNCTION OBJ_Object_get_interface%& (this as _OFFSET, t as LONG)
  DIM class as _OFFSET, otype AS LONG, iface AS _OFFSET
$CHECKING:OFF
OTYPE = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_OBJECT.OTYPE, TYPE), LONG) 
$CHECKING:ON
$CHECKING:OFF
CLASS = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_OBJECT.VTABLE, TYPE), _OFFSET) 
$CHECKING:ON
$CHECKING:OFF
IFACE = _MEMGET(PARS__QB64__EMPTY_MEM, CLASS + _OFFSET(OBJ_OBJECT_CLASS.IFACE_OFF, TYPE), _OFFSET) 
$CHECKING:ON
  
  FOR x = 0 to OBJ_type_list(otype).interface_count - 1
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, IFACE + _OFFSET(OBJ_TYPE_INTERFACE_NODE.IFACE, TYPE), LONG)  = T THEN
$CHECKING:ON
$CHECKING:OFF
OBJ_OBJECT_GET_INTERFACE%& = _MEMGET(PARS__QB64__EMPTY_MEM, IFACE + _OFFSET(OBJ_TYPE_INTERFACE_NODE.IFACE_OFF, TYPE), _OFFSET) 
$CHECKING:ON
      exit function
    end if
    iface = iface + LEN(OBJ_type_interface_node, TYPE)
  NEXT x

END FUNCTION

FUNCTION OBJ_Object_get_parent_class%& (this as _OFFSET)
$CHECKING:OFF
OBJ_OBJECT_GET_PARENT_CLASS%& = OBJ_TYPE_LIST(OBJ_TYPE_LIST(_MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_OBJECT.OTYPE, TYPE), LONG) ).PARENT).CLASS_COPY
$CHECKING:ON

END FUNCTION

FUNCTION OBJ_Class_get_type& (class as _OFFSET)
$CHECKING:OFF
OBJ_CLASS_GET_TYPE& = _MEMGET(PARS__QB64__EMPTY_MEM, CLASS + _OFFSET(OBJ_OBJECT_CLASS.OTYPE, TYPE), LONG) 
$CHECKING:ON

END FUNCTION

SUB OBJ_Object_destroy (this as _OFFSET)
$CHECKING:OFF
OTYPE = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_OBJECT.OTYPE, TYPE), LONG) 
$CHECKING:ON
  tn = otype
  DO
    if OBJ_type_list(tn).destroy then
$CHECKING:OFF
c__OFFSET  OBJ_type_list(tn).destroy, this
$CHECKING:ON
    end if
    tn = OBJ_type_list(tn).parent 
  LOOP Until tn = 0
  MEM_FREE this

END SUB




FUNCTION OBJ_ref_object_get_type& ()
  STATIC added
  DIM t as OBJ_type_info
  if added = 0 then
    t.class_size = LEN(OBJ_ref_object_class, TYPE)
    t.base_size = LEN(OBJ_ref_object, TYPE)
$CHECKING:OFF
    t.init = OBJ_REF_OBJECT_INIT_ptr%&
$CHECKING:ON
$CHECKING:OFF
    t.class_init = OBJ_REF_OBJECT_CLASS_INIT_ptr%&
$CHECKING:ON
$CHECKING:OFF
    t.destroy = OBJ_REF_OBJECT_DESTROY_ptr%&
$CHECKING:ON
    t.parent = OBJ_Object_get_type&
    added = OBJ_type_register_type&(t)
  end if
  OBJ_ref_object_get_type& = added

END FUNCTION

SUB OBJ_ref_object_init (this as _OFFSET)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(OBJ_REF_OBJECT.REF_COUNT, TYPE),  0 AS LONG
$CHECKING:ON

END SUB

SUB OBJ_ref_object_class_init (class as _OFFSET)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(OBJ_REF_OBJECT_CLASS.GET_REF, TYPE),  OBJ_REF_OBJECT_PRIVATE_GET_REF_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(OBJ_REF_OBJECT_CLASS.RELEASE_REF, TYPE),  OBJ_REF_OBJECT_PRIVATE_RELEASE_REF_PTR%& AS _OFFSET
$CHECKING:ON

END SUB













FUNCTION OBJ_ref_Object_private_get_ref%& (this as _OFFSET)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(OBJ_REF_OBJECT.REF_COUNT, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_REF_OBJECT.REF_COUNT, TYPE), LONG)  + 1 AS LONG
$CHECKING:ON
  OBJ_ref_Object_private_get_ref%& = this

END FUNCTION

SUB OBJ_ref_Object_private_release_ref (this as _OFFSET)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(OBJ_REF_OBJECT.REF_COUNT, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_REF_OBJECT.REF_COUNT, TYPE), LONG)  - 1 AS LONG
$CHECKING:ON
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_REF_OBJECT.REF_COUNT, TYPE), LONG)  = 0 THEN
$CHECKING:ON
    OBJ_Object_destroy this
  end if

END SUB

SUB OBJ_ref_Object_destroy (this as _OFFSET)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(OBJ_REF_OBJECT.REF_COUNT, TYPE),  0 AS LONG
$CHECKING:ON

END SUB















FUNCTION OBJ_signal_get_type& ()
STATIC added
DIM t as OBJ_type_info
IF added = 0 then
  t.class_size = LEN(OBJ_signal_class, TYPE)
  t.base_size = LEN(OBJ_signal, TYPE)
$CHECKING:OFF
  t.init = OBJ_SIGNAL_INIT_ptr%&
$CHECKING:ON
$CHECKING:OFF
  t.class_init = OBJ_SIGNAL_INIT_CLASS_ptr%&
$CHECKING:ON
$CHECKING:OFF
  t.destroy = OBJ_SIGNAL_DESTROY_ptr%&
$CHECKING:ON
  t.parent = OBJ_ref_object_get_type&
  t.flags = OBJ_TYPE_INFO_FLAG_ABSTRACT
  added = OBJ_type_register_type&(t)
end if
OBJ_signal_get_type& = added

END FUNCTION






SUB OBJ_signal_init (this as _OFFSET)



END SUB

SUB OBJ_signal_init_class (class as _OFFSET)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(OBJ_SIGNAL_CLASS.DISCONNECT_SIGNAL, TYPE),  OBJ_SIGNAL_PRIVATE_DISCONNECT_SIGNAL_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(OBJ_SIGNAL_CLASS.DISCONNECT_CONNECTION, TYPE),  OBJ_SIGNAL_PRIVATE_DISCONNECT_CON_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(OBJ_SIGNAL_CLASS.GET_SIGNAL_ID, TYPE),  OBJ_SIGNAL_PRIVATE_GET_SIGNAL_ID_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(OBJ_SIGNAL_CLASS.CONNECT_TO_SIGNAL, TYPE),  OBJ_SIGNAL_PRIVATE_CONNECT_TO_SIGNAL_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(OBJ_SIGNAL_CLASS.CONNECT_TO_SIGNAL_WITH_ID, TYPE),  OBJ_SIGNAL_PRIVATE_CONNECT_TO_S_W_I_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(OBJ_SIGNAL_CLASS.ADD_NEW_SIGNAL, TYPE),  OBJ_SIGNAL_PRIVATE_ADD_NEW_SIGNAL_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(OBJ_SIGNAL_CLASS.EMIT, TYPE),  OBJ_SIGNAL_PRIVATE_EMIT_PTR%& AS _OFFSET
$CHECKING:ON

END SUB











SUB OBJ_signal_destroy (this as _OFFSET)
OBJ_signal_clear_signals this

END SUB

SUB OBJ_signal_clear_signals (this as _OFFSET)


END SUB

SUB OBJ_signal_private_disconnect_signal (this as _OFFSET, id as _UNSIGNED LONG)


END SUB

SUB OBJ_signal_private_disconnect_con (this as _OFFSET, id as _UNSIGNED LONG)


END SUB

FUNCTION OBJ_signal_private_get_signal_id& (this as _OFFSET, n$)
$CHECKING:OFF
DIM sig as _OFFSET, m as MEM_string
$CHECKING:OFF
SIG = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_SIGNAL.FIRST_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
DO WHILE sig <> 0
$CHECKING:OFF
M = _MEMGET(PARS__QB64__EMPTY_MEM, SIG + _OFFSET(OBJ_SIGNAL_NODE.SIGNAL_NAME, TYPE), MEM_STRING) 
$CHECKING:ON
  if MEM_get_str$(m) = n$ then
$CHECKING:OFF
OBJ_SIGNAL_PRIVATE_GET_SIGNAL_ID& = _MEMGET(PARS__QB64__EMPTY_MEM, SIG + _OFFSET(OBJ_SIGNAL_NODE.ID, TYPE), LONG) 
$CHECKING:ON
    exit function
  end if
$CHECKING:OFF
SIG = _MEMGET(PARS__QB64__EMPTY_MEM, SIG + _OFFSET(OBJ_SIGNAL_NODE.NEXT_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
LOOP
$CHECKING:ON

END FUNCTION





















FUNCTION OBJ_signal_private_connect_to_signal& (this as _OFFSET, n$, pro as _OFFSET, dat as _OFFSET)
$CHECKING:OFF
DIM sig as _OFFSET, m as MEM_string
$CHECKING:OFF
SIG = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_SIGNAL.FIRST_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
DO while sig <> 0
$CHECKING:OFF
M = _MEMGET(PARS__QB64__EMPTY_MEM, SIG + _OFFSET(OBJ_SIGNAL_NODE.SIGNAL_NAME, TYPE), MEM_STRING) 
$CHECKING:ON
  if MEM_get_str$(m) = n$ then
    OBJ_signal_private_connect& = OBJ_signal_private_attach_to_signal&(this, sig, pro, dat)
    exit function
  end if
$CHECKING:OFF
SIG = _MEMGET(PARS__QB64__EMPTY_MEM, SIG + _OFFSET(OBJ_SIGNAL_NODE.NEXT_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
loop
$CHECKING:ON

END FUNCTION

FUNCTION OBJ_signal_private_connect_to_s_w_i& (this as _OFFSET, id as _UNSIGNED LONG, pro as _OFFSET, dat as _OFFSET)
$CHECKING:OFF
DIM sig as _OFFSET, m as MEM_string
$CHECKING:OFF
SIG = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_SIGNAL.FIRST_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
DO while sig <> 0
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, SIG + _OFFSET(OBJ_SIGNAL_NODE.ID, TYPE), LONG)  = ID THEN
$CHECKING:ON
    OBJ_signal_private_connect_to_s_w_i& = OBJ_signal_private_attach_to_signal&(this, sig, pro, dat)
    exit function
  end if
$CHECKING:OFF
SIG = _MEMGET(PARS__QB64__EMPTY_MEM, SIG + _OFFSET(OBJ_SIGNAL_NODE.NEXT_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
loop
$CHECKING:ON

END FUNCTION










FUNCTION OBJ_signal_private_attach_to_signal& (this as _OFFSET, sig as _OFFSET, pro as _OFFSET, dat as _OFFSET)
$CHECKING:OFF
DIM new_connect AS _OFFSET
new_connect = MEM_MALLOC%&(LEN(OBJ_signal_connection_node, TYPE))
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, NEW_CONNECT+ _OFFSET(OBJ_SIGNAL_CONNECTION_NODE.NOTIFY_PROC, TYPE),  PRO AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, NEW_CONNECT+ _OFFSET(OBJ_SIGNAL_CONNECTION_NODE.ID, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_SIGNAL.NEXT_CONNECTION_ID, TYPE), LONG)  AS LONG
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, NEW_CONNECT+ _OFFSET(OBJ_SIGNAL_CONNECTION_NODE.DAT, TYPE),  DAT
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, NEW_CONNECT+ _OFFSET(OBJ_SIGNAL_CONNECTION_NODE.NEXT_CONNECTION, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, SIG + _OFFSET(OBJ_SIGNAL_NODE.FIRST_CONNECTION, TYPE), _OFFSET)  AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, SIG+ _OFFSET(OBJ_SIGNAL_NODE.FIRST_CONNECTION, TYPE),  NEW_CONNECT
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(OBJ_SIGNAL.NEXT_CONNECTION_ID, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_SIGNAL.NEXT_CONNECTION_ID, TYPE), LONG)  + 1 AS LONG
$CHECKING:ON
$CHECKING:OFF
OBJ_SIGNAL_PRIVATE_ATTACH_TO_SIGNAL& = _MEMGET(PARS__QB64__EMPTY_MEM, NEW_CONNECT + _OFFSET(OBJ_SIGNAL_CONNECTION_NODE.ID, TYPE), LONG) 
$CHECKING:ON
$CHECKING:ON

END FUNCTION


FUNCTION OBJ_signal_private_add_new_signal& (this as _OFFSET, n$)
DIM sig as _OFFSET, m as MEM_string, last as _OFFSET
sig = MEM_MALLOC%&(LEN(OBJ_signal, TYPE))
MEM_put_str m, n$
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, SIG+ _OFFSET(OBJ_SIGNAL_NODE.SIGNAL_NAME, TYPE),  M
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, SIG+ _OFFSET(OBJ_SIGNAL_NODE.FIRST_CONNECTION, TYPE),  0 AS LONG
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(OBJ_SIGNAL.NEXT_SIGNAL_ID, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_SIGNAL.NEXT_SIGNAL_ID, TYPE), LONG)  + 1 AS LONG
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, SIG+ _OFFSET(OBJ_SIGNAL_NODE.ID, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_SIGNAL.NEXT_SIGNAL_ID, TYPE), LONG)  AS LONG
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, SIG+ _OFFSET(OBJ_SIGNAL_NODE.NEXT_SIGNAL, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_SIGNAL.FIRST_SIGNAL, TYPE), _OFFSET)  AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(OBJ_SIGNAL.FIRST_SIGNAL, TYPE),  SIG
$CHECKING:ON
$CHECKING:OFF
OBJ_SIGNAL_PRIVATE_ADD_NEW_SIGNAL& = _MEMGET(PARS__QB64__EMPTY_MEM, SIG + _OFFSET(OBJ_SIGNAL_NODE.ID, TYPE), LONG) 
$CHECKING:ON

END FUNCTION

SUB OBJ_signal_private_emit (this as _OFFSET, n$)
$CHECKING:OFF
DIM of as _OFFSET, m as MEM_string
DIM off2 AS _OFFSET, pro as _OFFSET
$CHECKING:OFF
OF = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(OBJ_SIGNAL.FIRST_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
DO while of <> 0
$CHECKING:OFF
M = _MEMGET(PARS__QB64__EMPTY_MEM, OF + _OFFSET(OBJ_SIGNAL_NODE.SIGNAL_NAME, TYPE), MEM_STRING) 
$CHECKING:ON
  if MEM_get_str$(m) = n$ then
DEBUG_PRINT  "Emitting signal" + n$
    
$CHECKING:OFF
OFF2 = _MEMGET(PARS__QB64__EMPTY_MEM, OF + _OFFSET(OBJ_SIGNAL_NODE.FIRST_CONNECTION, TYPE), _OFFSET) 
$CHECKING:ON
    DO WHILE off2 <> 0
$CHECKING:OFF
C__OFFSET__OFFSET  _MEMGET(PARS__QB64__EMPTY_MEM, OFF2 + _OFFSET(OBJ_SIGNAL_CONNECTION_NODE.NOTIFY_PROC, TYPE), _OFFSET) , THIS, _MEMGET(PARS__QB64__EMPTY_MEM, OFF2 + _OFFSET(OBJ_SIGNAL_CONNECTION_NODE.DAT, TYPE), _OFFSET) 
$CHECKING:ON
$CHECKING:OFF
OFF2 = _MEMGET(PARS__QB64__EMPTY_MEM, OFF2 + _OFFSET(OBJ_SIGNAL_CONNECTION_NODE.NEXT_CONNECTION, TYPE), _OFFSET) 
$CHECKING:ON
    loop 
    EXIT SUB
  end if
$CHECKING:OFF
OF = _MEMGET(PARS__QB64__EMPTY_MEM, OF + _OFFSET(OBJ_SIGNAL_NODE.NEXT_SIGNAL, TYPE), _OFFSET) 
$CHECKING:ON
LOOP 
$CHECKING:ON


END SUB








FUNCTION GUI_EVENT_INTERFACE_get_type& ()
  STATIC itype AS LONG
  DIM i as OBJ_type_interface
  if itype = 0 then
    i.size = LEN(GUI_event_interface, TYPE)
    itype = OBJ_type_register_interface&(i)
  end if
  GUI_EVENT_INTERFACE_get_type& = itype

END FUNCTION

FUNCTION GUI_IS_INSTANCE_OF_GUI_EVENT_IFACE& (this as _OFFSET)
  GUI_IS_INSTANCE_OF_GUI_EVENT_IFACE& = OBJ_is_instance_of_interface&(this, GUI_EVENT_INTERFACE_get_type&)

END FUNCTION





FUNCTION GUI_event_get_type& ()


END FUNCTION

SUB GUI_event_init (this as _OFFSET)


END SUB

SUB GUI_event_destroy (this as _OFFSET)


END SUB



















FUNCTION GUI_element_get_type& ()
  STATIC added
  DIM t as OBJ_type_info
  if added = 0 then
    t.class_size = LEN(GUI_element_class, TYPE)
    t.base_size = LEN(GUI_element, TYPE)
$CHECKING:OFF
    t.init = GUI_ELEMENT_INIT_ptr%&
$CHECKING:ON
$CHECKING:OFF
    t.class_init = GUI_ELEMENT_CLASS_INIT_ptr%&
$CHECKING:ON
$CHECKING:OFF
    t.destroy = GUI_ELEMENT_DESTROY_ptr%&
$CHECKING:ON
    t.parent = OBJ_ref_Object_get_type&
    t.flags = OBJ_TYPE_INFO_FLAG_ABSTRACT
    added = OBJ_type_register_type&(t)
  end if
  GUI_element_get_type& = added

END FUNCTION

SUB GUI_element_init (this as _OFFSET)
  DIM class AS _OFFSET

$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.IMG, TYPE),     GUI_IMAGE_NULL AS LONG
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.PARENT, TYPE),  OBJ_NULL AS _OFFSET
$CHECKING:ON


END SUB

SUB GUI_element_class_init (class as _OFFSET)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.DRW, TYPE),  OBJ_NULL AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.SET_VISIBLE, TYPE),  GUI_ELEMENT_PRIVATE_SET_VISIBLE_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.IS_VISIBLE, TYPE),  GUI_ELEMENT_PRIVATE_IS_VISIBLE_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.SET_ACTIVE, TYPE),  GUI_ELEMENT_PRIVATE_SET_ACTIVE_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.IS_ACTIVE, TYPE),  GUI_ELEMENT_PRIVATE_IS_ACTIVE_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.SET_SIZE, TYPE),  GUI_ELEMENT_PRIVATE_SET_SIZE_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.CREATE_IMAGE, TYPE),  GUI_ELEMENT_PRIVATE_CREATE_IMAGE_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.GET_NAME, TYPE),  GUI_ELEMENT_PRIVATE_GET_NAME_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.SET_NAME, TYPE),  GUI_ELEMENT_PRIVATE_SET_NAME_PTR%& AS _OFFSET
$CHECKING:ON
  
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.GET_IMAGE, TYPE),  GUI_ELEMENT_PRIVATE_GET_IMAGE_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.SET_LOCATION, TYPE),  GUI_ELEMENT_PRIVATE_SET_LOCATION_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.SET_DIMENSION, TYPE),  GUI_ELEMENT_PRIVATE_SET_DIMENSION_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.SET_DIMENSION_D, TYPE),  GUI_ELEMENT_PRIVATE_SET_DIMENSION_D_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.GET_WIDTH, TYPE),  GUI_ELEMENT_PRIVATE_GET_WIDTH_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.GET_HEIGHT, TYPE),  GUI_ELEMENT_PRIVATE_GET_HEIGHT_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.SET_WIDTH, TYPE),  GUI_ELEMENT_PRIVATE_SET_WIDT_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.SET_HEIGHT, TYPE),  GUI_ELEMENT_PRIVATE_SET_HEIGHT_PTR%& AS _OFFSET
$CHECKING:ON
  
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.GET_ROW, TYPE),  GUI_ELEMENT_PRIVATE_GET_ROW_PTR%& AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, CLASS+ _OFFSET(GUI_ELEMENT_CLASS.GET_COL, TYPE),  GUI_ELEMENT_PRIVATE_GET_COL_PTR%& AS _OFFSET
$CHECKING:ON

END SUB

SUB GUI_element_destroy (this as _OFFSET)
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG)  <> -1 THEN
$CHECKING:ON
$CHECKING:OFF
_FREEIMAGE _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG) 
$CHECKING:ON
  end if
  

END SUB

FUNCTION GUI_element_private_get_name$ (this as _OFFSET)
  DIM m as MEM_String
$CHECKING:OFF
M = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.NAM, TYPE), MEM_STRING) 
$CHECKING:ON
  GUI_element_private_get_name$ = MEM_get_str$(m)

END FUNCTION

SUB GUI_element_private_set_name (this as _OFFSET, s as STRING)
  DIM m as MEM_String
$CHECKING:OFF
M = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.NAM, TYPE), MEM_STRING) 
$CHECKING:ON
  MEM_put_str m, s
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.NAM, TYPE),  M
$CHECKING:ON

END SUB



FUNCTION GUI_element_private_get_width& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_PRIVATE_GET_WIDTH& = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.WID, TYPE), LONG) 
$CHECKING:ON

END FUNCTION

FUNCTION GUI_element_private_get_height& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_PRIVATE_GET_HEIGHT& = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.HEI, TYPE), LONG) 
$CHECKING:ON

END FUNCTION

SUB GUI_element_private_set_width (this as _OFFSET, wid as LONG)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.WID, TYPE),  WID
$CHECKING:ON

END SUB

SUB GUI_element_private_set_height (this as _OFFSET, hei as LONG)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.HEI, TYPE),  HEI
$CHECKING:ON

END SUB

SUB GUI_element_private_set_visible (this as _OFFSET, vis AS LONG)
if vis then
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.FLAGS, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.FLAGS, TYPE), LONG)  OR GUI_ELEMENT_FLAG_VISIBLE AS LONG
$CHECKING:ON
else
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.FLAGS, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.FLAGS, TYPE), LONG)  AND NOT GUI_ELEMENT_FLAG_VISIBLE AS LONG
$CHECKING:ON
end if

END SUB

FUNCTION GUI_element_private_is_visible& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_PRIVATE_IS_VISIBLE& = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.FLAGS, TYPE), LONG)  AND GUI_ELEMENT_FLAG_VISIBLE
$CHECKING:ON

END FUNCTION

SUB GUI_element_private_set_active (this as _OFFSET, vis AS LONG)
if vis then
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.FLAGS, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.FLAGS, TYPE), LONG)  OR GUI_ELEMENT_FLAG_ACTIVE AS LONG
$CHECKING:ON
else
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.FLAGS, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.FLAGS, TYPE), LONG)  AND NOT GUI_ELEMENT_FLAG_ACTIVE AS LONG
$CHECKING:ON
end if

END SUB

FUNCTION GUI_element_private_is_active& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_PRIVATE_IS_ACTIVE& = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.FLAGS, TYPE), LONG)  AND GUI_ELEMENT_FLAG_ACTIVE
$CHECKING:ON

END FUNCTION

SUB GUI_element_private_create_image (this as _OFFSET)
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG)  <> -1 THEN
$CHECKING:ON
$CHECKING:OFF
_FREEIMAGE _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG) 
$CHECKING:ON
end if
  
$CHECKING:OFF
I& = _NEWIMAGE(_MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.HEI, TYPE), LONG) , _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.WID, TYPE), LONG) , 0)
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.IMG, TYPE),  I&
$CHECKING:ON

END SUB

FUNCTION GUI_element_private_get_image& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_PRIVATE_GET_IMAGE& = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG) 
$CHECKING:ON

END FUNCTION

SUB GUI_element_private_set_size (this AS _OFFSET, wid as _UNSIGNED LONG, hei AS _UNSIGNED LONG)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.WID, TYPE),  WID
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.HEI, TYPE),  HEI
$CHECKING:ON
GUI_element_create_image this

END SUB

SUB GUI_element_private_set_dimension_d (this AS _OFFSET, d as GUI_dimension)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION, TYPE),  D
$CHECKING:ON
GUI_element_create_image this

END SUB

SUB GUI_element_private_set_parent (this as _OFFSET, parent AS _OFFSET)
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.PARENT, TYPE), _OFFSET)  <> 0 THEN
$CHECKING:ON
$CHECKING:OFF
OBJ_REF_OBJECT_RELEASE_REF _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.PARENT, TYPE), _OFFSET) 
$CHECKING:ON
end if
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.PARENT, TYPE),  OBJ_REF_OBJECT_GET_REF%&(PARENT) AS _OFFSET
$CHECKING:ON

END SUB

SUB GUI_element_private_remove_parent (this as _OFFSET)
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.PARENT, TYPE), _OFFSET)  <> 0 THEN
$CHECKING:ON
$CHECKING:OFF
OBJ_REF_OBJECT_RELEASE_REF _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.PARENT, TYPE), _OFFSET) 
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.PARENT, TYPE),  0 AS _OFFSET
$CHECKING:ON
end if

END SUB

FUNCTION GUI_element_private_get_parent%& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_PRIVATE_GET_PARENT%& = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.PARENT, TYPE), _OFFSET) 
$CHECKING:ON

END FUNCTION


  SUB GUI_element_private_set_location (this as _OFFSET, row as _UNSIGNED LONG, col AS _UNSIGNED LONG)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.ROW, TYPE),  ROW
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.COL, TYPE),  COL
$CHECKING:ON

  END SUB
  
  SUB GUI_element_private_set_dimension (this AS _OFFSET, row as _UNSIGNED LONG, col as _UNSIGNED LONG, wid AS _UNSIGNED LONG, hei AS _UNSIGNED LONG)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.ROW, TYPE),  ROW
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.COL, TYPE),  COL
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.WID, TYPE),  WID
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT.DIMENSION.HEI, TYPE),  HEI
$CHECKING:ON
  GUI_element_create_image this

  END SUB
    
  FUNCTION GUI_element_private_get_row& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_PRIVATE_GET_ROW& = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.ROW, TYPE), LONG) 
$CHECKING:ON

  END FUNCTION

  FUNCTION GUI_element_private_get_col& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_PRIVATE_GET_COL& = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.DIMENSION.COL, TYPE), LONG) 
$CHECKING:ON

  END FUNCTION



FUNCTION GUI_element_container_get_type& ()
STATIC added
DIM t as OBJ_type_info
if added = 0 then
  t.class_size = LEN(GUI_element_container_class, TYPE)
  t.base_size = LEN(GUI_element_container, TYPE)
$CHECKING:OFF
  t.init = GUI_ELEMENT_CONTAINER_INIT_ptr%&
$CHECKING:ON
$CHECKING:OFF
  t.destroy = GUI_ELEMENT_CONTAINER_DESTROY_ptr%&
$CHECKING:ON
  t.parent = GUI_element_Object_get_type&
  added = OBJ_type_register_type&(t)
end if
GUI_element_container_get_type& = added

END FUNCTION

SUB GUI_element_container_init (this as _OFFSET)


END SUB

SUB GUI_element_container_destroy (this as _OFFSET)
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE), _OFFSET)  <> 0 THEN
$CHECKING:ON
  GUI_element_container_remove this
end if

END SUB

SUB GUI_element_container_add (this as _OFFSET, obj as _OFFSET)
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE),  OBJ_REF_OBJECT_GET_REF%&(OBJ) AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_CONTAINER.FLAGS, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.FLAGS, TYPE), LONG)  OR GUI_CONTAINER_FLAG_ADDED_ELEMENT AS LONG
$CHECKING:ON

END SUB

SUB GUI_element_container_remove (this as _OFFSET)
$CHECKING:OFF
OBJ_REF_OBJECT_RELEASE_REF _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE), _OFFSET) 
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE),  0 AS _OFFSET
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_CONTAINER.FLAGS, TYPE),  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.FLAGS, TYPE), LONG)  AND NOT GUI_CONTAINER_FLAG_ADDED_ELEMENT AS LONG
$CHECKING:ON

END SUB

FUNCTION GUI_element_container_get_ele%& (this as _OFFSET)
$CHECKING:OFF
GUI_ELEMENT_CONTAINER_GET_ELE%& = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE), _OFFSET) 
$CHECKING:ON

END FUNCTION
























FUNCTION GUI_element_button_get_type& ()
STATIC added
DIM t as OBJ_type_info
if added = 0 then
  t.base_size = LEN(GUI_element_button, TYPE)
  t.class_size = LEN(GUI_element_button, TYPE)
$CHECKING:OFF
  t.init = GUI_ELEMENT_BUTTON_INIT_ptr%&
$CHECKING:ON
$CHECKING:OFF
  t.destroy = GUI_ELEMENT_BUTTON_DESTROY_ptr%&
$CHECKING:ON
  t.parent = GUI_element_container_get_type&
  added = OBJ_type_register_type&(t)
end if
GUI_element_button_get_type& = added

END FUNCTION

FUNCTION GUI_element_button_new%& ()
GUI_element_button_new%& = GUI_element_button_new_text%&("")

END FUNCTION

FUNCTION GUI_element_button_new_text%& (n$)
DIM this as _OFFSET
this = OBJ_type_allocate_new%&(GUI_element_button_get_type&)
GUI_element_button_set_text this, n$

GUI_element_button_new_text%& = this

END FUNCTION

SUB GUI_element_button_init (this as _OFFSET)
DIM class as _OFFSET

$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_BUTTON.THEME.SEL.F, TYPE),  0 AS _BYTE
$CHECKING:ON
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_BUTTON.THEME.SEL.B, TYPE),  7 AS _BYTE
$CHECKING:ON




END SUB

SUB GUI_element_button_destroy (this as _OFFSET)


END SUB

SUB GUI_element_button_set_text (this as _OFFSET, t$)
DIM m as MEM_string
$CHECKING:OFF
M =  _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_BUTTON.TEXT, TYPE), MEM_STRING) 
$CHECKING:ON
MEM_put_str m, t$
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_BUTTON.TEXT, TYPE),  M
$CHECKING:ON
GUI_element_set_size this, 1, len(t$) + 4


END SUB

SUB GUI_element_button_real_draw (this as _OFFSET)
DIM m as MEM_String
d& = _DEST
$CHECKING:OFF
_DEST _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT.IMG, TYPE), LONG) 
$CHECKING:ON
$CHECKING:OFF
COLOR _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_BUTTON.THEME.SEL.F, TYPE), _BYTE) , _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_BUTTON.THEME.SEL.B, TYPE), _BYTE) 
$CHECKING:ON
$CHECKING:OFF
M = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_BUTTON.TEXT, TYPE), MEM_STRING) 
$CHECKING:ON
PRINT "< "; MEM_get_str$(m); " >";
_DEST d&

END SUB






FUNCTION GUI_element_frame_new%& ()
DIM this as _OFFSET
this = MEM_MALLOC%&(LEN(GUI_element_frame, TYPE))
MEM_MEMSET this, LEN(GUI_element_frame, TYPE), 0
GUI_element_frame_init this

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
M = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_FRAME.NAM, TYPE), MEM_STRING) 
$CHECKING:ON
MEM_free_string m


END SUB







FUNCTION GUI_element_window_new%&()
GUI_element_window_new%& = GUI_element_window_new_s_title%&(25, 80, "")

END FUNCTION


FUNCTION GUI_element_window_new_size%&(row as LONG, col AS LONG)
GUI_element_window_new_size%& = GUI_element_window_new_s_title%&(row, col, "")

END FUNCTION

FUNCTION GUI_element_window_new_s_title%&(row as LONG, col as LONG, title$)
DIM this as _OFFSET
this = MEM_MALLOC%&(LEN(GUI_element_window, TYPE))
MEM_MEMSET this, 0, LEN(GUI_element_window, TYPE)
GUI_element_window_init this
GUI_element_window_set_size this, row, col
GUI_element_window_set_title this, title$
GUI_element_window_new_s_title%& = this

END FUNCTION

SUB GUI_element_window_init (this as _OFFSET)



END SUB

SUB GUI_element_window_screen (this as _OFFSET)

SCREEN GUI_element_get_image&(this)

END SUB

SUB GUI_element_window_set_size (this as _OFFSET, row, col)
GUI_element_set_size this, row, col

END SUB

SUB GUI_element_window_set_title (this as _OFFSET, t$)
DIM m as MEM_String
$CHECKING:OFF
M = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_WINDOW.TITLE, TYPE), MEM_STRING) 
$CHECKING:ON
MEM_put_str m, t$
$CHECKING:OFF
_MEMPUT PARS__QB64__EMPTY_MEM, THIS+ _OFFSET(GUI_ELEMENT_WINDOW.TITLE, TYPE),  M
$CHECKING:ON

END SUB

SUB GUI_element_window_draw (this as _OFFSET)
DIM m as MEM_String

$CHECKING:OFF
M = _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_WINDOW.TITLE, TYPE), MEM_STRING) 
$CHECKING:ON
  t$ = MEM_get_str$(m)
  _TITLE t$
$CHECKING:OFF
IF _MEMGET(PARS__QB64__EMPTY_MEM, THIS + _OFFSET(GUI_ELEMENT_CONTAINER.ELEMENT, TYPE), _OFFSET)  <> 0 THEN
$CHECKING:ON
    DIM o as _OFFSET
    
    
    
    
  end if


END SUB

SUB GUI_element_window_delete (this as _OFFSET)
GUI_element_window_clear this
MEM_FREE this

END SUB

SUB GUI_element_window_clear (this as _OFFSET)


END SUB



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
  
FUNCTION OBJ_REF_OBJECT_get_ref%&(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(OBJ_REF_OBJECT_class.get_ref, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
OBJ_REF_OBJECT_get_ref%& = fc__OFFSET__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

SUB OBJ_REF_OBJECT_release_ref(A AS _OFFSET)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(OBJ_REF_OBJECT_class.release_ref, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET pro,A
END IF
$CHECKING:ON
END SUB

SUB OBJ_SIGNAL_disconnect_signal(A AS _OFFSET, B AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(OBJ_SIGNAL_class.disconnect_signal, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG pro,A,B
END IF
$CHECKING:ON
END SUB

SUB OBJ_SIGNAL_disconnect_connection(A AS _OFFSET, B AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(OBJ_SIGNAL_class.disconnect_connection, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG pro,A,B
END IF
$CHECKING:ON
END SUB

FUNCTION OBJ_SIGNAL_get_signal_id&(A AS _OFFSET, B AS  STRING)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(OBJ_SIGNAL_class.get_signal_id, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
OBJ_SIGNAL_get_signal_id& = fc_LONG__OFFSET_STRING (pro,A,B)
END IF
$CHECKING:ON
END SUB

FUNCTION OBJ_SIGNAL_connect_to_signal&(A AS _OFFSET, B AS  STRING, C AS  _OFFSET, D AS  _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(OBJ_SIGNAL_class.connect_to_signal, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
OBJ_SIGNAL_connect_to_signal& = fc_LONG__OFFSET_STRING__OFFSET__OFFSET (pro,A,B,C,D)
END IF
$CHECKING:ON
END SUB

FUNCTION OBJ_SIGNAL_connect_to_signal_with_id&(A AS _OFFSET, B AS  LONG, C AS  _OFFSET, D AS  _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(OBJ_SIGNAL_class.connect_to_signal_with_id, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
OBJ_SIGNAL_connect_to_signal_with_id& = fc_LONG__OFFSET_LONG__OFFSET__OFFSET (pro,A,B,C,D)
END IF
$CHECKING:ON
END SUB

FUNCTION OBJ_SIGNAL_add_new_signal&(A AS _OFFSET, B AS  STRING)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(OBJ_SIGNAL_class.add_new_signal, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
OBJ_SIGNAL_add_new_signal& = fc_LONG__OFFSET_STRING (pro,A,B)
END IF
$CHECKING:ON
END SUB

SUB OBJ_SIGNAL_emit(A AS _OFFSET, B AS  STRING)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(OBJ_SIGNAL_class.emit, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_STRING pro,A,B
END IF
$CHECKING:ON
END SUB

SUB GUI_EVENT_INTERFACE_proc1(A AS _OFFSET)
DIM iface AS _OFFSET, pro as _OFFSET: iface = OBJ_Object_get_interface%&(A, GUI_EVENT_INTERFACE_get_type&)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, iface + _OFFSET(GUI_EVENT_INTERFACE.proc1, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET pro,A
END IF
$CHECKING:ON
END SUB

SUB GUI_EVENT_INTERFACE_proc2(A AS _OFFSET, B AS  _OFFSET)
DIM iface AS _OFFSET, pro as _OFFSET: iface = OBJ_Object_get_interface%&(A, GUI_EVENT_INTERFACE_get_type&)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, iface + _OFFSET(GUI_EVENT_INTERFACE.proc2, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET__OFFSET pro,A,B
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_EVENT_INTERFACE_proc3&(A AS _OFFSET, B AS  LONG)
DIM iface AS _OFFSET, pro as _OFFSET: iface = OBJ_Object_get_interface%&(A, GUI_EVENT_INTERFACE_get_type&)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, iface + _OFFSET(GUI_EVENT_INTERFACE.proc3, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_EVENT_INTERFACE_proc3& = fc_LONG__OFFSET_LONG (pro,A,B)
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_drw(A AS _OFFSET)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.drw, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET pro,A
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_create_image(A AS _OFFSET)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.create_image, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET pro,A
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_visible(A AS _OFFSET, B AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_visible, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG pro,A,B
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_ELEMENT_is_visible&(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.is_visible, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_ELEMENT_is_visible& = fc_LONG__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_active(A AS _OFFSET, B AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_active, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG pro,A,B
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_ELEMENT_is_active&(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.is_active, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_ELEMENT_is_active& = fc_LONG__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_can_focus(A AS _OFFSET, B AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_can_focus, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG pro,A,B
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_ELEMENT_get_can_focus&(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.get_can_focus, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_ELEMENT_get_can_focus& = fc_LONG__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_size(A AS _OFFSET, B AS  LONG, C AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_size, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG_LONG pro,A,B,C
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_ELEMENT_get_image&(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.get_image, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_ELEMENT_get_image& = fc_LONG__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_ELEMENT_get_parent%&(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.get_parent, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_ELEMENT_get_parent%& = fc__OFFSET__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_parent(A AS _OFFSET, B AS  _OFFSET)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_parent, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET__OFFSET pro,A,B
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_name(A AS _OFFSET, B AS  STRING)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_name, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_STRING pro,A,B
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_ELEMENT_get_name$(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.get_name, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_ELEMENT_get_name$ = fc_STRING__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_location(A AS _OFFSET, B AS  LONG, C AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_location, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG_LONG pro,A,B,C
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_dimension(A AS _OFFSET, B AS  LONG, C AS  LONG, D AS  LONG, E AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_dimension, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG_LONG_LONG_LONG pro,A,B,C,D,E
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_dimension_d(A AS _OFFSET, B AS  GUI_DIMENSION)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_dimension_d, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_GUI_DIMENSION pro,A,B
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_width(A AS _OFFSET, B AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_width, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG pro,A,B
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_ELEMENT_get_width&(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.get_width, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_ELEMENT_get_width& = fc_LONG__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_height(A AS _OFFSET, B AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_height, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG pro,A,B
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_ELEMENT_get_height&(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.get_height, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_ELEMENT_get_height& = fc_LONG__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_row(A AS _OFFSET, B AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_row, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG pro,A,B
END IF
$CHECKING:ON
END SUB

SUB GUI_ELEMENT_set_col(A AS _OFFSET, B AS  LONG)
DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.set_col, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
  c__OFFSET_LONG pro,A,B
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_ELEMENT_get_row&(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.get_row, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_ELEMENT_get_row& = fc_LONG__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

FUNCTION GUI_ELEMENT_get_col&(A AS _OFFSET)
DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)
$CHECKING:OFF
pro = _MEMGET(PARS__QB64__EMPTY_MEM, class + _OFFSET(GUI_ELEMENT_class.get_col, TYPE), _OFFSET)
IF pro <> OBJ_NULL THEN
GUI_ELEMENT_get_col& = fc_LONG__OFFSET (pro,A)
END IF
$CHECKING:ON
END SUB

DECLARE CUSTOMTYPE LIBRARY "oop_ex_OUTPUT"
  FUNCTION MEM_FREE_ptr%& ()
  FUNCTION MEM_MEMCPY_ptr%& ()
  FUNCTION MEM_MEMSET_ptr%& ()
  FUNCTION MEM_MEMMOVE_ptr%& ()
  FUNCTION TEST_SIGNAL1_ptr%& ()
  FUNCTION MEM_PUT_STR_ptr%& ()
  FUNCTION MEM_PUT_STR_ARRAY_ptr%& ()
  FUNCTION MEM_ALLOCATE_ARRAY_ptr%& ()
  FUNCTION MEM_REALLOCATE_ARRAY_ptr%& ()
  FUNCTION MEM_ALLOCATE_STRING_ARRAY_ptr%& ()
  FUNCTION MEM_FREE_STRING_ARRAY_ptr%& ()
  FUNCTION MEM_FREE_ARRAY_ptr%& ()
  FUNCTION MEM_FREE_STRING_ptr%& ()
  FUNCTION OBJ_OBJECT_DESTROY_ptr%& ()
  FUNCTION OBJ_REF_OBJECT_INIT_ptr%& ()
  FUNCTION OBJ_REF_OBJECT_CLASS_INIT_ptr%& ()
  FUNCTION OBJ_REF_OBJECT_PRIVATE_RELEASE_REF_ptr%& ()
  FUNCTION OBJ_REF_OBJECT_DESTROY_ptr%& ()
  FUNCTION OBJ_SIGNAL_INIT_ptr%& ()
  FUNCTION OBJ_SIGNAL_INIT_CLASS_ptr%& ()
  FUNCTION OBJ_SIGNAL_DESTROY_ptr%& ()
  FUNCTION OBJ_SIGNAL_CLEAR_SIGNALS_ptr%& ()
  FUNCTION OBJ_SIGNAL_PRIVATE_DISCONNECT_SIGNAL_ptr%& ()
  FUNCTION OBJ_SIGNAL_PRIVATE_DISCONNECT_CON_ptr%& ()
  FUNCTION OBJ_SIGNAL_PRIVATE_EMIT_ptr%& ()
  FUNCTION GUI_EVENT_INIT_ptr%& ()
  FUNCTION GUI_EVENT_DESTROY_ptr%& ()
  FUNCTION GUI_ELEMENT_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_CLASS_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_DESTROY_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_SET_NAME_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_SET_WIDTH_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_SET_HEIGHT_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_SET_VISIBLE_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_SET_ACTIVE_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_CREATE_IMAGE_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_SET_SIZE_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_SET_DIMENSION_D_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_SET_PARENT_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_REMOVE_PARENT_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_SET_LOCATION_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_SET_DIMENSION_ptr%& ()
  FUNCTION GUI_ELEMENT_CONTAINER_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_CONTAINER_DESTROY_ptr%& ()
  FUNCTION GUI_ELEMENT_CONTAINER_ADD_ptr%& ()
  FUNCTION GUI_ELEMENT_CONTAINER_REMOVE_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_DESTROY_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_SET_TEXT_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_REAL_DRAW_ptr%& ()
  FUNCTION GUI_ELEMENT_FRAME_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_FRAME_DELETE_ptr%& ()
  FUNCTION GUI_ELEMENT_FRAME_CLEAR_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_INIT_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_SCREEN_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_SET_SIZE_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_SET_TITLE_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_DRAW_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_DELETE_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_CLEAR_ptr%& ()
  FUNCTION GUI_PUT_IMAGE_ptr%& ()
  FUNCTION OBJ_REF_OBJECT_RELEASE_REF_ptr%& ()
  FUNCTION OBJ_SIGNAL_DISCONNECT_SIGNAL_ptr%& ()
  FUNCTION OBJ_SIGNAL_DISCONNECT_CONNECTION_ptr%& ()
  FUNCTION OBJ_SIGNAL_EMIT_ptr%& ()
  FUNCTION GUI_EVENT_INTERFACE_PROC1_ptr%& ()
  FUNCTION GUI_EVENT_INTERFACE_PROC2_ptr%& ()
  FUNCTION GUI_ELEMENT_DRW_ptr%& ()
  FUNCTION GUI_ELEMENT_CREATE_IMAGE_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_VISIBLE_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_ACTIVE_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_CAN_FOCUS_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_SIZE_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_PARENT_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_NAME_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_LOCATION_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_DIMENSION_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_DIMENSION_D_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_WIDTH_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_HEIGHT_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_ROW_ptr%& ()
  FUNCTION GUI_ELEMENT_SET_COL_ptr%& ()
  FUNCTION MEM_MALLOC_ptr%& ()
  FUNCTION MEM_REALLOC_ptr%& ()
  FUNCTION MEM_GET_STR_ptr%& ()
  FUNCTION MEM_GET_STR_ARRAY_ptr%& ()
  FUNCTION MEM_INT_FROM_OFF_ptr%& ()
  FUNCTION MEM_LONG_FROM_OFF_ptr%& ()
  FUNCTION MEM_BYTE_FROM_OFF_ptr%& ()
  FUNCTION MEM_INT64_FROM_OFF_ptr%& ()
  FUNCTION MEM_MALLOC0_ptr%& ()
  FUNCTION OBJ_IS_INSTANCE_OF_ptr%& ()
  FUNCTION OBJ_IS_INSTANCE_OF_INTERFACE_ptr%& ()
  FUNCTION OBJ_TYPE_REGISTER_TYPE_ptr%& ()
  FUNCTION OBJ_TYPE_REGISTER_INTERFACE_ptr%& ()
  FUNCTION OBJ_TYPE_GET_CLASS_SIZE_ptr%& ()
  FUNCTION OBJ_TYPE_GET_BASE_SIZE_ptr%& ()
  FUNCTION OBJ_TYPE_GET_INIT_ptr%& ()
  FUNCTION OBJ_TYPE_GET_DESTROY_ptr%& ()
  FUNCTION OBJ_TYPE_GET_PARENT_ptr%& ()
  FUNCTION OBJ_TYPE_ALLOCATE_NEW_ptr%& ()
  FUNCTION OBJ_TYPE_ADD_INTERFACE_TO_CLASS_ptr%& ()
  FUNCTION OBJ_TYPE_GET_INTERFACE_ptr%& ()
  FUNCTION OBJ_TYPE_GET_CLASS_ptr%& ()
  FUNCTION OBJ_TYPE_GET_PARENT_CLASS_ptr%& ()
  FUNCTION OBJ_OBJECT_GET_TYPE_ptr%& ()
  FUNCTION OBJ_OBJECT_GET_CLASS_ptr%& ()
  FUNCTION OBJ_OBJECT_GET_INTERFACE_ptr%& ()
  FUNCTION OBJ_OBJECT_GET_PARENT_CLASS_ptr%& ()
  FUNCTION OBJ_CLASS_GET_TYPE_ptr%& ()
  FUNCTION OBJ_REF_OBJECT_GET_TYPE_ptr%& ()
  FUNCTION OBJ_REF_OBJECT_PRIVATE_GET_REF_ptr%& ()
  FUNCTION OBJ_SIGNAL_GET_TYPE_ptr%& ()
  FUNCTION OBJ_SIGNAL_PRIVATE_GET_SIGNAL_ID_ptr%& ()
  FUNCTION OBJ_SIGNAL_PRIVATE_CONNECT_TO_SIGNAL_ptr%& ()
  FUNCTION OBJ_SIGNAL_PRIVATE_CONNECT_TO_S_W_I_ptr%& ()
  FUNCTION OBJ_SIGNAL_PRIVATE_ATTACH_TO_SIGNAL_ptr%& ()
  FUNCTION OBJ_SIGNAL_PRIVATE_ADD_NEW_SIGNAL_ptr%& ()
  FUNCTION GUI_EVENT_INTERFACE_GET_TYPE_ptr%& ()
  FUNCTION GUI_IS_INSTANCE_OF_GUI_EVENT_IFACE_ptr%& ()
  FUNCTION GUI_EVENT_GET_TYPE_ptr%& ()
  FUNCTION GUI_ELEMENT_GET_TYPE_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_GET_NAME_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_GET_WIDTH_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_GET_HEIGHT_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_IS_VISIBLE_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_IS_ACTIVE_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_GET_IMAGE_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_GET_PARENT_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_GET_ROW_ptr%& ()
  FUNCTION GUI_ELEMENT_PRIVATE_GET_COL_ptr%& ()
  FUNCTION GUI_ELEMENT_CONTAINER_GET_TYPE_ptr%& ()
  FUNCTION GUI_ELEMENT_CONTAINER_GET_ELE_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_GET_TYPE_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_NEW_ptr%& ()
  FUNCTION GUI_ELEMENT_BUTTON_NEW_TEXT_ptr%& ()
  FUNCTION GUI_ELEMENT_FRAME_NEW_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_NEW_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_NEW_SIZE_ptr%& ()
  FUNCTION GUI_ELEMENT_WINDOW_NEW_S_TITLE_ptr%& ()
  FUNCTION OBJ_REF_OBJECT_GET_REF_ptr%& ()
  FUNCTION OBJ_SIGNAL_GET_SIGNAL_ID_ptr%& ()
  FUNCTION OBJ_SIGNAL_CONNECT_TO_SIGNAL_ptr%& ()
  FUNCTION OBJ_SIGNAL_CONNECT_TO_SIGNAL_WITH_ID_ptr%& ()
  FUNCTION OBJ_SIGNAL_ADD_NEW_SIGNAL_ptr%& ()
  FUNCTION GUI_EVENT_INTERFACE_PROC3_ptr%& ()
  FUNCTION GUI_ELEMENT_IS_VISIBLE_ptr%& ()
  FUNCTION GUI_ELEMENT_IS_ACTIVE_ptr%& ()
  FUNCTION GUI_ELEMENT_GET_CAN_FOCUS_ptr%& ()
  FUNCTION GUI_ELEMENT_GET_IMAGE_ptr%& ()
  FUNCTION GUI_ELEMENT_GET_PARENT_ptr%& ()
  FUNCTION GUI_ELEMENT_GET_NAME_ptr%& ()
  FUNCTION GUI_ELEMENT_GET_WIDTH_ptr%& ()
  FUNCTION GUI_ELEMENT_GET_HEIGHT_ptr%& ()
  FUNCTION GUI_ELEMENT_GET_ROW_ptr%& ()
  FUNCTION GUI_ELEMENT_GET_COL_ptr%& ()
  SUB c__OFFSET( BYVAL va AS _OFFSET, A AS _OFFSET)
  SUB c__OFFSET__OFFSET_LONG( BYVAL va AS _OFFSET, A AS _OFFSET, B AS _OFFSET, C AS LONG)
  SUB c__OFFSET_LONG_LONG( BYVAL va AS _OFFSET, A AS _OFFSET, B AS LONG, C AS LONG)
  SUB c__OFFSET__OFFSET( BYVAL va AS _OFFSET, A AS _OFFSET, B AS _OFFSET)
  SUB c_MEM_STRING_STRING( BYVAL va AS _OFFSET, A AS MEM_STRING, B AS STRING)
  SUB c_MEM_ARRAY_SINGLE_STRING( BYVAL va AS _OFFSET, A AS MEM_ARRAY, B AS SINGLE, C AS STRING)
  SUB c_MEM_ARRAY_SINGLE_SINGLE( BYVAL va AS _OFFSET, A AS MEM_ARRAY, B AS SINGLE, C AS SINGLE)
  SUB c_MEM_ARRAY_SINGLE( BYVAL va AS _OFFSET, A AS MEM_ARRAY, B AS SINGLE)
  SUB c_MEM_ARRAY( BYVAL va AS _OFFSET, A AS MEM_ARRAY)
  SUB c_MEM_STRING( BYVAL va AS _OFFSET, A AS MEM_STRING)
  SUB c__OFFSET_LONG( BYVAL va AS _OFFSET, A AS _OFFSET, B AS LONG)
  SUB c__OFFSET_STRING( BYVAL va AS _OFFSET, A AS _OFFSET, B AS STRING)
  SUB c__OFFSET_GUI_DIMENSION( BYVAL va AS _OFFSET, A AS _OFFSET, B AS GUI_DIMENSION)
  SUB c__OFFSET_LONG_LONG_LONG_LONG( BYVAL va AS _OFFSET, A AS _OFFSET, B AS LONG, C AS LONG, D AS LONG, E AS LONG)
  SUB c__OFFSET_SINGLE_SINGLE( BYVAL va AS _OFFSET, A AS _OFFSET, B AS SINGLE, C AS SINGLE)
  SUB c_LONG_LONG_LONG_LONG( BYVAL va AS _OFFSET, A AS LONG, B AS LONG, C AS LONG, D AS LONG)
  SUB c_SINGLE( BYVAL va AS _OFFSET, A AS SINGLE)
  SUB c_SINGLE_SINGLE( BYVAL va AS _OFFSET, A AS SINGLE, B AS SINGLE)
  SUB c_SINGLE_SINGLE_SINGLE( BYVAL va AS _OFFSET, A AS SINGLE, B AS SINGLE, C AS SINGLE)
  SUB c_SINGLE_SINGLE_SINGLE_SINGLE_SINGLE( BYVAL va AS _OFFSET, A AS SINGLE, B AS SINGLE, C AS SINGLE, D AS SINGLE, E AS SINGLE)
  FUNCTION fc__OFFSET_LONG%&( BYVAL va AS _OFFSET, A AS LONG)
  FUNCTION fc__OFFSET__OFFSET_LONG%&( BYVAL va AS _OFFSET, A AS _OFFSET, B AS LONG)
  FUNCTION fc_STRING_MEM_STRING$( BYVAL va AS _OFFSET, A AS MEM_STRING)
  FUNCTION fc_STRING_MEM_ARRAY_SINGLE$( BYVAL va AS _OFFSET, A AS MEM_ARRAY, B AS SINGLE)
  FUNCTION fc_INTEGER__OFFSET%( BYVAL va AS _OFFSET, A AS _OFFSET)
  FUNCTION fc_LONG__OFFSET&( BYVAL va AS _OFFSET, A AS _OFFSET)
  FUNCTION fc__BYTE__OFFSET%%( BYVAL va AS _OFFSET, A AS _OFFSET)
  FUNCTION fc__INTEGER64__OFFSET&&( BYVAL va AS _OFFSET, A AS _OFFSET)
  FUNCTION fc_SINGLE_LONG!( BYVAL va AS _OFFSET, A AS LONG)
  FUNCTION fc_LONG__OFFSET_LONG&( BYVAL va AS _OFFSET, A AS _OFFSET, B AS LONG)
  FUNCTION fc_LONG_OBJ_TYPE_INFO&( BYVAL va AS _OFFSET, A AS OBJ_TYPE_INFO)
  FUNCTION fc_LONG_OBJ_TYPE_INTERFACE&( BYVAL va AS _OFFSET, A AS OBJ_TYPE_INTERFACE)
  FUNCTION fc_LONG_LONG&( BYVAL va AS _OFFSET, A AS LONG)
  FUNCTION fc_LONG_SINGLE&( BYVAL va AS _OFFSET, A AS SINGLE)
  FUNCTION fc__OFFSET__OFFSET%&( BYVAL va AS _OFFSET, A AS _OFFSET)
  FUNCTION fc_LONG__OFFSET_STRING&( BYVAL va AS _OFFSET, A AS _OFFSET, B AS STRING)
  FUNCTION fc_LONG__OFFSET_STRING__OFFSET__OFFSET&( BYVAL va AS _OFFSET, A AS _OFFSET, B AS STRING, C AS _OFFSET, D AS _OFFSET)
  FUNCTION fc_LONG__OFFSET_LONG__OFFSET__OFFSET&( BYVAL va AS _OFFSET, A AS _OFFSET, B AS LONG, C AS _OFFSET, D AS _OFFSET)
  FUNCTION fc_LONG__OFFSET__OFFSET__OFFSET__OFFSET&( BYVAL va AS _OFFSET, A AS _OFFSET, B AS _OFFSET, C AS _OFFSET, D AS _OFFSET)
  FUNCTION fc_STRING__OFFSET$( BYVAL va AS _OFFSET, A AS _OFFSET)
  FUNCTION fc__OFFSET_SINGLE%&( BYVAL va AS _OFFSET, A AS SINGLE)
  FUNCTION fc__OFFSET_STRING%&( BYVAL va AS _OFFSET, A AS STRING)
  FUNCTION fc__OFFSET_LONG_LONG%&( BYVAL va AS _OFFSET, A AS LONG, B AS LONG)
  FUNCTION fc__OFFSET_LONG_LONG_STRING%&( BYVAL va AS _OFFSET, A AS LONG, B AS LONG, C AS STRING)
  FUNCTION fc_LONG_SINGLE_SINGLE&( BYVAL va AS _OFFSET, A AS SINGLE, B AS SINGLE)
  FUNCTION fc_LONG_SINGLE_SINGLE_SINGLE_SINGLE&( BYVAL va AS _OFFSET, A AS SINGLE, B AS SINGLE, C AS SINGLE, D AS SINGLE)
  FUNCTION fc_STRING_SINGLE$( BYVAL va AS _OFFSET, A AS SINGLE)
END DECLARE
SUB DEBUG_PRINT (s$): d& = _DEST: _DEST _CONSOLE: PRINT s$: _DEST d&: END SUB
