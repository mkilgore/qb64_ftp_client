
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

DIM SHARED MEM_SIZEOF_OFFSET, MEM_SIZEOF_MEM_STRING, MEM_SIZEOF_MEM_ARRAY

'CONST MEM_SIZEOF_OFFSET = 4
if instr(_OS$, "[32BIT]") then
  MEM_SIZEOF_OFFSET = 4
else
  MEM_SIZEOF_OFFSET = 8
end if

MEM_SIZEOF_MEM_STRING = MEM_SIZEOF_OFFSET + 4 + 4 + 1
TYPE MEM_String
  mem as _OFFSET
  length AS LONG
  allocated AS LONG
  is_allocated AS _BYTE
END TYPE

MEM_SIZEOF_MEM_ARRAY = MEM_SIZEOF_OFFSET + 4 + 4 + 1 + 2 + 4
TYPE MEM_Array
  mem AS _OFFSET
  length AS LONG
  allocated AS LONG
  is_allocated AS _BYTE
  element_size AS INTEGER
  last_element AS LONG
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

DIM SHARED SIZEOF_MACRO, SIZEOF_DEFINE, SIZEOF_SOURCE_LINE 
DIM SHARED SIZEOF_CONST_TYPE, SIZEOF_MAIN_TYPE_NODE, SIZEOF_SUB_TYPE_NODE
DIM SHARED SIZEOF_SUB_FUNC, SIZEOF_OBJECT, SIZEOF_TRAIT, SIZEOF_DECLARE_LIBRARY
DIM SHARED SIZEOF_SOURCE_COPY


SIZEOF_MACRO = MEM_SIZEOF_MEM_STRING + 4 + MEM_SIZEOF_MEM_ARRAY
TYPE macro
  fnam AS MEM_String
  subfunc AS LONG '1 for SUB, 2 for FUNC
  lines as MEM_Array
END TYPE

SIZEOF_DEFINE = MEM_SIZEOF_MEM_STRING + MEM_SIZEOF_MEM_STRING
TYPE define
  nam AS MEM_String
  value as MEM_String
END TYPE

SIZEOF_SOURCE_LINE = MEM_SIZEOF_MEM_STRING
TYPE source_line
  l AS MEM_String
END TYPE

SIZEOF_CONST_TYPE = MEM_SIZEOF_MEM_STRING * 2
TYPE const_type
  nam   AS MEM_String
  value AS MEM_String
END TYPE

SIZEOF_MAIN_TYPE_NODE = MEM_SIZEOF_MEM_STRING + MEM_SIZEOF_OFFSET + 4 + 4
TYPE main_type_node
  type_nam        AS MEM_String
  first_type_node AS _OFFSET
  members         AS LONG
  full_size       AS LONG
END TYPE

SIZEOF_SUB_TYPE_NODE = MEM_SIZEOF_MEM_STRING + MEM_SIZEOF_OFFSET + 4 + 4
TYPE sub_type_node
  member_nam     AS MEM_String
  next_node      AS _OFFSET
  size           AS LONG
  size_to_member AS LONG
END TYPE

SIZEOF_SUB_FUNC = 4 + MEM_SIZEOF_MEM_STRING + 4 + MEM_SIZEOF_MEM_STRING
TYPE SUB_FUNC
  subfunc AS LONG
  nam     AS MEM_String
  typ     AS LONG
  source  AS MEM_String
END TYPE

SIZEOF_OBJECT = MEM_SIZEOF_MEM_STRING + 4 + MEM_SIZEOF_MEM_ARRAY + 4 + MEM_SIZEOF_MEM_ARRAY * 3
TYPE OBJECT
  nam      AS MEM_String
  abstract AS LONG
  traits   AS MEM_Array
  inherit  AS LONG
  flags    AS MEM_Array
  public   AS MEM_Array
  private  AS MEM_Array
END TYPE

SIZEOF_TRAIT = MEM_SIZEOF_MEM_STRING 
TYPE trait
  nam as MEM_String
END TYPE

SIZEOF_DECLARE_LIBRARY = MEM_SIZEOF_MEM_STRING + MEM_SIZEOF_MEM_ARRAY
TYPE declare_library
  lib       AS MEM_String
  sub_funcs AS MEM_Array
END TYPE

SIZEOF_SOURCE_COPY = MEM_SIZEOF_MEM_ARRAY * 8
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

' Program globals 
DIM SHARED SOURCE_FILE$, SOURCE_DIRECTORY$
DIM SHARED QB64_DIRECTORY$
DIM SHARED OS_SLASH$, OS AS LONG
CONST LNX = 1
CONST WIN = 2
CONST MAC = 3

DIM orig_source AS SOURCE_Copy
REDIM source AS MEM_Array

' Parse command line options
init COMMAND$, orig_source

if SOURCE_FILE$ = "" then SOURCE_FILE$ = file_selection_GUI$

CHDIR SOURCE_FILE$
pre_process QB64_SOURCE_FILE$, source
CHDIR QB64_DIRECTORY$

load_source source, orig_source

handle_objects orig_source

handle_at_commands orig_source



SUB init (c$, src AS SOURCE_Copy)
  IF INSTR(_OS$, "[WINDOWS]") THEN
    OS_slash$ = "\"
    OS = WIN
  ELSEIF INSTR(_OS$, "[MACOSX]") THEN
    OS_slash$ = "/"
    OS = MAC
  ELSEIF INSTR(_OS$, "[LINUX]") THEN
    OS_slash$ = "/"
    OS = LNX
  END IF
  QB64_DIRECTORY$ = SPACE$(1024)
  getcwd QB64_DIRECTORY$, LEN(QB64_DIRECTORY$)
  QB64_DIRECTORY$ = add_slash$(QB64_DIRECTORY$)
  init_source src

  SOURCE_FILE$ = get_file$(c$)
  SOURCE_DIRECTORY$ = add_slash$(get_dir$(c$))

  if OS = WIN then SOURCE_FILE$ = UCASE$(SOURCE_FILE$): SOURCE_DIRECTORY$ = UCASE$(SOURCE_DIRECTORY$)
END SUB


'This SUB handles pre-processing the file ("!!" statements)
'This SUB also handles '$INCLUDE:'ing any files
'When pre-processing is done, the complete processed raw source code
'is contained inside of 'src'
SUB pre_process (file$, src AS MEM_Array)

  STATIC include_once_files AS MEM_Array
  STATIC define_list        AS MEM_Array
  STATIC macro_list         AS MEM_Array
  STATIC file_recurse       AS LONG

  current_CD$ = SPACE$(1024)
  getcwd current_CD$, LEN(current_CD$)
  current_CD$ = add_slash$(current_CD$)

  'Get a new file number and open our file
  DIM fnum AS LONG
  fnum = FREEFILE
  OPEN file$ FOR INPUT AS #fnum

  DO WHILE NOT EOF(fnum)
    LINE INPUT #fnum, l$
    ul$ = UCASE$(l$)
    
    if left$(ul$, LEN("'$INCLUDE:'")) = "'$INCLUDE:'" then ' Handle including files
      next_file$ = mid$(l$, len("'$INCLUDE:'"))
      next_file$ = left$(l$, len(l$) - 1)
      new_cd$ = add_slash$(get_dir$(next_file$))
      next_filename$ = get_file$(next_file$)
      if OS = LNX OR OS = MAC then
        if left$(new_cd$, 1) <> "/" then
          new_cd$ = current_CD$ + new_cd$
        end if
      else
        if not instr(new_cd$, ":") then
          new_cd$ = current_CD$ + new_cd$
        end if
        'Windows is not case senstiive
        new_cd$ = UCASE$(new_cd$)
        next_filename$ = ucase$(next_filename$)
      end if

      if string_not_in_array(new_cd$ + next_filename$, include_once_files) then
        CHDIR new_cd$
        file_recurse = file_recurse + 1
        pre_process next_filename$, src
        file_recurse = file_recurse - 1
        CHDIR current_CD$
      end if
    end if
   
    if left$(l$, 2) = "!!" then 'Pre-Processor command
      MEM_add_string_to_array current_CD$ + file$, include_once_files
    end if
  LOOP

  CLOSE #fnum

  if file_recurse = 0 then
    MEM_free_string_array include_once_files
    free_define_list
    free_macro_array macro_list
  end if
END SUB


SUB init_source (src AS SOURCE_copy)

END SUB


SUB load_source (source AS MEM_Array, src AS SOURCE_copy)

END SUB


SUB handle_objects (src AS SOURCE_copy)

END SUB


SUB handle_at_commands (src AS SOURCE_copy)

END SUB



FUNCTION file_selection_GUI$ ()
  INPUT "Source code file to preprocess:"; fil$
  file_selection_GUI$ = fil$
END FUNCTION

' General purpose functions

FUNCTION get_dir$(f$)
  split_file_name f$, di$, fi$
  get_dir$ = di$
END FUNCTION

FUNCTION get_file$(f$)
  split_file_name f$, di$, fi$
  get_file$ = fi$
END FUNCTION

SUB split_file_name(f$, di$, fi$)
  di$ = ""
  fi$ = f$
  DO
    di$ = di$ + left$(fi$, instr(fi$, OS_slash$))
    fi$ = mid$(fi$, instr(fi$, OS_slash$) + 1)
  LOOP until instr(fi$, slash$) = 0
END SUB

FUNCTION add_slash$ (d$)
  if right$(d$, 1) <> OS_SLASH$ then
    add_slash$ = d$ + OS_SLASH$
  else
    add_slash$ = d$
  end if
END FUNCTION

FUNCTION string_not_in_array (s$, a as MEM_Array)
FOR x = 1 to a.length
  if MEM_get_str_array$(a, x) = s$ then
    exit function
  end if
NEXT x
string_not_in_array = -1
END FUNCTION


' Define Array
SUB add_define_to_array (a as MEM_Array, s$, v$)
DIM d as define
if a.length = 0 then a.element_size = SIZEOF_DEFINE
increment_array a
MEM_put_str d.nam, s$
MEM_put_str d.value, v$
MEM_put_mem_copy_array a, a.last_element, _OFFSET(d)
END SUB

SUB change_define_in_array (a as MEM_Array, old$, new$)

END SUB

SUB remove_define_from_array (a as MEM_Array, d$)

END SUB

FUNCTION get_define_value_from_array$ (a as MEM_Array, d$)
FOR x = 1 to a.last_element
  $CHECKING:OFF
  if MEM_get_str$(

  $CHECKING:ON
NEXT x
END FUNCTION

SUB free_define_array (a as MEM_Array)
DIM d as define
FOR x = 1 to a.last_element
  $CHECKING:OFF
  d = _MEMGET(MEM_FAKEMEM, a.mem + x * a.element_size, define)
  MEM_free_string d.nam
  MEM_free_string d.value
  $CHECKING:ON
NEXT x
MEM_free_array a
END SUB

' Macro Array

SUB add_macro_to_array (a AS MEM_Array, mnew AS macro)
DIM m as macro
if a.length = 0 then a.element_Size = SIZEOF_MACRO
increment_array a
MEM_put_str m.fnam, MEM_get_Str$(mnew.fnam)
MEM

END SUB

SUB free_macro_array (a as MEM_Array)
DIM m as macro
FOR x = 1 to a.last_element
  $CHECKING:OFF
  m = _MEMGET(MEM_FAKEMEM, a.mem + x * a.element_size, macro)
  MEM_free_string d.fnam
  MEM_free_string_array d.lines
  $CHECKING:ON
NEXT x
MEM_free_array a
END SUB

' MEM handling functions
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

SUB MEM_increment_array (a as MEM_array)
a.last_element = a.last_element + 1
if a.last_element > a.length then
  a.length = a.length + 100
  MEM_reallocate_array a, a.length
end if
END SUB

SUB MEM_put_mem_copy_array (a as MEM_array, array_num, o as _OFFSET)
$CHECKING:OFF
MEM_MEMCPY a.mem + array_number * a.element_size, o, a.element_Size
$CHECKING:ON
END SUB

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
MEM_allocate_array a, number_of_elements, MEM_SIZEOF_MEM_STRING
END SUB

SUB MEM_allocate_define_array (a as MEM_array, number_of_elements)
MEM_allocate_array a, number_of_elements, SIZEOF_DEFINE 
END SUB

SUB MEM_add_string_to_array (a AS MEM_array, s$)
if a.length = 0 then a.element_size = MEM_SIZEOF_MEM_STRING 
increment_array a
MEM_put_str_array a, a.last_element, s$
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
  a.last_element = 0
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
  a.last_element = 0
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

