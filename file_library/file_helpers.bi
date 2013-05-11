
CONST FILE_IS_DIR = 1
CONST FILE_IS_FILE = 2

DECLARE CUSTOMTYPE LIBRARY "direntry"
  FUNCTION FILE_load_dir& ALIAS load_dir (s as STRING)
  FUNCTION FILE_has_next_entry& alias has_next_entry()
  SUB FILE_close_dir alias close_dir()
  SUB FILE_get_next_entry alias get_next_entry(s as STRING, flags AS LONG, file_size AS LONG)
END DECLARE

DECLARE LIBRARY "unistd"
  SUB FILE_getcwd alias getcwd(s as STRING, BYVAL l as LONG)
END DECLARE

TYPE FILE_filedir
  nam AS MEM_string
  flags AS _BYTE
  size AS LONG
  lin AS MEM_string
END TYPE


