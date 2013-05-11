
'$include:'mem_library/mem_lib.bi'
'$include:'file_library/file_helpers.bi'

DIM file_list(200) AS FILE_filedir, count AS LONG

print "CWD:"; get_new_dir$
sleep

FILE_get_files ".", file_list(), count

FILE_sort_dir_listing file_list(), count

FOR x = 0 to count
  print MEM_get_str$(file_list(x).nam); file_list(x).flags
  if x mod 22 = 0 then sleep
next x
end

'$include:'mem_library/mem_lib.bm'
'$include:'file_library/file_helpers.bm'
