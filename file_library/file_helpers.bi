CONST IS_DIR = 1
CONST IS_FILE = 2

DECLARE CUSTOMTYPE LIBRARY "direntry"
  FUNCTION FILE_load_dir& ALIAS load_dir (s as STRING)
  FUNCTION FILE_has_next_entry& alias has_next_entry()
  SUB FILE_close_dir alias close_dir()
  SUB FILE_get_next_entry alias get_next_entry(s as STRING, flags AS LONG, file_size AS LONG)
END DECLARE

TYPE filedir_type
  nam AS MEM_string_type
  flag_cwd AS INTEGER 'dir flag
  flag_retr AS INTEGER 'file flag
  size AS LONG
  lin AS MEM_string_type
END TYPE

