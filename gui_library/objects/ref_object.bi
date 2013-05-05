
@if not defined __GUI_OBJECTS_REF_OBJECT_BI__
@define __GUI_OBJECTS_REF_OBJECT_BI__

TYPE GUI_ref_object
  ref_count AS _UNSIGNED LONG
  delete AS @PROC ' SUB(_OFFSET)
END TYPE

@endif
