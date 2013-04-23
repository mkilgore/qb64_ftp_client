TYPE SUB_FUNC_TYPE
  
END TYPE



FUNC_CPP = 1
OUT_BAS = 2
IN_BAS = 3


OPEN "ptrs.h" FOR OUTPUT AS #func_cpp
open "output.bas" FOR OUTPUT AS #out_bas

PRINT #out_bas, "DECLARE LIBRARY " + chr$(34) + "ptrs.h" + chr$(34)
PRINT #out_bas, "  FUNCTION GUI_get_func_ptr%& (n as LONG)"
PRINT #out_bas, "  SUB GUI_call_func_ptr (func as _OFFSET)"
PRINT #out_bas, "END DECLARE"
