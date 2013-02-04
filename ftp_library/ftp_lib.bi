'FTP Client
'Copyright Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.
TYPE filedir_type
  'NOTE to myself -- GET RID OF DIR, not needed (Just check the flags, replace DIR in the printing sub, etc..
  'dir AS STRING * 3 ' = "DIR" or "LNK" or ""
  nam AS MEM_string_type
  flag_cwd AS INTEGER 'dir flag
  flag_retr AS INTEGER 'file flag
  size AS LONG
  lin AS MEM_string_type
END TYPE

COMMON SHARED is_connected AS INTEGER
