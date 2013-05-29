
!!define __DEBUG__

'$include:'obj_library/std_objects.bi'


DIM text as _OFFSET

text = OBJ_T("Hi!")

PRINT OBJ_T_get$(text)
OBJ_T_set text, "HI HI"
PRINT OBJ_t_get$(text)
handle_text text


SUB handle_text(t as _OFFSET)
DIM tex as _OFFSET
tex = OBJ_ref_Object_get_ref(t) 'Get a ref
PRINT OBJ_t_get$(tex)
OBJ_ref_Object_release_ref(tex) 'Release ref
END SUB

'$include:'obj_library/std_objects.bm'

