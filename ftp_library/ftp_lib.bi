TYPE filedir_type
  'NOTE to myself -- GET RID OF DIR, not needed (Just check the flags, replace DIR in the printing sub, etc..
  dir AS STRING * 3 ' = "DIR" or "LNK" or ""
  nam AS string_type
  flag_cwd AS INTEGER 'dir flag
  flag_retr AS INTEGER 'file flag
  size AS LONG
  lin AS string_type
END TYPE

COMMON SHARED is_connected AS INTEGER
