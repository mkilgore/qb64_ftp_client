


$SCREENHIDE
$CONSOLE

_DEST _CONSOLE

REDIM SHARED source(500) AS STRING'AS MEM_string, next_line AS LONG
DIM SHARED next_line AS LONG
REDIM SHARED new_source(500) AS STRING
DIM SHARED new_length AS LONG

REDIM SHARED new_CONSTS(500) AS STRING, const_count AS LONG
REDIM SHARED reg_types(100) AS STRING, reg_count(100) AS LONG, reg_total_count AS LONG
REDIM SHARED flag_functions(500) AS STRING, func_count AS LONG
REDIM SHARED defines(500) AS STRING, def_val(500) AS STRING, define_count AS LONG
DIM SHARED line_end$, slash$

REDIM SHARED new_func_vars(500) AS STRING, new_func_types(500) AS STRING, new_func_vars_count AS LONG
'REDIM SHARED mem_get_line(500) AS STRING
REDIM SHARED sub_data$, in_sub, in_type, in_declare
DIM SHARED var_prefix$, mem_nam$

var_prefix$ = "GUI__QB64__"
mem_nam$ = "GUI__QB64__EMPTY_MEM"

in_type = 0
in_declare = 0
in_sub = 0
sub_data$ = ""
type_nam$ = ""


line_end$ = chr$(13) + chr$(10)

if instr(_OS$, "[WINDOWS]") then
  add_define "__OS__", "WINDOWS"
  slash$ = "\"
elseif instr(_os$, "[MACOSX]") then
  add_define "__OS__", "MACOSX"
  slash$ = "/"
elseif instr(_os$, "[LINUX]") then
  add_define "__OS__", "LINUX"
  slash$ = "/"
end if

if instr(_OS$, "[32BIT]") then
  add_define "__BITS__", "32"
else  
  add_define "__BITS__", "64"
end if


di$ = get_dir$(command$)
fi$ = get_file$(command$)
CHDIR di$

ex$ = mid$(fi$, instr(fi$, ".") + 1)
nam$ = mid$(fi$, 1, instr(fi$, ".") - 1)


OPEN nam$ + "_OUTPUT." + ex$ for output as #255

load_file fi$, di$


'print "GOT HERE!"
'print "lines:"; next_line
'INPUT "sleep"; sleep_sleep$

FOR x = 1 to next_line
  n$ = strip_line$(UCASE$(source(x))) 'MEM_get_str$(source(x)))
  'PRINT "LOOP"
  'print "X="; n$
  'input "sleep"; sleep_sleep$
  s$ = n$
  mod_flag = 0
  in_quote = 0
  DO
    if instr(s$, chr$(34)) then
      c$ = mid$(s$, 1, instr(s$, chr$(34)) - 1)
      s$ = mid$(s$, instr(s$, chr$(34)) + 1)
    else
      c$ = s$
      s$ = ""
    end if
    if in_quote = 0 and instr(c$, "@") then
      mod_flag = -1
    end if
    if s$ > "" then
      in_quote = NOT in_quote
    end if
  LOOP until s$ = ""
  if left$(n$, 11) = "END DECLARE" then
    in_declare = 0
  end if
  
  if left$(n$, 7) = "DECLARE" then
    in_declare = -1
  end if

  if (left$(n$, 7) = "END SUB" or left$(n$, 13) = "END FUNCTION" ) AND NOT in_declare then
    in_sub = 0
    FOR k = 1 to new_func_vars_count
      add_src_line "DIM " + new_func_vars(k) + " AS " + new_func_types(k), new_length, new_source()
      'add_src_line mem_get_line(k), new_length, new_source()
    next k
    add_src_line sub_data$, new_length, new_source()
    'add_src_line source(x), new_length, new_source()
    sub_data$ = ""
  end if
  if left$(n$, 4) = "TYPE" then
    PRINT "In type!"
    in_type = -1
    type_nam$ = strip_line$(mid$(n$, 5))
  elseif left$(n$, 8) = "END TYPE" then
    PRINT "Out of type!"
    in_type = 0
  end if
  if mod_flag then
    'Found a modifier!
    n$ = strip_line$(n$)
    if mid$(n$, 2, len("REGISTER")) = "REGISTER" then
      add_reg n$
    elseif mid$(n$, 2, len("DEFINE_BITFLAGS")) = "DEFINE_BITFLAGS" then
      nam$ = mid$(n$, instr(n$, " ") + 1)
      value& = 1
      DO
        x = x + 1
        n$ = strip_line$(ucase$(source(x)))
        un$ = ucase$(n$)
        getter = 0
        setter = 0
        if instr(un$, "@GET") or instr(un$, "@SET") then
          if instr(un$, "@GET") then getter = -1
          if instr(un$, "@SET") then setter = -1
          n$ = mid$(n$, 1, instr(n$, " ") - 1)
        end if
        if n$ <> "@END_BITFLAGS" then
          add_const nam$ + "_FLAG_" + n$, LTRIM$(RTRIM$(STR$(value&)))
          if getter then add_func "FUNCTION " + ucase$(nam$) + "_CFLAG_" + n$ + "(this as _OFFSET): " + ucase$(nam$) _
            + "_CFLAG_" + n$ + " = MEM_long_from_off&(this + _OFFSET(" + nam$ + ".flags, TYPE)) AND " + LTRIM$(RTRIM$(STR$(value&))) + line_end$ + "END FUNCTION"
          if setter then add_func "SUB " + ucase$(nam$) + "_FLAG_SET_" + n$ + "(this as _OFFSET)" + line_end$ + "$CHECKING:OFF" + line_end$ _
            + " _MEMPUT " + mem_nam$ + ", this, MEM_long_from_off&(this + _OFFSET(" + nam$ + ".flags, TYPE)) OR " + LTRIM$(RTRIM$(STR$(value&))) + " AS LONG" + line_end$ + "$CHECKING:ON" + line_end$ + "END SUB"
          if setter then add_func "SUB " + ucase$(nam$) + "_FLAG_UNSET_" + n$ + "(this as _OFFSET)" + line_end$ + "$CHECKING:OFF" + line_end$ _
            + " _MEMPUT " + mem_nam$ + ", this, MEM_long_from_off&(this + _OFFSET(" + nam$ + ".flags, TYPE)) AND NOT " + LTRIM$(RTRIM$(STR$(value&))) + " AS LONG" + line_end$ + "$CHECKING:ON" + line_end$ + "END SUB"
          if setter then add_func "SUB " + ucase$(nam$) + "_FLAG_TOGGLE_" + n$ + "(this as _OFFSET)" + line_end$ + "$CHECKING:OFF" + line_end$ _
            + " _MEMPUT " + mem_nam$ + ", this, MEM_long_from_off&(this + _OFFSET(" + nam$ + ".flags, TYPE)) XOR " + LTRIM$(RTRIM$(STR$(value&))) + " AS LONG" + line_end$ + "$CHECKING:ON" + line_end$ + "END SUB"
          
          value& = value& * 2
        end if
      LOOP WHILE n$ <> "@END_BITFLAGS"
    elseif instr(n$, "@GET") or instr(n$, "@SET") then
      print "Got here:"; n$
      if instr(n$, "@GET") then getter = -1 else getter = 0
      if instr(n$, "@SET") then setter = -1 else setter = 0
      if in_type then
        v$ = left$(n$, instr(n$, " ") - 1)
        t$ = mid$(n$, instr(n$, "AS") + 3)
        t$ = rtrim$(mid$(t$, 1, instr(t$, "@") - 1))
        print "V:"; v$; " T:"; t$
        if setter then add_func "SUB " + type_nam$ + "_SET_" + v$ + "(this as _OFFSET, a AS " + t$ + ")" _
          + line_end$ + "$CHECKING:OFF" + line_end$ + "_MEMPUT " + mem_nam$ + ", this + _OFFSET(" + type_nam$ + "." + v$ + ", TYPE), a" _
          + line_end$ + "$CHECKING:ON" + line_end$ + "END SUB"
        if getter then add_func "SUB " + type_nam$ + "_GET_" + v$ + "(this as _OFFSET, a AS " + t$ + ")" _
          + line_end$ + "$CHECKING:OFF" + line_end$ + "_MEMGET " + mem_nam$ + ", this + _OFFSET(" + type_nam$ + "." + v$ + ", TYPE), a" _
          + line_end$ + "$CHECKING:ON" + line_end$ + "END SUB"
        print "Adding line:"; v$; " AS "; t$
        add_src_line v$ + " AS "+ t$, new_length, new_source()
      end if
    elseif instr(n$, "@(") then
      add_src_line "$CHECKING:OFF", new_length, new_source()
      if left$(n$, 2) = "@(" then 
        lef$ = mid$(n$, 1, instr(n$, "=") + 1)
        rit$ = mid$(n$, instr(n$, "=") + 1)
        
        lef$ = make_deref_into_sub$(lef$)
        rit$ = make_deref_into_func$(rit$)
  
        add_src_line lef$ + rit$, new_length, new_source()
      else 
        add_src_line make_deref_into_func$(n$), new_length, new_source()
      end if
      add_src_line "$CHECKING:ON", new_length, new_source()
    end if
  else
    add_src_line source(x), new_length, new_source()
  end if
    
  if (left$(n$, 4) = "SUB " or left$(n$, 9) = "FUNCTION " ) and not in_declare then
    clear_func_vars
    sub_data$ = ""
    'add_src_line source(x), new_length, new_source()
    in_sub = -1
  end if
NEXT x

print #255, "DIM SHARED " + mem_nam$ + " AS _MEM"
FOR x = 1 to const_count
  PRINT #255, new_consts(x)
next x

for x = 1 to new_length
  print #255, new_source(x)
next x

for x = 1 to func_count
  print #255, flag_functions(x)
next x
close #255

system


SUB add_const(c$, v$)
const_count = const_count + 1
if const_count >= UBOUND(new_consts) then
  REDIM _PRESERVE new_consts(ubound(new_consts) + 100) AS STRING
end if
new_consts(const_count) = "CONST " + c$ + " = " + v$
print new_consts(const_count)
END SUB

SUB add_func (f$)
func_count = func_count + 1
if func_count >= UBOUND(flag_functions) then
  REDIM _PRESERVE flag_functions(ubound(flag_functions) + 100) AS STRING
end if
flag_functions(func_count) = f$
'print flag_functions(func_count)
END SUB

SUB add_define (d$, v$)
define_count = define_count + 1

if define_count >= UBOUND(defines) then
  REDIM _PRESERVE defines(define_count + 100) AS STRING
  REDIM _PRESERVE def_val(define_count + 100) AS STRING
end if
defines(define_count) = d$
def_val(define_count) = v$
print "Define:"; defines(define_count); " = "; v$
END SUB

FUNCTION find_define (d$)
ud$ = ucase$(d$)
for x = 1 to define_count
  if defines(x) = ud$ then
    find_define = x: exit function
  end if
next x
find_define = -1
END FUNCTION

SUB add_Reg (n$)
k$ = mid$(n$, len("REGISTER") + 3)
t$ = mid$(k$, 1, instr(k$, " ") - 1)
nam$ = mid$(k$, instr(k$, " ") + 1)
print "TYPE:"; t$
print "NAME:"; nam$
flag =0
for x = 1 to reg_total_count
  if t$ = reg_types(x) then
    flag = -1
    reg_count(x) = reg_count(x) + 1
    add_const nam$, RTRIM$(LTRIM$(STR$(reg_count(x))))
    exit for
  end if
next x
if flag = 0 then
  reg_total_count = reg_total_count + 1
  if reg_total_count >= UBOUND(reg_types) then
    REDIM _PRESERVE reg_types(UBOUND(reg_types) + 20) AS STRING
    REDIM _PRESERVE reg_count(UBOUND(reg_count) + 20) AS LONG
  end if
  reg_count(reg_total_count) = 1
  reg_types(reg_total_count) = t$
  add_const nam$, RTRIM$(LTRIM$(STR$(1)))
end if
END SUB

SUB add_src_line (l$, count AS LONG, sour() AS STRING)
if in_sub = 0 then
  count = count + 1
  if count >= UBOUND(sour) then
    add_source_lines 100, sour()
  end if
  'print "Next_line:"; l$
  sour(count) = l$
else 
  sub_data$ = sub_data$ + l$ + line_end$
end if
end sub

FUNCTION strip_line$(l$)
strip_line$ = LTRIM$(RTRIM$(l$))
END FUNCTION

SUB load_file(file$, old_dir$)
DIM fnum as LONG
fnum = FREEFILE
'print "F="; fnum

print "File:"; file$
OPEN file$ for INPUT as #fnum

process_line = -1
if_count = 0
last_if = 0


DO
  LINE INPUT #fnum, l$
  ls$ = strip_line$(l$)
  uls$ = ucase$(ls$)
  if left$(uls$, 3) = "@IF" then if_count = if_count + 1
  
  if left$(uls$, 3) = "@IF" and process_line or left$(uls$, 7) = "@ELSEIF" and if_count = last_if then
    last_if = if_count
    uls$ = mid$(uls$, instr(uls$, " ") + 1)
    s$ = mid$(uls$, 1, instr(uls$, " ") - 1)
    not_flag = 0
    print "IF statement:"
    if s$ = "NOT" then
      print "Not flag found!"
      not_flag = -1
      uls$ = mid$(uls$, instr(uls$, " ") + 1)
      s$ = mid$(uls$, 1, instr(uls$, " ") - 1)
      print "S="; s$
    end if
    if s$ = "DEFINED" then
      print "Checking IF Defined"
      d2$ = mid$(uls$, instr(uls$, " ") + 1)
      c = find_define(d2$)
      print "C="; c
      if c > 0 then process_line = NOT not_flag
      if c = -1 then process_line = not_flag
    elseif instr(uls$, "=") then
      'd$ = mid$(uls$, instr(uls$, " ") + 1)
      d$ = s$ 'strip_line$(mid$(d$, 1, instr(d$, "=") - 1))
      de = find_define(d$)
      d2$ = strip_line$(mid$(uls$, instr(uls$, "=") + 1))
      de2 = find_define(d2$)
      if de > 0 then
        v$ = def_val(de)
      else 
        v$ = strip_quote$(d$)
      end if
      if de2 > 0 then
        v2$ = def_val(de2)
      else 
        v2$ = strip_quote$(d2$)
      end if
      print "D1:"; d$
      print "D2:"; d2$
      print "V1:"; v$
      print "V2:"; v2$
      if v$ = v2$ then
        process_line = NOT not_flag
      else 
        process_line = not_flag
      end if
    end if
  elseif left$(uls$, 5) = "@ELSE" and process_line then
    process_line = NOT process_line
  elseif left$(uls$, 6) = "@ENDIF" and last_if = if_count then
    process_line = -1
  elseif process_line and left$(uls$, 6) <> "@ENDIF" and left$(uls$, 5) <> "@ELSE" then
    if left$(uls$, 8) = "@DEFINE " then
      d2$ = mid$(uls$, instr(uls$, " ") + 1)
      if instr(d2$, " ") then
        d$ = mid$(d2$, 1, instr(d2$, " ") - 1)
        v$ = mid$(d2$, instr(d2$, " ") + 1)
      else 
        d$ = d2$
        v$ = ""
      end if
      add_define d$, v$
    elseif left$(lcase$(ls$), len("'$include:'")) = "'$include:'" then
      fil$ = mid$(ls$, 12)
      fil$ = left$(fil$, len(fil$) - 1)
      new_file$ = get_file$(fil$)
      new_dir$ = get_dir$(fil$)
      print "NEW FILE:"; new_file$
      print "NEW DIR:"; new_dir$
      'print "File:"; fil$
      'di$ = get_cur_dir$
      if new_dir$ > "" then
        chdir new_dir$
      end if
      load_file new_file$, new_dir$
      if new_dir$ > "" then
        CHDIR old_dir$
      end if
    else
      add_src_line l$, next_line, source()
    end if
  end if
  if left$(uls$, 6) = "@ENDIF" then if_count = if_count - 1
LOOP UNTIL EOF(fnum)
CLOSE #fnum
PRINT "Closed file!"
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
print "DIR:"; c$
get_dir$ = c$
END FUNCTION

FUNCTION get_file$(f$)
c$ = ""
f2$ = f$
DO
  c$ = c$ + left$(f2$, instr(f2$, slash$))
  f2$ = mid$(f2$, instr(f2$, slash$) + 1)
LOOP until instr(f2$, slash$) = 0
print "FILE:"; f2$
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
  
  print "off:"; off$
  print "ele:"; ele$
  print "typ:"; typ$
  print "R:"; r$
  print "l:"; l$
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

