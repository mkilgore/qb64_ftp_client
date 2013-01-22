TYPE string_type
  mem AS _MEM
  length AS LONG
  allocated AS LONG
  is_allocated AS _BYTE
END TYPE

TYPE array_type
  mem AS _MEM
  length AS LONG
  allocated AS LONG
  is_allocated AS _BYTE
  element_size AS INTEGER
END TYPE
