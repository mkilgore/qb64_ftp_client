'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

FUNCTION FTP_Parse_Line (f AS filedir_type)
'Please see http://cr.yp.to/ftpparse.html
'Implementatin of that C code in QB64 (With some modifications)
f.flag_cwd = 0
f.flag_retr = 0
l$ = get_str$(f.lin)
length = LEN(l$)
IF LEN(l$) < 2 THEN EXIT FUNCTION 'Empty name
a$ = LCASE$(LEFT$(l$, 1))
SELECT CASE a$
  CASE "+" 'assume EPLF
  
  CASE "b", "c", "d", "l", "p", "s", "-" 'UNIX style
    'UNIX style is usually just a direct output from ls, which is meant to be human readable
    IF a$ = "d" THEN f.flag_cwd = -1
    IF a$ = "-" THEN f.flag_retr = -1
    IF a$ = "l" THEN f.flag_cwd = -1: f.flag_retr = -1
    
    state = 1
    i = 0
    FOR j = 2 TO length
      IF MID$(l$, j, 1) = " " AND MID$(l$, j - 1, 1) <> " " THEN
        SELECT CASE state
          CASE 1 'skip perm
            state = 2
          CASE 2 'skip nlink
            state = 3
            IF ((j - i) = 6) AND (MID$(l$, j, 1) = "f") THEN
              state = 4
            END IF
          CASE 3 'skip uid

            state = 4
          CASE 4 'get size

            f.size = VAL(MID$(l$, i, j - i))
            state = 5
          CASE 5 'find month

            month_val = get_month(LCASE$(MID$(l$, i, j - i)))

            IF month_val >= 0 THEN
              state = 6
            ELSE
              f.size = VAL(MID$(l$, i, j - i))
            END IF
          CASE 6

            mday = VAL(MID$(l$, i, j - i))
            state = 7
          CASE 7

            'if ((j - i) = 4) and (mid$(l$, i + 1, 1) = ":") then
            '  hours = val(mid$(l$, i, 1))
            '  minutes = val(mid$(l$, i + 2, 2))
            'elseif ((j - i) = 5) and (mid$(l$, 2, 1) = ":") then
            '  hours = val(mid$(l$, i, 2))
            '  minutes = val(mid$(l$, i + 3, 2))
            'elseif (j - i) >= 3 then
            '  year = val(mid$(l$, i, j - i))
            'else
            '  exit function
            'end if
            namelen = length - j
            name_str$ = RIGHT$(l$, namelen)
            put_str f.nam, name_str$
            state = 8
          CASE 8

            ' uh...
            ' Nothing left to do it seems. Not sure how we got here...
        END SELECT
        i = j + 1
        DO WHILE ((i < length) AND (MID$(l$, i, 1) = " "))
          i = i + 1
        LOOP
      END IF
    NEXT j
    IF state <> 8 THEN EXIT FUNCTION
    
    IF LEFT$(l$, 1) = "l" THEN
      'for i = 0 to 3 + namelen
      '  if left$(name_str$, 4) = " -> " then
      '    namelen = i
      '  end if
      'next i
      k = INSTR(name_str$, " -> ")
      name_str$ = MID$(name_str$, 1, k - 1)
      put_str f.nam, name_str$
      namelen = LEN(name_str$)
    END IF
    
    IF LEFT$(l$, 1) = " " OR LEFT$(l$, 1) = "[" THEN
      IF namelen > 3 THEN
        IF LEFT$(name_str$, 3) = "   " THEN
          name_str$ = MID$(name_str$, 4)
          put_str f.nam, name_str$
          namelen = namelen - 3
        END IF
      END IF
    END IF
    
    FTP_Parse_Line = -1
    EXIT FUNCTION
END SELECT

'MultiNet... What? Weird format...
FOR i = 1 TO length
  IF MID$(l$, i, 1) = ";" THEN
    EXIT FOR
  END IF
NEXT i

IF i < length THEN
  name_str$ = MID$(name_str$, 1, i)
  namelen = i
  put_str f.nam, name_str$
  IF i > 4 THEN
    IF MID$(l$, i - 4, 4) = ".DIR" THEN
      name_str$ = MID$(name_str$, 1, namelen - 4)
      namelen = namelen - 4
      f.flag_cwd = -1
      put_str f.nam, name_str$
    END IF
  END IF
  IF NOT f.flag_cwd THEN
    f.flag_retr = -1
  END IF
  put_str f.nam, name_str$
  
  FTP_Parse_Line = -1
  EXIT FUNCTION
END IF

'MSDOS Format
IF LEFT$(l$, 1) >= "0" AND LEFT$(l$, 1) <= "9" THEN
  i = 0
  j = 20
  
  'don't bother getting the date and time, I don't use it
  DO WHILE MID$(l$, j, 1) = " "
    j = j + 1
    IF j = length THEN EXIT FUNCTION
  LOOP
  IF MID$(l$, j, 1) = "<" THEN
    f.flag_cwd = -1
    DO WHILE MID$(l$, j, 1) <> " "
      j = j + 1
      IF j = length THEN EXIT FUNCTION
    LOOP
  ELSE
    i = j
    DO WHILE MID$(l$, j, 1) <> " "
      j = j + 1
      IF j = length THEN EXIT FUNCTION
    LOOP
    f.size = VAL(MID$(l$, i, j - i))
    f.flag_retr = -1
  END IF
  DO WHILE MID$(l$, j, 1) = " "
    j = j + 1
    IF j = length THEN EXIT FUNCTION
  LOOP
  namelen = length - j
  name_str$ = MID$(l$, j, namelen)
  put_str f.nam, name_str$
  FTP_Parse_Line = -1
  EXIT FUNCTION
END IF

FTP_Parse_Line = 0
END FUNCTION

FUNCTION get_month (m$)
DIM months$(12)
months$(1) = "jan"
months$(2) = "feb"
months$(3) = "mar"
months$(4) = "apr"
months$(5) = "may"
months$(6) = "jun"
months$(7) = "jul"
months$(8) = "aug"
months$(9) = "sep"
months$(10) = "oct"
months$(11) = "nov"
months$(12) = "dec"
IF LEN(m$) = 3 THEN
  FOR i = 1 TO 12
    IF m$ = months$(i) THEN get_month = i: EXIT FUNCTION
  NEXT i
END IF
get_month = -1
END FUNCTION

SUB sort_dir_listing (f() AS filedir_type, file_num)
'quicksort type of thing. First, move all of the DIR's to the top (Ignore listing 1, as it's always ".."
nex = 1
DO: nex = nex + 1: LOOP UNTIL NOT f(nex).flag_cwd OR nex = file_num 'loop until f(nex) is not a directory
m = nex + 1
IF m < file_num THEN
  FOR x = m TO file_num 'loop through files
    IF f(x).flag_cwd THEN 'found a directory
      SWAP f(nex), f(x) 'swap the directory we found with the first entry that's not a directory, so we move the directory to the top
      DO: nex = nex + 1: LOOP UNTIL NOT f(nex).flag_cwd OR nex > file_num 'find the next non-directory
      x = nex + 1
    END IF
  NEXT x
END IF
'nex now equals the very last DIRectory
'_AUTODISPLAY
'cls
'print "NEX="; nex
'print "X  ="; x
'sleep
IF nex > 4 AND nex < file_num - 1 THEN
  quick_sort_filedir_type f(), 2, nex - 1
END IF
IF nex < file_num - 1 THEN
  quick_sort_filedir_type f(), nex, file_num
END IF
END SUB

SUB quick_sort_filedir_type (f() AS filedir_type, low, high)
IF low < high THEN
  IF high - low = 1 THEN
    IF LCASE$(get_str$(f(low).nam)) > LCASE$(get_str$(f(high).nam)) THEN
      SWAP f(low), f(high)
    END IF
  ELSE
    pivot = INT(RND * (high - low + 1)) + low
    SWAP f(high), f(pivot)
    p$ = LCASE$(get_str$(f(high).nam))
    DO
      l = low
      h = high
      DO WHILE (l < h) AND (LCASE$(get_str$(f(l).nam)) <= p$)
        l = l + 1
      LOOP
      DO WHILE (h > l) AND (LCASE$(get_str$(f(h).nam)) >= p$)
        h = h - 1
      LOOP
      IF l < h THEN
        SWAP f(l), f(h)
      END IF
    LOOP WHILE l < h
    SWAP f(l), f(high)
    quick_sort_filedir_type f(), low, l - 1
    quick_sort_filedir_type f(), l + 1, high
  END IF
END IF
END SUB

