
'$include:'mem_library/mem_lib.bi'

CONST GUI__QB64__SUB_FUNC_1 = 1
CONST GUI__QB64__SUB_FUNC_2 = 2

TYPE GUI_Object
  'f AS @sub (_OFFSET)
  f AS _UNSIGNED LONG
  fun AS @PROC
  'f as @sub
END TYPE

DIM o as _OFFSET

o = GUI_Object_new%&

@call(_OFFSET) @(o, GUI_Object.fun, @PROC), o 

'GUI__QB64__SUB__OFFSET @(o, GUI_Object.f, LONG), o

GUI_attach_func o, @SUB(FUNC_2)

'@(o, GUI_Object.f) = GUI__QB64__SUB_FUNC_2 AS LONG

@call(_OFFSET) @(o, GUI_Object.fun, @PROC), o


'GUI__QB64__SUB__OFFSET @(o, GUI_Object.f, LONG), o






FUNCTION GUI_Object_new%& ()
DIM o as _OFFSET
o = MEM_MALLOC%&(LEN(GUI_Object, TYPE))
'@(o, GUI_Object.f) = @SUB FUNC_1
GUI_attach_func o, @SUB(FUNC_1)
@(o, GUI_Object.f) = 2 AS LONG
GUI_Object_new%& = o
END FUNCTION

SUB GUI_attach_func (this as _OFFSET, f as _OFFSET)
@(this, GUI_Object.fun) = f
END SUB



SUB FUNC_1 (this as _OFFSET)
PRINT @(this, GUI_Object.f, LONG)
END SUB

SUB FUNC_2 (this as _OFFSET)
PRINT @(this, GUI_Object.f, LONG) * 4
END SUB

'SUB GUI__QB64__SUB__OFFSET (v as LONG, this as _OFFSET)
'SELECT CASE v
'  CASE 1
'    FUNC_1 this
'  case 2
'    FUNC_2 this
'END SELECT
'END SUB



'$include:'mem_library/mem_lib.bm'
