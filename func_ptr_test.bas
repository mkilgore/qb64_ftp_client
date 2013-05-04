
'$include:'mem_library/mem_lib.bi'

CONST GUI__QB64__SUB_FUNC_1 = 1
CONST GUI__QB64__SUB_FUNC_2 = 2

TYPE GUI_Object
  'f AS @sub (_OFFSET)
  f AS _UNSIGNED LONG
END TYPE

DIM o as _OFFSET

o = GUI_Object_new%&

@call @(o, GUI_Object.f, LONG) o 

GUI__QB64__SUB__OFFSET @(o, GUI_Object.f, LONG), o

@(o, GUI_Object.f) = @SUB FUNC_2

@(o, GUI_Object.f) = GUI__QB64__SUB_FUNC_2 AS LONG

GUI__QB64__SUB__OFFSET @(o, GUI_Object.f, LONG), o






FUNCTION GUI_Object_new%& ()
DIM o as _OFFSET
o = MEM_MALLOC%&(LEN(GUI_Object, TYPE))
'@(o, GUI_Object.f) = @SUB FUNC_1
@(o, GUI_Object.f) = GUI__QB64__SUB_FUNC_1 AS LONG
GUI_Object_new%& = o
END FUNCTION



SUB FUNC_1 (this as _OFFSET)
PRINT 1
END SUB

SUB FUNC_2 (this as _OFFSET)
PRINT 2
END SUB

SUB GUI__QB64__SUB__OFFSET (v as LONG, this as _OFFSET)
SELECT CASE v
  CASE 1
    FUNC_1 this
  case 2
    FUNC_2 this
END SELECT
END SUB



'$include:'mem_library/mem_lib.bm'
