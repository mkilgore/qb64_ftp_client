
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

'''''NOTE
'Implement "@(_OFFSET, TYPE)" -- Allow ommision of second parameter
'Change "!!endif" to "end if" for syntatical constancy

'Stages:
'

CONST PRO_VERSION$ = ".03"

DECLARE LIBRARY "unistd"
  SUB getcwd(s as STRING, BYVAL l as LONG) 
END DECLARE

TYPE define_type
  value as MEM_string
  replacement as MEM_string
END TYPE

$SCREENHIDE
$CONSOLE

_DEST _CONSOLE

REDIM SHARED source(500) AS STRING 'AS MEM_string, next_line AS LONG
DIM SHARED next_line AS LONG

REDIM SHARED new_source(500) AS STRING
DIM SHARED new_length AS LONG

REDIM SHARED new_CONSTS(500) AS STRING, const_count AS LONG
REDIM SHARED reg_types(100) AS STRING, reg_count(100) AS LONG, reg_total_count AS LONG
REDIM SHARED flag_functions(500) AS STRING, func_count AS LONG

REDIM SHARED defines(500) AS define_type, define_count AS LONG

DIM SHARED line_end$, slash$

REDIM SHARED new_func_vars(500) AS STRING, new_func_types(500) AS STRING, new_func_vars_count AS LONG

REDIM SHARED sub_names(500) AS STRING, sub_args(500) AS STRING, sub_number(500) AS LONG, sub_count AS LONG
REDIM SHARED sub_diff_args AS LONG, diff_arg_list(500) AS STRING

REDIM SHARED func_names(500) AS STRING, func_args(500) AS STRING, func_number(500) AS LONG
REDIM SHARED func_type(500) AS STRING, function_count AS LONG
REDIM SHARED func_diff_args AS LONG, func_diff_arg_list(500) AS STRING, func_diff_arg_type(500) AS STRING

REDIM SHARED included_files(100) AS STRING, included_file_count AS LONG

REDIM SHARED sub_data$, in_sub, in_type, in_declare, in_class_declare, class_nam$
REDIM SHARED in_interface_declare, add_type_to_statement&&, in_checking_off

DIM SHARED var_prefix$, mem_nam$, call_prefix$
DIM SHARED ptrs_file$, call_func_prefix$


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


'UDT
'names
REDIM SHARED last_type AS LONG
REDIM SHARED udt_xname(1000) AS STRING
REDIM SHARED udt_xnext(1000) AS LONG
'elements
REDIM SHARED last_type_element AS LONG
REDIM SHARED udt_ename(1000) AS STRING
REDIM SHARED udt_etype(1000) AS _INTEGER64
REDIM SHARED udt_enext(1000) AS LONG

last_type = last_type + 1
udt_xname(last_type) = "_MEM"
last_type_element = last_type_element +1
udt_xnext(last_type) = last_type_element

udt_ename(last_type_element) = "OFFSET"
udt_etype(last_type_element) = OFFSET_TYPE
last_type_element = last_type_element + 1
udt_enext(last_type_element - 1) = last_type_element

udt_ename(last_type_element) = "SIZE"
udt_etype(last_type_element) = OFFSET_TYPE
last_type_element = last_Type_element + 1
udt_enext(last_type_element - 1) = last_type_element

udt_ename(last_type_element) = "$_LOCK_ID"
udt_etype(last_type_element) = INTEGER64_TYPE 
last_type_element = last_Type_element + 1
udt_enext(last_type_element - 1) = last_type_element

udt_ename(last_type_element) = "$_LOCK_OFFSET"
udt_etype(last_type_element) = OFFSET_TYPE 
last_type_element = last_Type_element + 1
udt_enext(last_type_element - 1) = last_type_element

udt_ename(last_type_element) = "TYPE"
udt_etype(last_type_element) = LONG_TYPE 
last_type_element = last_Type_element + 1
udt_enext(last_type_element - 1) = last_type_element

udt_ename(last_type_element) = "ELEMENTSIZE"
udt_etype(last_type_element) = OFFSET_TYPE 
last_type_element = last_Type_element + 1
udt_enext(last_type_element - 1) = last_type_element





'var_prefix$ = "PARS__"
mem_nam$ = "PARS__QB64__EMPTY_MEM"
call_prefix$ = "c_"
call_func_prefix$ = "fc_"
in_type = 0
in_declare = 0
in_sub = 0
sub_data$ = ""
type_nam$ = ""


line_end$ = CHR$(13) + CHR$(10)

IF INSTR(_OS$, "[WINDOWS]") THEN
  add_define "__OS__", "WINDOWS"
  add_define "__SLASH__", qq$("\")
  slash$ = "\"
ELSEIF INSTR(_OS$, "[MACOSX]") THEN
  add_define "__OS__", "MACOSX"
  add_define "__SLASH__", qq$("/")
  slash$ = "/"
ELSEIF INSTR(_OS$, "[LINUX]") THEN
  add_define "__OS__", "LINUX"
  add_define "__SLASH__", qq$("/")
  slash$ = "/"
END IF

IF INSTR(_OS$, "[32BIT]") THEN
  add_define "__BITS__", "32"
ELSE
  add_define "__BITS__", "64"
END IF

add_define "__DATE__", qq$(DATE$)
add_define "__TIME__", qq$(TIME$)

add_define "__PROV__", PRO_VERSION$


di$ = get_dir$(COMMAND$)
fi$ = get_file$(COMMAND$)

add_define "__FILE__", qq$(fi$)

ex$ = MID$(fi$, INSTR(fi$, ".") + 1)
nam$ = MID$(fi$, 1, INSTR(fi$, ".") - 1)

ptrs_file$ = nam$ + "_OUTPUT"
OPEN nam$ + "_OUTPUT.h" FOR OUTPUT AS #256

CHDIR di$

OPEN nam$ + "_OUTPUT." + ex$ FOR OUTPUT AS #255

load_file fi$

collect_type_information

'print "GOT HERE!"
'print "lines:"; next_line
'INPUT "sleep"; sleep_sleep$

FOR x = 1 TO next_line
  add_type_to_statement&& = 0
  source(x) = replace_with_case$(source(x), "@PROC", "_OFFSET")
  n$ = strip_line$(UCASE$(source(x))) 'MEM_get_str$(source(x)))
  'PRINT "LOOP"
  'print "X="; n$
  'input "sleep"; sleep_sleep$
  s$ = n$
  mod_flag = 0
  in_quote = 0
  DO
    IF INSTR(s$, CHR$(34)) THEN
      c$ = MID$(s$, 1, INSTR(s$, CHR$(34)) - 1)
      s$ = MID$(s$, INSTR(s$, CHR$(34)) + 1)
    ELSE
      c$ = s$
      s$ = ""
    END IF
    IF in_quote = 0 AND INSTR(c$, "@") THEN
      mod_flag = -1
    END IF
    IF s$ > "" THEN
      in_quote = NOT in_quote
    END IF
  LOOP UNTIL s$ = ""
  IF LEFT$(n$, 11) = "END DECLARE" THEN
    in_declare = 0
  END IF
  
  IF LEFT$(n$, 7) = "DECLARE" THEN
    in_declare = -1
  END IF

  if left$(n$, len("$CHECKING:OFF")) = "$CHECKING:OFF" then in_checking_off = -1
  if left$(n$, len("$CHECKING:ON")) = "$CHECKING:ON" then in_checking_on = 0

  IF (LEFT$(n$, 7) = "END SUB" OR LEFT$(n$, 13) = "END FUNCTION") AND NOT in_declare THEN
    in_sub = 0
    FOR k = 1 TO new_func_vars_count
      add_src_line "DIM " + new_func_vars(k) + " AS " + new_func_types(k), new_length, new_source()
      'add_src_line mem_get_line(k), new_length, new_source()
    NEXT k
    add_src_line sub_data$, new_length, new_source()
    'add_src_line source(x), new_length, new_source()
    sub_data$ = ""
  END IF
  IF LEFT$(n$, 4) = "TYPE" THEN
    'PRINT "In type!"
    in_type = -1
    type_nam$ = strip_line$(MID$(n$, 5))
    in_class_declare = 0
    in_interface_declare = 0
    if instr(type_nam$, "@CLASS") then
      in_class_declare = -1
      class_nam$ = mid$(type_nam$, 1, instr(type_nam$, "_CLASS") - 1)
      add_src_line mid$(source(x), 1, instr(source(x), "@") - 1), new_length, new_source()
    elseif instr(type_nam$, "@INTERFACE") then
      in_interface_declare = -1
      class_nam$ = strip_line$(mid$(type_nam$, 1, instr(type_nam$, "@") - 1))
      add_src_line mid$(source(x), 1, instr(source(x), "@") - 1), new_length, new_source()
    end if
  ELSEIF LEFT$(n$, 8) = "END TYPE" THEN
    'PRINT "Out of type!"
    in_type = 0
    in_class_declare = 0
    in_interface_declare = 0
  END IF
  IF mod_flag THEN
    add_flag = 0
    'Found a modifier!
    n$ = strip_line$(n$)
    checking_off = -1
    
    if (in_class_declare or in_interface_declare) and instr(ucase$(source(x)), "@SUB") then
      memb$ = strip_line$(mid$(source(x), 1, instr(UCASE$(source(x)), " AS ") - 1))
      args$ = mid$(ucase$(source(x)), instr(source(x), "(") + 1)
      args$ = mid$(args$, 1, instr(args$, ")") - 1)
      func$ = "SUB " + class_nam$ + "_" + memb$ + "("
      a$ = args$
      arg_count = 0
      c = 65
      DO until instr(a$, ",") <= 0
        func$ = func$ + chr$(c) + " AS " + mid$(a$, 1, instr(a$, ",") - 1) + ", "
        a$ = mid$(a$, instr(a$, ",") + 1)
        c = c + 1
        arg_count = arg_count + 1
      LOOP 
      if a$ > "" then func$ = func$ + chr$(c) + " AS " + a$: arg_count = arg_count + 1
      func$ = func$ + ")" + line_end$
      if in_class_declare then
        func$ = func$ + "DIM class as _OFFSET, pro AS _OFFSET: class = OBJ_Object_get_class%&(A)" + line_end$
      else 
        func$ = func$ + "DIM iface AS _OFFSET, pro as _OFFSET: iface = OBJ_Object_get_interface%&(A, " + class_nam$ + "_get_type&)" + line_end$
      end if
      func$ = func$ + "$CHECKING:OFF" + line_end$
      if in_class_declare then
        func$ = func$ + "pro = _MEMGET(" + mem_nam$ + ", class + _OFFSET(" + class_nam$ + "_class." + memb$ + ", TYPE), _OFFSET)" + line_end$
      else 
        func$ = func$ + "pro = _MEMGET(" + mem_nam$ + ", iface + _OFFSET(" + class_nam$ + "." + memb$ + ", TYPE), _OFFSET)" + line_end$
      end if
      func$ = func$ + "IF pro <> OBJ_NULL THEN" + line_end$
      cal$ = replace$(fix_space$(replace$(args$, ",", " ")), " ", "_")
      func$ = func$ + "  " + var_prefix$ + call_prefix$ + cal$ + " pro,"
      'func$ = func$ + "  @call(" + args$ + ") _MEMGET(" + mem_nam$ + ", class + _OFFSET(" + class_nam$ + "_class." + memb$ + ", TYPE), "
      for k = 1 to arg_count
        func$ = func$ + chr$(64 + k)
        if k < arg_count then func$ = func$ + ","
      next k
      func$ = func$ + line_end$ + "END IF" + line_end$
      func$ = func$ + "$CHECKING:ON" + line_end$
      func$ = func$ + "END SUB" + line_end$
      add_func func$
      reg_sub class_nam$ + "_" + memb$, args$
      'print "ARGS:"; args$
      add_src_line mid$(source(x), 1, instr(source(x), "@") - 1) + " _OFFSET", new_length, new_source()
    end if
    
    if (in_class_declare or in_interface_declare) and instr(ucase$(source(x)), "@FUNCTION") then
      memb$ = strip_line$(mid$(source(x), 1, instr(UCASE$(source(x)), " AS ") - 1))
      args$ = mid$(ucase$(source(x)), instr(source(x), "(") + 1)
      args$ = mid$(args$, 1, instr(args$, ")") - 1)
      ret$ = mid$(source(x), instr(ucase$(source(x)), " AS ") + 4)
      ret$ = mid$(ret$, instr(ucase$(ret$), " AS ") + 4)
      func$ = "FUNCTION " + class_nam$ + "_" + memb$ + get_suffix_from_type$(ret$) + "("
      a$ = args$
      arg_count = 0
      c = 65
      DO until instr(a$, ",") <= 0
        func$ = func$ + chr$(c) + " AS " + mid$(a$, 1, instr(a$, ",") - 1) + ", "
        a$ = mid$(a$, instr(a$, ",") + 1)
        c = c + 1
        arg_count = arg_count + 1
      LOOP 
      if a$ > "" then func$ = func$ + chr$(c) + " AS " + a$: arg_count = arg_count + 1
      func$ = func$ + ")" + line_end$
      if in_class_declare then
        func$ = func$ + "DIM class as _OFFSET, pro as _OFFSET: class = OBJ_Object_get_class%&(A)" + line_end$
      else 
        func$ = func$ + "DIM iface AS _OFFSET, pro as _OFFSET: iface = OBJ_Object_get_interface%&(A, " + class_nam$ + "_get_type&)" + line_end$
      end if
      func$ = func$ + "$CHECKING:OFF" + line_end$
      if in_class_declare then
        func$ = func$ + "pro = _MEMGET(" + mem_nam$ + ", class + _OFFSET(" + class_nam$ + "_class." + memb$ + ", TYPE), _OFFSET)" + line_end$
      else 
        func$ = func$ + "pro = _MEMGET(" + mem_nam$ + ", iface + _OFFSET(" + class_nam$ + "." + memb$ + ", TYPE), _OFFSET)" + line_end$
      end if
      func$ = func$ + "IF pro <> OBJ_NULL THEN" + line_end$
      'func$ = func$ + "  @call(" + args$ + ") _MEMGET(" + mem_nam$ + ", class + _OFFSET(" + class_nam$ + "_class." + memb$ + ", TYPE), "
      cal$ = replace$(fix_space$(replace$(args$, ",", " ")), " ", "_")
      func$ = func$ + class_nam$ + "_" + memb$ + get_suffix_from_type$(ret$) + " = " + var_prefix$ + call_func_prefix$ + ret$ + "_" + cal$ + " (pro,"
      for k = 1 to arg_count
        func$ = func$ + chr$(64 + k)
        if k < arg_count then func$ = func$ + ","
      next k
      func$ = func$ + ")"
      func$ = func$ + line_end$ + "END IF" + line_end$
      
      func$ = func$ + "$CHECKING:ON" + line_end$
      func$ = func$ + "END SUB" + line_end$
      add_func func$
      'print "FUNC:"; class_nam$ + "_" + memb$
      'print "ARGS:"; args$
      'print "RET:"; ret$
      reg_func class_nam$ + "_" + memb$, args$, ret$
      'print "call prefix:"; cal$
      'print "func args:"; args$
      'print "func ret:"; ret$
      add_src_line mid$(source(x), 1, instr(source(x), "@") - 1) + " _OFFSET", new_length, new_source()
    end if
    
    
    
    
    DO
      changed_flag = 0
      DO WHILE instr(ucase$(source(x)), "@SUB") AND NOT in_class_declare AND NOT in_interface_declare
        'print "Old source:"; source(x)
        l = instr(ucase$(source(x)), "@SUB")
        sn$ = ucase$(mid$(source(x), l))
        le = instr(sn$, ")") - 1
        arg$ = mid$(ucase$(sn$), instr(sn$, "(") + 1)
        arg$ = mid$(arg$, 1, instr(arg$, ")") - 1)

        source(x) = mid$(source(x), 1, l - 1) + var_prefix$ + arg$ + "_ptr%&" + mid$(source(x), l + le + 1)
        'print "New source:"; source(x)
        add_flag = -1
        changed_flag =-1
      LOOP
      n$ = strip_line$(ucase$(source(x)))
      
      DO WHILE instr(ucase$(source(x)), "@FUNCTION") AND NOT in_class_declare AND NOT in_interface_declare
        l = instr(ucase$(source(x)), "@FUNCTION")
        sn$ = ucase$(mid$(source(x), l))
        le = instr(sn$, ")") - 1
        arg$ = mid$(ucase$(sn$), instr(sn$, "(") + 1)
        arg$ = mid$(arg$, 1, instr(arg$, ")") - 1)
        
        source(x) = mid$(source(x), 1, l - 1) + var_prefix$ + remove_suffix$(arg$) + "_ptr%&" + mid$(source(x), l + le + 1)
        
        add_flag = -1
        changed_flag = -1
      LOOP
      n$ = strip_line$(ucase$(source(x)))
      
      if left$(n$, 5) = "@CALL" then
        args$ = mid$(n$, instr(n$, "(") + 1)
        args$ = mid$(args$, 1, instr(args$, ")") - 1)
        if instr(args$, ",") then
          'print "replace space:"; replace$(args$, ",", " ")
          'print "Fix space:"; fix_space$(replace$(args$, ",", " "))
          args$ = replace$(fix_space$(replace$(args$, ",", " ")), " ", "_")
        end if
        'print "ARGS:"; args$
        source(x) = var_prefix$ + call_prefix$ + args$ + " " + mid$(source(x), instr(source(x), ")") + 1)
        n$ = strip_line$(ucase$(source(x)))
        add_flag = -1
        changed_flag = -1
      end if
      
      DO WHILE instr(n$, "@CALL")
        lef$ = mid$(n$, 1, instr(n$, "@CALL") - 1)
        n2$ = mid$(n$, instr(n$, "@CALL") + 5)
        args$ = mid$(n2$, instr(n2$, "(") + 1)
        args$ = mid$(args$, instr(args$, "(") + 1)
        args$ = mid$(args$, 1, instr(args$, ")") - 1)
        n2$ = mid$(n2$, instr(n2$, "AS ") + 3)
        ret$ = strip_line$(mid$(n2$, 1, instr(n2$, ",") - 1))
        n2$ = mid$(n2$, instr(n2$, ",") + 1)
        paren_count = 0
        FOR k = 1 to len(n2$)
          if mid$(n2$, k, 1) = "," and paren_count = 0 then exit for
          if mid$(n2$, k, 1) = "(" then paren_count = paren_count + 1
          if mid$(n2$, k, 1) = ")" then paren_count = paren_count - 1
        next k
        proc_ptr$ = mid$(n2$, 1, k - 1)
        n2$ = mid$(n2$, len(proc_ptr$) + 2)
        paren_count = 0
        FOR k = 1 to len(n2$)
          if mid$(n2$, k, 1) = "(" then paren_count = paren_count + 1
          if mid$(n2$, k, 1) = ")" then paren_count = paren_count - 1: if paren_count = -1 then exit for
        next k
        n2$ = strip_line$(n2$)
        arguments$ = mid$(n2$, 2, k - 4)
        n2$ = mid$(n2$, k + 1)
        if instr(args$, ",") then
          args$ = replace$(fix_space$(replace$(args$, ",", " ")), " ", "_")
        end if
        'print "ORIG LINE:"; source(x)
        source(x) = lef$ + var_prefix$ + call_func_prefix$ + ret$
        if args$ > "" then
          source(x)  = source(x) + "_" + args$
        end if
        source(x) = source(x) + "(" + proc_ptr$ + "," + arguments$ + ")" + n2$
        n$ = strip_line$(ucase$(source(x)))
        'PRINT "FUNC CALL RET:"; ret$
        'PRINT "FUNC CALL ARG:"; args$
        'print "FUNC CALL proc:"; proc_ptr$
        'PRINT "FUNC CALL ARGS:"; arguments$
        add_flag = -1
        changed_flag = -1
      LOOP
      
  
      'end if
      
      IF MID$(n$, 2, LEN("REGISTER")) = "REGISTER" THEN
        add_Reg n$
      ELSEIF MID$(n$, 2, LEN("DEFINE_BITFLAGS")) = "DEFINE_BITFLAGS" THEN
        nam$ = MID$(n$, INSTR(n$, " ") + 1)
        value& = 1
        DO
          x = x + 1
          n$ = strip_line$(UCASE$(source(x)))
          un$ = UCASE$(n$)
          getter = 0
          setter = 0
          IF INSTR(un$, "@GET") OR INSTR(un$, "@SET") THEN
            IF INSTR(un$, "@GET") THEN getter = -1
            IF INSTR(un$, "@SET") THEN setter = -1
            n$ = MID$(n$, 1, INSTR(n$, " ") - 1)
          END IF
          IF n$ <> "@END_BITFLAGS" THEN
            add_const nam$ + "_FLAG_" + n$, LTRIM$(RTRIM$(STR$(value&)))
            if getter then add_func "FUNCTION " + ucase$(nam$) + "_CFLAG_" + n$ + "(this as _OFFSET): " + ucase$(nam$) _
              + "_CFLAG_" + n$ + " = MEM_long_from_off&(this + _OFFSET(" + nam$ + ".flags, TYPE)) AND " + LTRIM$(RTRIM$(STR$(value&))) + line_end$ + "END FUNCTION"
            if setter then add_func "SUB " + ucase$(nam$) + "_FLAG_SET_" + n$ + "(this as _OFFSET)" + line_end$ + "$CHECKING:OFF" + line_end$ _
              + " _MEMPUT " + mem_nam$ + ", this + _OFFSET(" + nam$ + ".flags, TYPE), MEM_long_from_off&(this + _OFFSET(" + nam$ + ".flags, TYPE)) OR " + LTRIM$(RTRIM$(STR$(value&))) + " AS LONG" + line_end$ + "$CHECKING:ON" + line_end$ + "END SUB"
            if setter then add_func "SUB " + ucase$(nam$) + "_FLAG_UNSET_" + n$ + "(this as _OFFSET)" + line_end$ + "$CHECKING:OFF" + line_end$ _
              + " _MEMPUT " + mem_nam$ + ", this + _OFFSET(" + nam$ + ".flags, TYPE), MEM_long_from_off&(this + _OFFSET(" + nam$ + ".flags, TYPE)) AND NOT " + LTRIM$(RTRIM$(STR$(value&))) + " AS LONG" + line_end$ + "$CHECKING:ON" + line_end$ + "END SUB"
            if setter then add_func "SUB " + ucase$(nam$) + "_FLAG_TOGGLE_" + n$ + "(this as _OFFSET)" + line_end$ + "$CHECKING:OFF" + line_end$ _
              + " _MEMPUT " + mem_nam$ + ", this + _OFFSET(" + nam$ + ".flags, TYPE), MEM_long_from_off&(this + _OFFSET(" + nam$ + ".flags, TYPE)) XOR " + LTRIM$(RTRIM$(STR$(value&))) + " AS LONG" + line_end$ + "$CHECKING:ON" + line_end$ + "END SUB"
            
            value& = value& * 2
          END IF
        LOOP WHILE n$ <> "@END_BITFLAGS"
      ELSEIF INSTR(n$, "@GET") OR INSTR(n$, "@SET") THEN
        'PRINT "Got here:"; n$
        IF INSTR(n$, "@GET") THEN getter = -1 ELSE getter = 0
        IF INSTR(n$, "@SET") THEN setter = -1 ELSE setter = 0
        IF in_type THEN
          v$ = LEFT$(n$, INSTR(n$, " ") - 1)
          t$ = MID$(n$, INSTR(n$, "AS") + 3)
          t$ = RTRIM$(MID$(t$, 1, INSTR(t$, "@") - 1))
          'PRINT "V:"; v$; " T:"; t$
          if setter then add_func "SUB " + type_nam$ + "_SET_" + v$ + "(this as _OFFSET, a AS " + t$ + ")" _
            + line_end$ + "$CHECKING:OFF" + line_end$ + "_MEMPUT " + mem_nam$ + ", this + _OFFSET(" + type_nam$ + "." + v$ + ", TYPE), a" _
            + line_end$ + "$CHECKING:ON" + line_end$ + "END SUB"
          if getter then add_func "SUB " + type_nam$ + "_GET_" + v$ + "(this as _OFFSET, a AS " + t$ + ")" _
            + line_end$ + "$CHECKING:OFF" + line_end$ + "_MEMGET " + mem_nam$ + ", this + _OFFSET(" + type_nam$ + "." + v$ + ", TYPE), a" _
            + line_end$ + "$CHECKING:ON" + line_end$ + "END SUB"
          'PRINT "Adding line:"; v$; " AS "; t$
          add_src_line v$ + " AS " + t$, new_length, new_source()
        END IF
      elseif left$(n$, 12) = "@DEBUG_PRINT" then
        'print "DEBUG Define:"; find_define("__DEBUG__")
        if find_define("__DEBUG__") > -1 then
          add_src_line var_prefix$ + "DEBUG_PRINT " + mid$(ltrim$(source(x)), 13), new_length, new_source()
        end if
      ELSEIF INSTR(n$, "@(") THEN
        checking_off = -1
        add_flag = -1
        'add_src_line "$CHECKING:OFF", new_length, new_source()
        print "N:"; n$
        IF LEFT$(n$, 2) = "@(" THEN
          lef$ = MID$(n$, 1, INSTR(n$, "=") + 1)
          rit$ = MID$(n$, INSTR(n$, "=") + 1)
          
          lef$ = make_deref_into_sub$(lef$)
          rit$ = make_deref_into_func$(rit$)
          
          source(x) = lef$ + rit$
          'add_src_line lef$ + rit$, new_length, new_source()
        ELSE
          source(x) = make_deref_into_func$(n$)
          'add_src_line make_deref_into_func$(n$), new_length, new_source()
        END IF
        'add_src_line "$CHECKING:ON", new_length, new_source()
      end if
    LOOP until changed_flag = 0
    if add_flag then
      if checking_off and in_checking_off = 0 then add_src_line "$CHECKING:OFF", new_length, new_source()
      if add_type_to_statement&& = 0 then 
        add_src_line source(x), new_length, new_source()
      else
        add_src_line source(x) + " AS " + get_type_from_type_flag$(add_type_to_statement&&), new_length, new_source()
      end if
      if checking_off and in_checking_off = 0 then add_src_line "$CHECKING:ON", new_length, new_source()
    END IF
  ELSE
    add_src_line source(x), new_length, new_source()
  END IF
  
    
  IF (LEFT$(n$, 4) = "SUB " OR LEFT$(n$, 9) = "FUNCTION ") AND NOT in_declare THEN
    clear_func_vars
    sub_data$ = ""
    'add_src_line source(x), new_length, new_source()
    in_sub = -1
  END IF
NEXT x

if find_define("__DEBUG__") > -1 then
  print #255, "$CONSOLE"
end if

PRINT #255, "DIM SHARED " + mem_nam$ + " AS _MEM"

FOR x = 1 TO const_count
  PRINT #255, new_CONSTS(x)
NEXT x

FOR x = 1 TO new_length
  PRINT #255, new_source(x)
NEXT x

FOR x = 1 TO func_count
  PRINT #255, flag_functions(x)
NEXT x

add_pointer_defs

if find_define("__DEBUG__") > -1 then
  PRINT #255, "SUB " + var_prefix$ + "DEBUG_PRINT (s$): d& = _DEST: _DEST _CONSOLE: PRINT s$: _DEST d&: END SUB"
end if

CLOSE #255

SYSTEM

SUB collect_type_information ()

in_type = 0
FOR x = 1 to next_line
  sn$ = UCASE$(strip_line$(source(x)))
  IF left$(sn$, 5) = "TYPE " then
    in_type = -1
    if instr(sn$, "@") then 
      tn$ = mid$(sn$, 5, instr(sn$, "@") - 6)
      ident$ = mid$(sn$, instr(sn$, "@") + 1)
    else
      tn$ = mid$(sn$, 5)
      ident$ = ""
    end if
    last_type = last_type + 1
    udt_xname(last_type) = strip_line$(tn$)
    udt_xnext(last_type) = last_type_element
  end if
  if left$(sn$, 8) = "END TYPE" then
    in_type = 0
  end if
  if in_type then
    if instr(sn$, " AS ") then
      en$ = mid$(sn$, 1, instr(sn$, " AS "))
      t$ = mid$(sn$, instr(sn$, " AS ") + 4)
      udt_ename(last_type_element) = en$
      udt_etype(last_type_element) = get_type_flag_from_type&&(t$)
      udt_enext(last_type_element) = last_type_element + 1
      last_type_element = last_type_element + 1
      'PRINT "Parameter: "; en$; " AS "; get_type_from_type_flag$(udt_etype(last_type_element-1));
    end if
  end if
NEXT x

END SUB

SUB add_const (c$, v$)
const_count = const_count + 1
IF const_count >= UBOUND(new_consts) THEN
  REDIM _PRESERVE new_CONSTS(UBOUND(new_consts) + 100) AS STRING
END IF
new_CONSTS(const_count) = "CONST " + c$ + " = " + v$
'PRINT new_CONSTS(const_count)
END SUB

SUB add_func (f$)
func_count = func_count + 1
IF func_count >= UBOUND(flag_functions) THEN
  REDIM _PRESERVE flag_functions(UBOUND(flag_functions) + 100) AS STRING
END IF
flag_functions(func_count) = f$
'print flag_functions(func_count)
END SUB

SUB add_define (d$, v$)
define_count = define_count + 1

IF define_count >= UBOUND(defines) THEN
  REDIM _PRESERVE defines(define_count + 100) AS define_type
  'REDIM _PRESERVE def_val(define_count + 100) AS STRING
END IF
MEM_put_str defines(define_count).value,  d$
MEM_put_str defines(define_count).replacement, v$
'PRINT "Define:"; MEM_get_str$(defines(define_count).value); " = "; v$
END SUB

FUNCTION find_define (d$)
ud$ = UCASE$(d$)
FOR x = 1 TO define_count
  IF MEM_get_str$(defines(x).value) = ud$ THEN
    find_define = x: EXIT FUNCTION
  END IF
NEXT x
find_define = -1
END FUNCTION

SUB add_Reg (n$)
k$ = MID$(n$, LEN("REGISTER") + 3)
t$ = MID$(k$, 1, INSTR(k$, " ") - 1)
nam$ = MID$(k$, INSTR(k$, " ") + 1)
'PRINT "TYPE:"; t$
'PRINT "NAME:"; nam$
flag = 0
FOR x = 1 TO reg_total_count
  IF t$ = reg_types(x) THEN
    flag = -1
    reg_count(x) = reg_count(x) + 1
    add_const nam$, RTRIM$(LTRIM$(STR$(reg_count(x))))
    EXIT FOR
  END IF
NEXT x
IF flag = 0 THEN
  reg_total_count = reg_total_count + 1
  IF reg_total_count >= UBOUND(reg_types) THEN
    REDIM _PRESERVE reg_types(UBOUND(reg_types) + 20) AS STRING
    REDIM _PRESERVE reg_count(UBOUND(reg_count) + 20) AS LONG
  END IF
  reg_count(reg_total_count) = 1
  reg_types(reg_total_count) = t$
  add_const nam$, RTRIM$(LTRIM$(STR$(1)))
END IF
END SUB

SUB add_src_line (l$, count AS LONG, sour() AS STRING)
IF in_sub = 0 THEN
  count = count + 1
  IF count >= UBOUND(sour) THEN
    add_source_lines 100, sour()
  END IF
  'print "Next_line:"; l$
  sour(count) = l$
ELSE
  sub_data$ = sub_data$ + l$ + line_end$
END IF
END SUB

FUNCTION strip_line$ (l$)
strip_line$ = LTRIM$(RTRIM$(l$))
END FUNCTION

SUB load_file (file$)
DIM fnum AS LONG
fnum = FREEFILE
'print "F="; fnum

'PRINT "File:"; file$
OPEN file$ FOR INPUT AS #fnum

process_line = -1
if_count = 0
last_if = 0


DO
  LINE INPUT #fnum, l$
  l$ = strip_comment$(l$)
  ls$ = strip_line$(l$)
  uls$ = UCASE$(ls$)
  include_flag = 0
  IF LEFT$(LCASE$(ls$), LEN("'$include:'")) = "'$include:'" THEN
    fil$ = MID$(ls$, 12)
    fil$ = LEFT$(fil$, LEN(fil$) - 1)
    'print "fil:"; fil$
    new_file$ = get_file$(fil$)
    new_dir$ = get_dir$(fil$)
    'PRINT "NEW FILE:"; new_file$
    'PRINT "NEW DIR:"; new_dir$
    'print "File:"; fil$
    'di$ = get_cur_dir$
    old_dir$ = space$(1024)
    getcwd old_dir$, LEN(old_dir$)
    'print "new_dir:"; new_dir$
    IF new_dir$ > "" THEN
      CHDIR new_dir$
    END If
    load_file new_file$ ', new_dir$
    IF new_dir$ > "" THEN
      'print "old_dir:"; old_dir$
      CHDIR old_dir$
    END IF
    include_flag = -1
  end if
  
  if left$(uls$, 2) = "!!" then
    cmd$ = strip_line$(mid$(uls$, 3))
    cmd_flag = -1
  else 
    cmd$ = ""
    cmd_flag = 0
  end if
  if cmd_flag then
    'print "Found command: "; cmd$
    IF LEFT$(cmd$, 3) = "IF " THEN if_count = if_count + 1
    
    IF LEFT$(cmd$, 3) = "IF " AND process_line OR (LEFT$(cmd$, 7) = "ELSEIF " AND if_count = last_if) THEN
      last_if = if_count
      cmd2$ = MID$(cmd$, INSTR(cmd$, " ") + 1)
      s$ = MID$(cmd2$, 1, INSTR(cmd2$, " ") - 1)
      not_flag = 0
      'print "IF :"; cmd2$
      'PRINT "IF statement:"
      IF s$ = "NOT" THEN
        'PRINT "Not flag found!"
        not_flag = -1
        cmd2$ = MID$(cmd2$, INSTR(cmd2$, " ") + 1)
        s$ = MID$(cmd2$, 1, INSTR(cmd2$, " ") - 1)
        'PRINT "S="; s$
      END IF
      IF s$ = "DEFINED" THEN
        'PRINT "Checking IF Defined"
        d2$ = MID$(cmd2$, INSTR(cmd2$, " ") + 1)
        c = find_define(d2$)
        'PRINT "C="; c
        'print "Defined:"; d2$
        'print "C="; c
        IF c > 0 THEN process_line = NOT not_flag
        IF c = -1 THEN process_line = not_flag
      ELSEIF INSTR(cmd2$, "=") THEN
        'd$ = mid$(uls$, instr(uls$, " ") + 1)
        d$ = s$ 'strip_line$(mid$(d$, 1, instr(d$, "=") - 1))
        de = find_define(d$)
        d2$ = strip_line$(MID$(cmd2$, INSTR(cmd2$, "=") + 1))
        de2 = find_define(d2$)
        IF de > 0 THEN
          v$ = MEM_Get_str$(defines(de).replacement)
        ELSE
          v$ = strip_quote$(d$)
        END IF
        IF de2 > 0 THEN
          v2$ = MEM_Get_str$(defines(de2).replacement)
        ELSE
          v2$ = strip_quote$(d2$)
        END IF
        'PRINT "D1:"; d$
        'PRINT "D2:"; d2$
        'PRINT "V1:"; v$
        'PRINT "V2:"; v2$
        IF v$ = v2$ THEN
          process_line = NOT not_flag
        ELSE
          process_line = not_flag
        END IF
      END IF
    ELSEIF LEFT$(cmd$, 4) = "ELSE" AND last_if = if_count THEN
      process_line = NOT process_line
    ELSEIF LEFT$(cmd$, 5) = "ENDIF" AND last_if = if_count THEN
      process_line = -1
    ELSEIF LEFT$(cmd$, 7) = "DEFINE " and process_line then
      d2$ = MID$(cmd$, INSTR(cmd$, " ") + 1)
      IF INSTR(d2$, " ") THEN
        d$ = MID$(d2$, 1, INSTR(d2$, " ") - 1)
        v$ = MID$(d2$, INSTR(d2$, " ") + 1)
      ELSE
        d$ = d2$
        v$ = ""
      END IF
      add_define d$, v$
    elseif left$(cmd$, 8) = "INCLUDE " then
      if instr(cmd$, " ONCE") then
        if file_already_included(file$) then
          EXIT DO
        else
          add_included_file file$
        end if
      end if
    end if

    if left$(cmd$, 5) = "ENDIF" then if_count = if_count - 1
  end if
  IF process_line and not cmd_flag and not include_flag then ' AND LEFT$(cmd$, 6) <> "ENDIF " AND LEFT$(cmd$, 5) <> "ELSE " THEN
    'IF LEFT$(cmd$, 7) = "DEFINE " THEN
      
    'ELSE
      if left$(uls$, 4) = "SUB " then
        ls$ = replace_with_case$(ls$, "@PROC", "_OFFSET")
        nam$ = mid$(ls$, instr(ls$, " ") + 1)
        if instr(nam$, " ") then
          nam$ = mid$(nam$, 1, instr(nam$, " ") - 1)
        end if
        if instr(nam$, "(") then
          nam$ = rtrim$(mid$(nam$, 1, instr(nam$, "(") - 1))
        end if
        args$ = mid$(ls$, instr(ls$, "("))
        reg_sub nam$, args$
      elseif left$(uls$, 9) = "FUNCTION " then
        ls$ = replace_with_case$(ls$, "@PROC", "_OFFSET")
        nam$ = mid$(ls$, instr(ls$, " ") + 1)
        if instr(nam$, " ") then
          nam$ = mid$(nam$, 1, instr(nam$, " ") - 1)
        end if
        if instr(nam$, "(") then
          nam$ = rtrim$(mid$(nam$, 1, instr(nam$, "(") - 1))
        end if
        typ$ = get_type_name$(nam$)
        args$ = mid$(ls$, instr(ls$, "("))
        'print "FUNCTION:"; nam$; "  "; args$; "  "; typ$
        reg_func remove_suffix$(nam$), args$, typ$
      end if
      add_src_line l$, next_line, source()
    'end if
  end if
LOOP UNTIL EOF(fnum)
CLOSE #fnum
'PRINT "Closed file!"
'PRINT "Closed file!"
END SUB

FUNCTION strip_quote$(s$)
s2$ = rtrim$(ltrim$(s$))
strip_quote$ = mid$(s2$, 2, len(s2$) - 2)
END FUNCTION

SUB add_source_lines(lines, sour() AS STRING)
REDIM _PRESERVE sour(UBOUND(sour) + lines) AS STRING 
END SUB

FUNCTION get_dir$(f$)
c$ = ""
f2$ = f$
DO
  c$ = c$ + left$(f2$, instr(f2$, slash$))
  f2$ = mid$(f2$, instr(f2$, slash$) + 1)
LOOP until instr(f2$, slash$) = 0
'print "DIR:"; c$
get_dir$ = c$
END FUNCTION

FUNCTION get_file$(f$)
c$ = ""
f2$ = f$
DO
  c$ = c$ + left$(f2$, instr(f2$, slash$))
  f2$ = mid$(f2$, instr(f2$, slash$) + 1)
LOOP until instr(f2$, slash$) = 0
'print "FILE:"; f2$
get_file$ = f2$
END FUNCTION

FUNCTION get_string_to_matching_paren$(l$)
count = 0
for x = 1 to len(l$)
  if mid$(l$, x, 1) = "(" then count = count + 1: if count = 1 then begin = x
  if mid$(l$, x, 1) = ")" then count = count - 1: if count = 0 then get_string_to_matching_paren$ = mid$(l$, begin, x - begin): exit function
next x
END FUNCTION

FUNCTION get_string_to_next_delim$(l$, d$)
count = 0
FOR x = 1 to len(l$)
  if mid$(l$, x, 1) = d$ then if count = 0 then get_string_to_next_delim$ = mid$(l$, 1, x -1 ): exit function
  if mid$(l$, x, 1) = "(" then count = count + 1
  if mid$(l$, x, 1) = ")" then count = count - 1
next x
END FUNCTION

FUNCTION make_deref_into_func$ (s$)
'STATIC loop_count
if instr(s$, "@(") = 0 then make_deref_into_func$ = s$: exit function

'loop_count = loop_count + 1
rit$ = s$

DO WHILE instr(rit$, "@(")
  print "Beginning line:"; rit$
  l$ = mid$(rit$, 1, instr(rit$, "@(") - 1)

  c$ = mid$(rit$, instr(rit$, "@(") + 1)
  c$ = get_string_to_matching_paren$(c$)
  'c$ = mid$(rit$, instr(rit$, "@(") + 2)
  'c$ = mid$(c$, 1, instr(c$, ")") - 1)
  
  r$ = mid$(rit$, instr(rit$, "@(") + 1)
  r$ = mid$(r$, len(get_string_to_matching_paren$(r$)) + 1)
  print "C:"; c$
  c$ = mid$(c$, 2)

  off$ = get_string_to_next_delim$(c$, ",")

  c$ = mid$(c$, len(off$) + 2)
  'off$ = ltrim$(rtrim$(mid$(c$, instr(c$, "@(") + 1)))
  'off$ = ltrim$(rtrim$(mid$(off$, 1, instr(off$, ",") - 1)))
  'off$ = make_deref_into_func$(off$)
   
    'ele$ = ltrim$(rtrim$(mid$(c$, instr(c$, ",") + 1))) 
  'ele$ = rtrim$(mid$(ele$, 1, instr(ele$, ",") - 1))
 

  if instr(c$, ",") then
    ele$ = get_string_to_next_delim$(c$, ",") 
    typ$ = ltrim$(rtrim$(mid$(c$, instr(c$, ",") + 1)))
    typ$ = rtrim$(ltrim$(mid$(typ$, instr(typ$, ",") + 1)))
  else
    ele$ = strip_line$(c$)
    print " calling func to get type ELE:"; ele$
    typ$ = get_type_from_type_flag$(get_type_flag_from_type&&(ele$))
  end if


  print "off:"; off$
  print "ele:"; ele$
  print "typ:"; typ$
  print "R:"; r$
  print "l:"; l$
  input "?"; x$
  'add_func_var var_prefix$  + off$ + "_" + typ$, typ$
  'add_src_line "$CHECKING:OFF" + line_end$ + "_MEMGET " + mem_nam$ + ", " + off$ + ", " + var_prefix$ + off$ + "_" + typ$ + line_end$ + "$CHECKING:ON" + line_end$, new_length, new_source()
  'add_src_line , new_length, new_source()
  'add_src_line , new_length, new_source()

  rit$ = l$ + "_MEMGET(" + mem_nam$ + ", " + off$
  if instr(ele$, ".") then
    rit$ = rit$ + " + _OFFSET(" + ele$ + ", TYPE)"
  end if
  rit$ = rit$ + "," + typ$ + r$

LOOP
'loop_count = loop_count - 1
'if loop_count = 0 then
'  for x = 1 to new_func_vars
'  add_src_line "DIM " + 
'end if
make_deref_into_func$ = rit$
END FUNCTION

FUNCTION make_deref_into_sub$ (s$)
if instr(s$, "@(") = 0 then make_deref_into_sub$ = s$: exit function
lef$ = s$
if left$(lef$, 2) = "@(" then
  off$ = ltrim$(rtrim$(mid$(lef$, 3, instr(lef$, ",") - 3)))
  ele$ = ltrim$(rtrim$(mid$(lef$, instr(lef$, ",") + 1)))
  ele$ =  mid$(ele$, 1, instr(ele$, ")") - 1)
  typ&& = get_type_flag_from_type&&(ele$)
  add_type_to_statement&& = typ&&
  'lef$ = mid$(lef$, instr(lef$, ",") + 1)
  'typ$ = mid$(lef$, 1, instr(lef$, ",") - 1)
  
  'extra$ = ltrim$(rtrim$(mid$(lef$, instr(lef$, ")") + 1)))
  'extra$ = rtrim$(mid$(extra$, 1, instr(extra$, "=") - 1))
  
  'if extra$ > "" then 'assume type information
  '  extra$ = typ$ + extra$
  'end if
  if instr(ele$, ".") > 0 then
    lef$ = "_MEMPUT " + mem_nam$ + ", " + off$ + "+ _OFFSET(" + ele$ + ", TYPE), "
  else 
    lef$ = "_MEMPUT " + mem_nam$ + ", " + off$ + ", "
  end if
  'lef$ = "MEM_MEMCPY off$ + _OFFSET(" + extra$ + ", TYPE), "
end if
make_deref_into_sub$ = lef$
END FUNCTION

SUB add_func_var (n$, t$) ', m$)
  FOR x = 1 to new_func_vars
    if new_func_vars(x) = n$ then exit sub
  NEXT x
  new_func_vars_count = new_func_vars_count + 1
  if new_func_vars_count >= UBOUND(new_func_vars) then
    REDIM _PRESERVE new_func_vars(UBOUND(new_func_vars)+ 100) AS STRING
    REDIM _PRESERVE new_func_types(UBOUND(new_func_vars) + 100) AS STRING
    'REDIM _PRESERVE mem_get_line(UBOUND(new_func_vars) + 100) AS STRING
  end if
  new_func_vars(new_func_vars_count) = n$
  new_func_types(new_func_vars_count) = t$
  'mem_get_line(new_func_vars_count) = m$
END SUB

SUB clear_func_vars
new_func_vars_count = 0
END SUB

FUNCTION replace$(s$, s1$, s2$)
s3$ = s$
DO WHILE instr(s3$, s1$)
  s3$ = mid$(s3$, 1, instr(s3$, s1$) - 1) + s2$ + mid$(s3$, instr(s3$, s1$) + 1)
LOOP
replace$ = s3$
END FUNCTION

FUNCTION fix_space$(s$)
FOR x = 1 to len(s$)
  if mid$(s$, x, 1) <> " " then
    s2$ = s2$ + mid$(s$, x, 1)
    sp = 0
  elseif sp = 0 then
    s2$ = s2$ + " "
    sp = -1
  end if
next x
fix_space$ = s2$
END FUNCTION

SUB reg_sub (nam$, args$)
sub_count = sub_count + 1
if sub_count >= UBOUND(sub_names) then
  REDIM _PRESERVE sub_names(UBOUND(sub_names) + 100) AS STRING
  REDIM _PRESERVE sub_names(UBOUND(sub_args) + 100) AS STRING
  REDIM _PRESERVE sub_number(ubound(sub_number) + 100) AS LONG
end if
sub_names(sub_count) = nam$
sub_args(sub_count) = parse_args$(args$)
find_high = 0
flag = 0
FOR x = 1 to sub_count - 1
  if sub_args(x) = sub_args(sub_count) and find_high < sub_number(x) then
    find_high = sub_number(x)
    flag = -1
    exit for
  end if
NEXT x
sub_number(sub_count) = find_high + 1
if flag = 0 then reg_arg(sub_args(sub_count))': print "registering sub:"; nam$: print "Args:"; args$
'PRINT "Adding sub:"; sub_names(sub_count)
'print "Args:"; sub_args(sub_count)
'print "Count:"; sub_number(sub_count)
END SUB

SUB reg_arg (args$)
sub_diff_args = sub_diff_args + 1
if sub_diff_args > ubound(diff_arg_list) then
  REDIM _PRESERVE diff_arg_list(ubound(diff_arg_list) + 100) AS STRING
end if
diff_arg_list(sub_diff_args) = args$
'print "func diff args:"; args$
'print "Adding args:"; replace$(args$, chr$(13), "_")
END SUB

SUB func_reg_arg (args$, typ$)
func_diff_args = func_diff_args + 1
if func_diff_Args > ubound(func_diff_arg_list) then
  REDIM _PRESERVE func_diff_arg_list(ubound(func_diff_arg_list) + 100) AS STRING
  REDIM _PRESERVE func_diff_arg_type(ubound(func_diff_arg_type) + 100) AS STRING
end if
func_diff_arg_list(func_diff_args) = args$
func_diff_arg_type(func_diff_args) = typ$

END SUB

FUNCTION parse_args$(arg$)
arg2$ = ucase$(strip_line$(arg$))
if left$(arg2$, 1) = "(" then
  arg2$ = mid$(arg2$, 2, len(arg2$) - 2)
end if
arg4$ = ""
DO WHILE instr(arg2$, ",")
  'arg3$ = mid$(arg2$, instr(arg2$, "AS") + 3)
  'arg2$ = arg3$
  'if instr(arg3$, ",") then
  '  arg3$ = mid$(arg3$, 1, instr(arg3$, ",") - 1)
  '  arg2$ = mid$(arg2$, instr(arg2$, ",") + 1)
  'else 
  '  arg2$ = ""
  'end if
  arg3$ = mid$(arg2$, 1, instr(arg2$, ",") - 1)
  arg2$ = mid$(arg2$, instr(arg2$, ",") + 1)
  arg3$ = get_type_name$(arg3$)
  if arg4$ > "" then
    arg4$ = arg4$ + chr$(13) +  arg3$
  else 
    arg4$ = arg3$
  end if
LOOP

t$ = get_type_name$(arg2$)
if t$ > "" then
    if arg4$ > "" then
    arg4$ = arg4$ + chr$(13) + t$
  else 
    arg4$ = t$
  end if
end if

'arg2$ = replace$(fix_space$(replace$(arg2$, ",", " ")), " ", "_")
parse_args$ = arg4$
END FUNCTION

SUB reg_func (nam$, args$, ret$)
function_count = function_count + 1
if function_count >= UBOUND(func_names) then
  REDIM _PRESERVE func_names(UBOUND(func_names) + 100) AS STRING
  REDIM _PRESERVE func_names(UBOUND(func_args) + 100) AS STRING
  REDIM _PRESERVE func_number(ubound(func_number) + 100) AS LONG
  REDIM _PRESERVE func_type(ubound(func_type) + 100) AS STRING
end if
func_names(function_count) = nam$
func_args(function_count)  = parse_args$(args$)
func_type(function_count)  = ret$
find_high = 0
flag = 0
FOR x = 1 to function_count - 1
  if func_args(x) = func_args(function_count) and find_high < func_number(x) and func_type(x) = func_type(function_count) then
    find_high = func_number(x)
    flag = -1
    exit for
  end if
NEXT x
func_number(function_count) = find_high + 1
if flag = 0 then func_reg_arg func_args(function_count), func_type(function_count)
'PRINT "Adding sub:"; sub_names(sub_count)
'print "Args:"; sub_args(sub_count)
'print "Count:"; sub_number(sub_count)
END SUB

FUNCTION strip_comment$(s$)
in_quote = 0
'print "Unstripped:"; s$
FOR x = 1 to len(s$)
  if mid$(s$, x, 1) = chr$(34) then
    in_quote = not in_quote
  end if
  if mid$(s$, x, 1) = "'" AND in_quote = 0 and mid$(s$, x, 2) <> "'$" and meta = 0 then
    strip_comment$ = mid$(s$, 1, x - 1)
    'print "STRIP:"; mid$(s$, 1, x - 1)
    exit function
  end if
  if mid$(s$, x, 2) = "'$" then meta = -1
NEXT X
strip_comment$ = s$
'print "STRIP:"; s$
END FUNCTION

FUNCTION remove_suffix$(s$)
suff$ = "!#$%&`~"
FOR x = 1 to len(s$)
  if instr(suff$, mid$(s$, x, 1)) > 0 then remove_suffix$ = mid$(s$, 1, x - 1): exit function
next x
remove_suffix$ = s$
END FUNCTION

SUB add_pointer_defs
print #255, "DECLARE CUSTOMTYPE LIBRARY " + qq$(ptrs_file$) + line_end$;

for x = 1 to sub_count
  print #255, "  FUNCTION "; var_prefix$; ucase$(sub_names(x)); "_ptr%& ()"
  'print #256, "extern void SUB_"; ucase$(sub_names(x)); "(";
  'a$ = sub_args(x)
  'DO until instr(a$, chr$(13)) <= 0
  '  print #256, get_c_type_ptr_from_qb_type$(mid$(a$, 1, instr(a$, chr$(13)) - 1)); ",";
  '  a$ = mid$(a$, instr(a$, chr$(13)) + 1)
  'LOOP 
  'if a$ > "" then
  '  print #256, get_c_type_ptr_from_qb_type$(a$);
  'end if
  '
  'print #256, ");";
  print #256, "void *"; var_prefix$; ucase$(sub_names(x)); "_ptr () {";
  print #256, "  return (void*)(SUB_"; ucase$(sub_names(x)); ");}"
next x
for x = 1 to function_count
  print #255, "  FUNCTION "; var_prefix$; ucase$(func_names(x)); "_ptr%& ()"
  
  print #256, "void *"; var_prefix$; ucase$(func_names(x)); "_ptr () {";
  print #256, "  return (void*)(FUNC_"; ucase$(func_names(x)); ");}"
next x
for x = 1 to sub_diff_args
  print #255, "  SUB " + var_prefix$ + call_prefix$; replace$(diff_arg_list(x), chr$(13), "_"); "( BYVAL va AS _OFFSET, ";
  a$ = diff_arg_list(x)
  c = 65
  DO until instr(a$, chr$(13)) <= 0
    print #255, chr$(c) + " AS " + mid$(a$, 1, instr(a$, chr$(13)) - 1) + ", ";
    a$ = mid$(a$, instr(a$, chr$(13)) + 1)
    c = c + 1
  LOOP 
  if a$ > "" then print #255, chr$(c) + " AS " + a$;
  print #255, ")" + line_end$;
  print #256, "void "; var_prefix$; call_prefix$; replace$(diff_arg_list(x), chr$(13), "_"); "( void* func, ";
  a$ = diff_arg_list(x)
  c = 65
  DO until instr(a$, chr$(13)) <= 0
    print #256, get_c_type_ptr_from_qb_type$(mid$(a$, 1, instr(a$, chr$(13)) - 1)); " "; chr$(c); ", ";
    a$ = mid$(a$, instr(a$, chr$(13)) + 1)
    c = c + 1
  LOOP 
  if a$ > "" then print #256, get_c_type_ptr_from_qb_type$(a$); " "; chr$(c);
  print #256, ") {"; 
  print #256, "((void(*)(";
  arg_ls$ = ""
  a$ = diff_arg_list(x)
  c = 65
  DO until instr(a$, chr$(13)) <= 0
    print #256, get_c_type_ptr_from_qb_type$(mid$(a$, 1, instr(a$, chr$(13)) - 1)); ", ";
    a$ = mid$(a$, instr(a$, chr$(13)) + 1)
    if arg_ls$ > "" then arg_ls$ = arg_ls$ + ","
    arg_ls$ = arg_ls$ + chr$(c)
    c = c + 1
  LOOP 
  if a$ > "" then print #256, get_c_type_ptr_from_qb_type$(a$);: if arg_ls$ > "" then arg_ls$ = arg_ls$ + "," + chr$(c) else arg_ls$ = chr$(c)
  print #256, "))(func))("; arg_ls$; ");}"
next x


for x = 1 to func_diff_args
  'PRINT "Func:"; func_diff_arg_type(x); "_"; replace$(func_diff_arg_list(x), chr$(13), "_")
  'print "type:"; func_diff_arg_type(x)
  'PRINT "Suffix:"; get_suffix_from_type$(func_diff_arg_type(x))
  print #255, "  FUNCTION " + var_prefix$ + call_func_prefix$; func_diff_arg_type(x); "_"; replace$(func_diff_arg_list(x), chr$(13), "_"); get_suffix_from_type$(func_diff_arg_type(x)); "( BYVAL va AS _OFFSET, ";
  a$ = func_diff_arg_list(x)
  c = 65
  DO until instr(a$, chr$(13)) <= 0
    print #255, chr$(c) + " AS " + mid$(a$, 1, instr(a$, chr$(13)) - 1) + ", ";
    a$ = mid$(a$, instr(a$, chr$(13)) + 1)
    c = c + 1
  LOOP 
  if a$ > "" then print #255, chr$(c) + " AS " + a$;
  print #255, ")" + line_end$;
  print #256, get_c_type_from_qb_type$(func_type(x)); " "; var_prefix$; call_func_prefix$; func_diff_arg_type(x); "_"; replace$(func_diff_arg_list(x), chr$(13), "_"); "( void* func, ";
  a$ = func_diff_arg_list(x)
  c = 65
  DO until instr(a$, chr$(13)) <= 0
    print #256, get_c_type_from_qb_type$(mid$(a$, 1, instr(a$, chr$(13)) - 1)); " "; chr$(c); ", ";
    a$ = mid$(a$, instr(a$, chr$(13)) + 1)
    c = c + 1
  LOOP 
  if a$ > "" then print #256, get_c_type_from_qb_type$(a$); " "; chr$(c);
  print #256, ") {";
  print #256, "return (("; get_c_type_from_qb_type$(func_type(x)); "(*)(";
  arg_ls$ = ""
  a$ = func_diff_arg_list(x)
  c = 65
  DO until instr(a$, chr$(13)) <= 0
    print #256, get_c_type_from_qb_type$(mid$(a$, 1, instr(a$, chr$(13)) - 1)); ", ";
    a$ = mid$(a$, instr(a$, chr$(13)) + 1)
    if arg_ls$ > "" then arg_ls$ = arg_ls$ + ","
    arg_ls$ = arg_ls$ + chr$(c)
    c = c + 1
  LOOP 
  if a$ > "" then print #256, get_c_type_from_qb_type$(a$);: if arg_ls$ > "" then arg_ls$ = arg_ls$ + "," + chr$(c) else arg_ls$ = chr$(c)
  print #256, "))(func))("; arg_ls$; ");}"
next x

print #255, "END DECLARE"; line_end$;
END SUB

FUNCTION get_type_name$ (s$)
alph$ = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
s2$ = strip_line$(s$)
if instr(s2$, " AS ") then
  s3$ = mid$(s2$, instr(s2$, " AS ") + 4)
  if instr(s3$, "_UNSIGNED") then s4$ = mid$(s3$, instr(s3$, "_UNSIGNED") + len("_UNSIGNED") + 1) else s4$ = s3$
  get_type_name$ = strip_line$(s4$)
  exit function
end if
for k = len(s2$) to 1 step -1
  if instr(alph$, mid$(s2$, k, 1)) then exit for
  al$ = mid$(s2$, k, 1) + al$
next k

if al$ = "" then get_type_name$ = "SINGLE": exit function 
get_type_name$ = get_type_from_suffix$(al$)
END FUNCTION

FUNCTION get_type_from_suffix$ (s$)
if left$(s$, 1) = "~" then s2$ = mid$(s$, 2) else s2$ = s$
if s2$ = "%"  then get_type_from_suffix$ = "INTEGER": exit function 
if s2$ = "&"  then get_type_from_suffix$ = "LONG"   : exit function 
if s2$ = "!"  then get_type_from_suffix$ = "SINGLE" : exit function 
if s2$ = "#"  then get_type_from_suffix$ = "DOUBLE" : exit function
if s2$ = "&&" then get_type_from_suffix$ = "_INTEGER64" : exit function 
if s2$ = "`"  then get_type_from_suffix$ = "_BIT" : exit function 
if s2$ = "%%" then get_type_from_suffix$ = "_BYTE" : exit function
if s2$ = "##" then get_type_from_suffix$ = "_FLOAT" : exit function 
if s2$ = "%&" then get_type_from_suffix$ = "_OFFSET" : exit function
if s2$ = "$"  then get_type_from_suffix$ = "STRING" : exit function
get_type_from_suffix$ = "SINGLE"
END FUNCTION

FUNCTION get_suffix_from_type$ (s$)
if instr(s$, "_UNSIGNED") then s2$ = mid$(s$, instr(s$, "_UNSIGNED") + len("_UNSIGNED")) else s2$ = s$
if s2$ = "INTEGER" then get_suffix_from_type$ = "%" : exit function 
if s2$ = "LONG"    then get_suffix_from_type$ = "&" : exit function 
if s2$ = "SINGLE"  then get_suffix_from_type$ = "!" : exit function 
if s2$ = "DOUBLE"  then get_suffix_from_type$ = "#" : exit function 
if s2$ = "_INTEGER64" then get_suffix_from_type$ = "&&" : exit function 
if s2$ = "_BIT"    then get_suffix_from_type$ = "`" : exit function 
if s2$ = "_BYTE"   then get_suffix_from_type$ = "%%" : exit function 
if s2$ = "_FLOAT"  then get_suffix_from_type$ = "##" : exit function 
if s2$ = "_OFFSET" then get_suffix_from_type$ = "%&" : exit function 
if s2$ = "STRING"  then get_suffix_from_type$ = "$"  : exit function 
get_suffix_from_type$ = "!"
END FUNCTION

FUNCTION get_c_type_ptr_from_qb_type$ (s$)
if instr(s$, "_UNSIGNED") then s2$ = mid$(s$, instr(s$, "_UNSIGNED") + len("_UNSIGNED")) else s2$ = s$
if s2$ = "INTEGER" then get_c_type_ptr_from_qb_type$ = "short*" : exit function 
if s2$ = "LONG"    then get_c_type_ptr_from_qb_type$ = "int*" : exit function 
if s2$ = "SINGLE"  then get_c_type_ptr_from_qb_type$ = "float*" : exit function 
if s2$ = "DOUBLE"  then get_c_type_ptr_from_qb_type$ = "double*" : exit function 
if s2$ = "_INTEGER64" then get_c_type_ptr_from_qb_type$ = "long long*" : exit function 
if s2$ = "_BIT"    then get_c_type_ptr_from_qb_type$ = "char*" : exit function 
if s2$ = "_BYTE"   then get_c_type_ptr_from_qb_type$ = "char*" : exit function 
if s2$ = "_FLOAT"  then get_c_type_ptr_from_qb_type$ = "long double*" : exit function 
if s2$ = "_OFFSET" then get_c_type_ptr_from_qb_type$ = "void*" : exit function 
if s2$ = "STRING"  then get_c_type_ptr_from_qb_type$ = "char*"  : exit function 
get_c_type_ptr_from_qb_type$ = "float*"
END FUNCTION

FUNCTION get_c_type_from_qb_type$ (s$)
if instr(s$, "_UNSIGNED") then s2$ = mid$(s$, instr(s$, "_UNSIGNED") + len("_UNSIGNED")) else s2$ = s$
if s2$ = "INTEGER" then get_c_type_from_qb_type$ = "short" : exit function 
if s2$ = "LONG"    then get_c_type_from_qb_type$ = "int" : exit function 
if s2$ = "SINGLE"  then get_c_type_from_qb_type$ = "float" : exit function 
if s2$ = "DOUBLE"  then get_c_type_from_qb_type$ = "double" : exit function 
if s2$ = "_INTEGER64" then get_c_type_from_qb_type$ = "long long" : exit function 
if s2$ = "_BIT"    then get_c_type_from_qb_type$ = "char" : exit function 
if s2$ = "_BYTE"   then get_c_type_from_qb_type$ = "char" : exit function 
if s2$ = "_FLOAT"  then get_c_type_from_qb_type$ = "long double" : exit function 
if s2$ = "_OFFSET" then get_c_type_from_qb_type$ = "void*" : exit function 
if s2$ = "STRING"  then get_c_type_from_qb_type$ = "char*"  : exit function 
get_c_type_from_qb_type$ = "float"
END FUNCTION

FUNCTION get_type_flag_from_type&& (t$)
  DIM f as _INTEGER64
  t2$ = ucase$(strip_line$(t$))
  if left$(t2$, LEN("_UNSIGNED")) = "_UNSIGNED" then f = f OR IS_UNSIGNED: t2$ = strip_line$(mid$(t2$, LEN("_UNSIGNED") + 1))
  if t2$ = "_BYTE"          then f = f OR BYTE_TYPE
  if t2$ = "INTEGER"        then f = f or INTEGER_TYPE 
  if t2$ = "LONG"           then f = f OR LONG_TYPE
  if t2$ = "SINGLE"         then f = f OR SINGLE_TYPE
  if t2$ = "DOUBLE"         then f = f or DOUBLE_TYPE
  if t2$ = "INTEGER64"      then f = f OR INTEGER64_TYPE
  'if t2$ = "_MEM"           then f = f OR MEM_TYPE
  if instr(t2$, "STRING")   then f = f OR STRING_TYPE: f = f OR (MAKE_STRING * VAL(MID$(t2$, instr(t2$, "*") + 1)))
  if t2$ = "_OFFSET"        then f = f OR OFFSET_TYPE
  if t2$ = "_FLOAT"         then f = f OR FLOAT_TYPE
  if t2$ = "@PROC"          then f = f OR OFFSET_TYPE
  if instr(t2$, "@FUNCTION") or instr(t2$, "@SUB") then f = f OR OFFSET_TYPE
  if f = 0 then
    f = recurse_get_flag_from_type&&(t$)  
  end if
  get_type_flag_from_type&& = f
END FUNCTION

FUNCTION recurse_get_flag_from_type&& (t$)
STATIC l_type&&
if t$ > "" then
  if instr(t$, ".") then
    tn$ = strip_line$(mid$(t$, 1, instr(t$, ".") - 1))
    tl$ = strip_line$(mid$(t$, instr(t$, ".") + 1))
  else
    tn$ = strip_line$(t$)
    tl$ = ""
  end if
  if l_type&& > 0 then
    n = udt_xnext((l_type&& AND IS_UDT) / MAKE_UDT)
    DO while n
      print "Looping..."
      print "Tn:"; tn$; "    ename:";ucase$(udt_ename(n))
      if ucase$(strip_line$(udt_ename(n))) = ucase$(tn$) then
        l_type&& = udt_etype(n)
        print "recursing: "; tl$
        recurse_get_flag_from_type&& = recurse_get_flag_from_type&&(tl$)
        exit do
      end if
      n = udt_enext(n)
    loop
  else
    FOR x = 1 to last_type
      if ucase$(udt_xname(x)) = ucase$(tn$) then
        print "Recursing."
        l_type&& = MAKE_UDT * x
        recurse_get_flag_from_type&& = recurse_get_flag_from_type&&(tl$)
        exit for
      end if
    NEXT x
  end if
else
  recurse_get_flag_from_type&& = l_type&&
  l_type&& = 0
end if
END FUNCTION

FUNCTION get_type_from_type_flag$ (t AS _INTEGER64)
DIM tn AS _INTEGER64
tn = t AND MAKE_TYPE
if t AND IS_UDT then get_type_from_type_flag$ = udt_xname((t AND IS_UDT) / MAKE_UDT)
if t AND STRING_TYPE then
  t$ = "STRING"
  if (t AND STRING_SIZE) > 0 then
    t$ = t$ + " * " + strip_line$(str$(t AND STRING_SIZE))
  end if
  get_type_from_type_flag$ = t$
end if
if t AND IS_UNSIGNED then u$ = "_UNSIGNED "
if tn = BYTE_TYPE then get_type_from_type_flag$ = u$ + "_BYTE"
if tn = INTEGER_TYPE then get_type_from_type_flag$ = u$ + "INTEGER"
if tn = LONG_TYPE then get_type_from_type_flag$ = u$ + "LONG"
if tn = SINGLE_TYPE THEN get_type_from_type_flag$ = u$ + "SINGLE"
if tn = DOUBLE_TYPE then get_type_from_type_flag$ = u$ + "DOUBLE"
if tn = INTEGER64_TYPE then get_type_from_type_flag$ = u$ + "INTEGER64"
if tn = OFFSET_TYPE then get_type_from_type_flag$ = u$ + "_OFFSET"
if tn = FLOAT_TYPE then get_type_from_type_flag$ = u$ + "_FLOAT" 

END FUNCTION

FUNCTION qq$(s$)
qq$ = chr$(34) + s$ + chr$(34)
END FUNCTION

FUNCTION replace_with_case$(s$, r$, r2$)
if instr(ucase$(s$), ucase$(r$)) then
  s2$ = s$
  do WHILE instr(ucase$(s2$), ucase$(r$))
    l = instr(ucase$(s$), ucase$(r$))
    s2$ = mid$(s$,1, l - 1) + r2$ + mid$(s$, l + len(r$))
  loop
  replace_with_case$ = s2$
else 
  replace_with_case$ = s$
end if
END FUNCTION

FUNCTION file_already_included (file$)
  for x = 1 to included_file_count
    if included_files(x) = file$ then file_already_included = -1: exit function
  next x
END FUNCTION

SUB add_included_file (file$)
  included_file_count = included_file_count + 1
  if included_file_count >= UBOUND(included_files) then
    REDIM _PRESERVE included_files(ubound(included_files) + 100) AS STRING
  end if
  included_files(included_file_count) = file$
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

