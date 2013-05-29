
'$include:'obj_library/std_objects.bi'

TYPE test_iface @interface
  prt  AS @SUB(LONG)
  fct  AS @FUNCTION(LONG) AS LONG
END TYPE

TYPE GUI_obj
  parent as OBJ_Object
  v as LONG
END TYPE

TYPE GUI_obj_class @class
  parent_class AS OBJ_Object_class
END TYPE

DIM o as _OFFSET

o = OBJ_type_allocate_new%&(GUI_obj_get_type&)

k = @( @(this, OBJ_Object.vtable), GUI_obj_class.parent_class)

m = @(this, LONG)

@(this, GUI_obj.v) = 20

END


FUNCTION test_iface_get_type&() 
  STATIC added AS LONG
  if added = 0 then
    DIM i as OBJ_type_interface
    i.size = LEN(test_iface, TYPE)
    added = OBJ_type_register_interface&(i)
  end if
  test_iface_get_type& = added
END FUNCTION

FUNCTION GUI_obj_get_type& ()
  STATIC added AS LONG
  if added = 0 then
    DIM i as OBJ_type_info
    i.base_size = LEN(GUI_Obj, TYPE)
    i.class_size = LEN(GUI_Obj_class, TYPE)
    i.parent = OBJ_Object_get_type&
    i.init = @SUB(GUI_obj_init)
    i.class_init = @SUB(GUI_obj_class_init)
    i.destroy = @SUB(GUI_obj_destroy)
    added = OBJ_type_register_type&(i)
  end if
  GUI_obj_get_type& = added
END FUNCTION

SUB GUI_obj_init (this as _OFFSET)

END SUB

SUB GUI_obj_class_init (class as _OFFSET)
DIM o as _OFFSET

o = OBJ_type_add_interface_to_class%&(class, test_iface_get_type&)

END SUB

SUB GUI_obj_destroy (this as _OFFSET)

END SUB

'$include:'obj_library/std_objects.bm'

