
'$include:'mem_library/mem_lib.bi'

'''''NOTE
'Implement "@(_OFFSET, TYPE)" -- Allow ommision of second parameter
'Change "!!endif" to "end if" for syntatical constancy

'Stages:
'

CONST PRO_VERSION$ = ".02"

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

REDIM SHARED sub_data$, in_sub, in_type, in_declare

DIM SHARED var_prefix$, mem_nam$, call_prefix$
DIM SHARED ptrs_file$

'var_prefix$ = "PARS__"
mem_nam$ = "PARS__QB64__EMPTY_MEM"
call_prefix$ = "c_"

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


'print "GOT HERE!"
'print "lines:"; next_line
'INPUT "sleep"; sleep_sleep$

FOR x = 1 TO next_line
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
  ELSEIF LEFT$(n$, 8) = "END TYPE" THEN
    'PRINT "Out of type!"
    in_type = 0
  END IF
  IF mod_flag THEN
    add_flag = 0
    'Found a modifier!
    n$ = strip_line$(n$)
    DO
      changed_flag = 0
      DO WHILE instr(ucase$(source(x)), "@SUB")
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
        add_src_line "$CHECKING:OFF", new_length, new_source()
        IF LEFT$(n$, 2) = "@(" THEN
          lef$ = MID$(n$, 1, INSTR(n$, "=") + 1)
          rit$ = MID$(n$, INSTR(n$, "=") + 1)
          
          lef$ = make_deref_into_sub$(lef$)
          rit$ = make_deref_into_func$(rit$)
    
          add_src_line lef$ + rit$, new_length, new_source()
        ELSE
          add_src_line make_deref_into_func$(n$), new_length, new_source()
        END IF
        add_src_line "$CHECKING:ON", new_length, new_source()
      end if
    LOOP until changed_flag = 0
    if add_flag then
      add_src_line source(x), new_length, new_source()
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


SUB add_const (c$, v$)
const_count = const_count + 1
IF const_count >= UBOUND(new_consts) THEN
  REDIM _PRESERVE new_CONSTS(UBOUND(new_consts) + 100) AS STRING
END IF
new_CONSTS(const_count) = "CONST " + c$ + " = " + v$
PRINT new_CONSTS(const_count)
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
PRINT "Define:"; MEM_get_str$(defines(define_count).value); " = "; v$
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
PRINT "TYPE:"; t$
PRINT "NAME:"; nam$
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

PRINT "File:"; file$
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
    print "new_dir:"; new_dir$
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
        print "FUNCTION:"; nam$; "  "; args$; "  "; typ$
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

FUNCTION make_deref_into_func$ (s$)
'STATIC loop_count
if instr(s$, "@(") = 0 then make_deref_into_func$ = s$: exit function

'loop_count = loop_count + 1
rit$ = s$

DO WHILE instr(rit$, "@(")
  l$ = mid$(rit$, 1, instr(rit$, "@(") - 1)
  
  c$ = mid$(rit$, instr(rit$, "@(") + 2)
  c$ = mid$(c$, 1, instr(c$, ")") - 1)
  
  'ex$ = mid$(rit$, instr(rit$, "@(") + 2)
  'ex$ = mid$(ex$, instr(ex$, ")") + 1)
  'ex$ = ltrim$(rtrim$(mid$(ex$, 1, instr(ex$, " ") - 1)))
  
  r$ = mid$(rit$, instr(rit$, "@(") + 2)
  r$ = mid$(r$, instr(r$, ")") + 1)
  
  off$ = ltrim$(rtrim$(mid$(c$, instr(c$, "@(") + 1)))
  off$ = ltrim$(rtrim$(mid$(off$, 1, instr(off$, ",") - 1)))
  'off$ = make_deref_into_func$(off$)
  ele$ = ltrim$(rtrim$(mid$(c$, instr(c$, ",") + 1))) 
  ele$ = rtrim$(mid$(ele$, 1, instr(ele$, ",") - 1))
  
  typ$ = ltrim$(rtrim$(mid$(c$, instr(c$, ",") + 1)))
  typ$ = rtrim$(ltrim$(mid$(typ$, instr(typ$, ",") + 1)))
  
  'print "off:"; off$
  'print "ele:"; ele$
  'print "typ:"; typ$
  'print "R:"; r$
  'print "l:"; l$
  'add_func_var var_prefix$  + off$ + "_" + typ$, typ$
  'add_src_line "$CHECKING:OFF" + line_end$ + "_MEMGET " + mem_nam$ + ", " + off$ + ", " + var_prefix$ + off$ + "_" + typ$ + line_end$ + "$CHECKING:ON" + line_end$, new_length, new_source()
  'add_src_line , new_length, new_source()
  'add_src_line , new_length, new_source()
  rit$ = l$ + "_MEMGET(" + mem_nam$ + ", " + off$ + " + _OFFSET(" + ele$ + ", TYPE), " + typ$ + ") " + r$

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
end sub

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
if flag = 0 then reg_arg(sub_args(sub_count))
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
print "Parsing"
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
  
  print "Arg4:"; arg4$
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
func_args(function_count) = parse_args$(args$)
func_type(function_count) = ret$
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

PRINT "Adding pointers"
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
  print #255, "  FUNCTION " + var_prefix$ + call_prefix$; func_diff_arg_type(x); "_"; replace$(func_diff_arg_list(x), chr$(13), "_"); get_suffix_from_type$(func_type(x)); "( BYVAL va AS _OFFSET, ";
  a$ = func_diff_arg_list(x)
  c = 65
  DO until instr(a$, chr$(13)) <= 0
    print #255, chr$(c) + " AS " + mid$(a$, 1, instr(a$, chr$(13)) - 1) + ", ";
    a$ = mid$(a$, instr(a$, chr$(13)) + 1)
    c = c + 1
  LOOP 
  if a$ > "" then print #255, chr$(c) + " AS " + a$;
  print #255, ")" + line_end$;
  print #256, get_c_type_from_qb_type$(func_type(x)); " "; var_prefix$; call_prefix$; func_diff_arg_type(x); "_"; replace$(func_diff_arg_list(x), chr$(13), "_"); "( void* func, ";
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
if instr(s2$, "AS") then
  s3$ = mid$(s2$, instr(s2$, "AS") + 3)
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

'$include:'mem_library/mem_lib.bm'
