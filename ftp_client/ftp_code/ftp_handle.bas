'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

SUB change_remote_dir (dir$) 'Changes the remote directory to the selected dir
IF is_connected THEN
  ch$ = "CWD " + LTRIM$(RTRIM$(dir$)) + crlf$
  PUT command_connect&, , ch$
  a$ = get_response_code$
  SELECT CASE LEFT$(a$, 3)
    CASE "500", "501", "502", "550", "530"
      dialog_disp "Error: The FTP server won't let you change the directory."
    CASE "421"
      dialog_disp "Error: FTP server disconnected."
      is_connected = 0
      CLOSE command_connect&
  END SELECT
ELSEIF cmd_mode THEN PRINT "Please connect to a FTP server first."
END IF
END SUB

SUB refresh_Local_files () 'Refreshes the local file listing
boxes(1).length = 1
boxes(1).selected = 1
boxes(1).offset = 0
put_str Local_files(boxes(1).length).nam, ".."
Local_files(boxes(1).length).dir = "DIR"
Local_files(boxes(1).length).flag_cwd = -1
Local_files(boxes(1).length).flag_retr = 0
IF opper$ = "NIX" THEN
  IF show_hidden_local THEN h$ = "a" ELSE h$ = ""
  SHELL _HIDE "ls -F" + h$ + " > /tmp/dirtmp.tmp"
  OPEN "/tmp/dirtmp.tmp" FOR INPUT AS #1
  DO WHILE NOT EOF(1)
    LINE INPUT #1, a$
    IF a$ > "" THEN
      IF RIGHT$(a$, 1) = "/" AND a$ <> "../" AND a$ <> "./" THEN
        boxes(1).length = boxes(1).length + 1
        put_str Local_files(boxes(1).length).nam, a$
        Local_files(boxes(1).length).dir = "DIR"
        Local_files(boxes(1).length).flag_cwd = -1
        Local_files(boxes(1).length).flag_retr = 0
      END IF
      IF RIGHT$(a$, 1) = "@" THEN
        boxes(1).length = boxes(1).length + 1
        put_str Local_files(boxes(1).length).nam, LEFT$(a$, LEN(a$) - 1) + "/"
        Local_files(boxes(1).length).dir = "DIR"
        Local_files(boxes(1).length).flag_cwd = -1
        Local_files(boxes(1).length).flag_retr = 0
      END IF
    END IF
  LOOP
  CLOSE #1

  OPEN "/tmp/dirtmp.tmp" FOR INPUT AS #1
  DO WHILE NOT EOF(1)
    LINE INPUT #1, a$
    IF a$ > "" THEN
      IF RIGHT$(a$, 1) <> "/" AND RIGHT$(a$, 1) <> "@" THEN
        IF RIGHT$(a$, 1) = "*" THEN a$ = LEFT$(a$, LEN(a$) - 1)
        boxes(1).length = boxes(1).length + 1
        put_str Local_files(boxes(1).length).nam, a$
        Local_files(boxes(1).length).dir = ""
        Local_files(boxes(1).length).flag_cwd = 0
        Local_files(boxes(1).length).flag_retr = -1
      END IF
    END IF
  LOOP
  CLOSE #1
  KILL "/tmp/dirtmp.tmp"
ELSE 'I guess I better add that Windows code at some point...
  SHELL _HIDE "cmd /c DIR " + CHR$(34) + Local_dir$ + CHR$(34) + " /A:D /B > " + temp_dir$ + sep$ + "dirtmp.tmp"
  SHELL _HIDE "cmd /c DIR " + CHR$(34) + Local_dir$ + CHR$(34) + " /A:-D /B > " + temp_dir$ + sep$ + "filetmp.tmp"
  OPEN temp_dir$ + sep$ + "filetmp.tmp" FOR INPUT AS #1
  IF NOT EOF(1) THEN
    DO
      LINE INPUT #1, file$
      boxes(1).length = boxes(1).length + 1
      put_str Local_files(boxes(1).length).nam, file$
      Local_files(boxes(1).length).dir = ""
      Local_files(boxes(1).length).flag_cwd = 0
      Local_files(boxes(1).length).flag_retr = -1
    LOOP UNTIL EOF(1)
  END IF
  CLOSE #1
  KILL temp_dir$ + sep$ + "filetmp.tmp"
  OPEN temp_dir$ + sep$ + "dirtmp.tmp" FOR INPUT AS #1
  IF NOT EOF(1) THEN
    DO
      LINE INPUT #1, dir$
      boxes(1).length = boxes(1).length + 1
      put_str Local_files(boxes(1).length).nam, dir$ + sep$
      Local_files(boxes(1).length).dir = "DIR"
      Local_files(boxes(1).length).flag_cwd = -1
      Local_files(boxes(1).length).flag_retr = 0
    LOOP UNTIL EOF(1)
    CLOSE #1
  END IF
  KILL temp_dir$ + sep$ + "dirtmp.tmp"

END IF
sort_dir_listing Local_files(), boxes(1).length
print_files boxes(1), Local_files()
END SUB

SUB get_new_dir () 'Uses SHELL to get the current dir
IF opper$ = "NIX" THEN
  SHELL _HIDE "pwd > /tmp/dirtmp.tmp"
  OPEN "/tmp/dirtmp.tmp" FOR INPUT AS #1
  LINE INPUT #1, Local_dir$
  CLOSE #1
  KILL "/tmp/dirtmp.tmp"
ELSEIF opper$ = "WIN" THEN
  SHELL _HIDE "cd > " + temp_dir$ + sep$ + "cdtemp.tmp"
  OPEN temp_dir$ + sep$ + "cdtemp.tmp" FOR INPUT AS #1
  LINE INPUT #1, Local_dir$
  CLOSE #1
  KILL temp_dir$ + sep$ + "cdtemp.tmp"
END IF
END SUB

SUB send_file (file$) 'Sends local file to FTP server -- NOT IMPLEMENTED YET
IF NOT cmd_mode THEN
  DIM box AS box_type
  'box.nam = "Send File"
  put_str box.nam, "Send File"
  box.row1 = _HEIGHT(0) \ 2 - 1
  box.row2 = _HEIGHT(0) \ 2 + 1
  box.col1 = _WIDTH(0) \ 2 - 25
  box.col2 = _WIDTH(0) \ 2 + 25
  box.shadow = -1
  box.c1 = box_c1
  box.c2 = box_c2
  box.text_box = -1
  draw_box box, 0
END IF
text$ = "Sending files is not yet possible, sorry."
'IF is_connected THEN IF Local_files(boxes(1).selected).dir = "DIR" THEN text$ = "Error: Please select a file, not a directory." ELSE text$ = "Sending file..." ELSE text$ = "Please connect to a FTP Server first."
IF NOT cmd_mode THEN LOCATE box.row1 + 1, _WIDTH(0) \ 2 - LEN(text$) \ 2
PRINT text$
IF NOT cmd_mode THEN _DISPLAY
t# = TIMER
IF NOT cmd_mode THEN DO: _LIMIT 100: LOOP UNTIL INKEY$ > "" OR TIMER - t# > 2
EXIT SUB

IF is_connected = 0 OR NOT Local_files(boxes(1).selected).flag_retr THEN
  t# = TIMER
  DO: _LIMIT 100: LOOP UNTIL INKEY$ > "" OR TIMER - t# > 1
  EXIT SUB
END IF
start_PASV_mode
typei$ = "TYPE I" + crlf$
PUT command_connect&, , typei$
DO: _LIMIT 1000
  GET command_connect&, , b$
  b2$ = b2$ + b$
LOOP UNTIL INSTR(b2$, crlf$)
stor$ = "STOR " + RTRIM$(get_str$(Local_files(boxes(1).selected).nam)) + crlf$
PUT command_connect&, , stor$
DO: _LIMIT 1000
  GET command_connect&, , a$
  a2$ = a2$ + a$
  'IF LEFT$(a2$, 1) <> "2" AND INSTR(a2$, crlf$) THEN a2$ = MID$(a2$, INSTR(a2$, crlf$) + 2)
LOOP UNTIL INSTR(a2$, crlf$)
OPEN RTRIM$(get_str$(Local_files(boxes(1).selected).nam)) FOR BINARY AS #1
dat$ = SPACE$(LOF(1))
GET #1, , dat$

PUT #data_connect&, , dat$

CLOSE #1
PRINT dat; LEN(dat$);
DO
  x = bytes_left&(data_connect&)
  PRINT x;
  _DISPLAY
  _DELAY .05
LOOP UNTIL x = 0
CLOSE data_connect&
PRINT dat;
_DISPLAY
SLEEP

a2$ = ""
draw_box box, 0
text$ = "Waiting for Server to respond..."
LOCATE box.row1 + 1, _WIDTH(0) \ 2 - LEN(text$) \ 2
PRINT text$;
_DISPLAY
DO: _LIMIT 100
  GET command_connect&, , a$
  a2$ = a2$ + a$
LOOP UNTIL INSTR(a2$, crlf$)
IF LEFT$(a2$, 3) = "226" THEN
  text$ = "Sucessfully transfered!"
ELSE
  text$ = "Transfer failed..."
END IF
SLEEP
draw_box box, 0
LOCATE box.row1 + 1, _WIDTH(0) \ 2 - LEN(text$) \ 2
PRINT text$;
t# = TIMER
DO: _LIMIT 100: LOOP UNTIL INKEY$ > "" OR TIMER - t# > 1
Update_Remote_Files
END SUB

SUB Update_Remote_Files () 'Refreshes the remote file listing

IF NOT is_connected THEN boxes(2).length = 0: EXIT SUB
IF NOT cmd_mode THEN
  DIM box AS box_type
  'box.nam = ""
  put_str box.nam, ""
  box.row1 = _HEIGHT(0) \ 2 - 1
  box.row2 = _HEIGHT(0) \ 2 + 1
  box.col1 = _WIDTH(0) \ 2 - 25
  box.col2 = _WIDTH(0) \ 2 + 25
  box.shadow = -1
  box.c1 = 0
  box.c2 = 7
  box.text_box = -1
  draw_box box, 0
  text$ = "Updating remote files list..."
  LOCATE box.row1 + 1, _WIDTH(0) \ 2 - LEN(text$) \ 2
END IF
PRINT text$;
IF NOT cmd_mode THEN _DISPLAY
upd$ = "PWD" + crlf$
PUT command_connect&, , upd$
a2$ = get_response_code$
SELECT CASE LEFT$(a2$, 3)
  CASE "500", "501", "502", "550"
    Remote_dir$ = "FTP Serv doesn't support PWD"
  CASE "421"
    boxes(2).length = 0
    is_connected = 0
    CLOSE command_connect&
    status$ = "Not Connected."
    dialog_disp "Error: Server disconnected."
    EXIT SUB
END SELECT
Remote_dir$ = MID$(a2$, INSTR(a2$, CHR$(34)) + 1)
Remote_dir$ = MID$(Remote_dir$, 1, INSTR(Remote_dir$, CHR$(34)) - 1)
a2$ = ""
start_PASV_mode
IF data_connect& = 0 THEN EXIT SUB
IF show_hidden_remote THEN h$ = "a" ELSE h$ = ""
IF server_syst$ = "UNIX" THEN upd$ = "LIST -l" + h$ + crlf$ 'NLST was origonally used

PUT command_connect&, , upd$
a2$ = get_response_code$
n$ = LEFT$(a2$, 3)
SELECT CASE n$
  CASE "450", "500", "501", "502", "530"
    boxes(2).length = 2
    boxes(2).selected = 1
    boxes(2).offset = 0
    put_str Remote_files(1).nam, "FTP Server doesn't support LIST"
    put_str Remote_files(2).nam, "Try using the command line"
END SELECT

t# = TIMER

DO
  _LIMIT 500
  GET data_connect&, , a$
  dirs$ = dirs$ + a$
  GET command_connect&, , b$
  b2$ = b2$ + b$
  'a5$ = a5$ + a$
LOOP UNTIL INSTR(b2$, crlf$) OR TIMER - t# > 10 OR NOT _CONNECTED(data_connect&)

CLOSE data_connect&
'IF TIMER - t# > 10 THEN
'  boxes(2).length = 2
'  boxes(2).selected = 1
'  boxes(2).offset = 0
'
'  Remote_files(1).nam = "FTP Server doesn't support NLST"
'  Remote_files(2).nam = "Try using the command line"
'  dialog_disp "Error: Server timed out when sending the Directory/Files list"
'  EXIT SUB
'END IF
IF b2$ = "" THEN b2$ = get_response_code$ 'we have to make sure we got a response code
n$ = LEFT$(b2$, 3)
SELECT CASE n$
  CASE "226", "250", ""
    boxes(2).length = 1
    boxes(2).selected = 1
    boxes(2).offset = 0
    put_str Remote_files(1).nam, ".."
    Remote_files(1).dir = "DIR"
    Remote_files(1).flag_cwd = -1
    Remote_files(1).flag_retr = 0
    'OPEN temp_dir$ + sep$ + "temp.tmp" FOR OUTPUT AS #1
    'PRINT #1, dirs$
    'CLOSE #1
    IF LEN(dirs$) > 1 THEN
      'DO 'old NLST method
      '  di$ = MID$(dirs$, 1, INSTR(dirs$, crlf$) - 1)
      '  IF di$ <> "." AND di$ <> ".." THEN
      '    boxes(2).length = boxes(2).length + 1
      '    dirs$ = MID$(dirs$, INSTR(dirs$, crlf$) + 2)
      '    IF INSTR(di$, ".") THEN
      '      Remote_files(boxes(2).length).dir = ""
      '    ELSE
      '      Remote_files(boxes(2).length).dir = "DIR"
      '    END IF
      '    put_Str Remote_files(boxes(2).length).nam, di$
      '  END IF
      'LOOP UNTIL dirs$ = ""
      x = 0
      DO
        di$ = MID$(dirs$, 1, INSTR(dirs$, crlf$) - 1)
        dirs$ = MID$(dirs$, INSTR(dirs$, crlf$) + 2)
        x = boxes(2).length + 1
        put_str Remote_files(x).lin, di$
        k = FTP_Parse_Line(Remote_files(x))
        'IF Remote_files(x).flag_cwd AND Remote_files(x).flag_retr THEN
        '  Remote_files(x).dir = "LNK"
        'ELSEIF NOT Remote_files(x).flag_retr AND Remote_files(x).flag_cwd THEN
        '  Remote_files(x).dir = "DIR"
        'ELSE
        '  Remote_files(x).dir = ""
        'END IF
        IF get_str$(Remote_files(x).nam) <> ".." AND get_str$(Remote_files(x).nam) <> "." and get_str$(Remote_files(x).nam) > "" THEN boxes(2).length = x
      LOOP UNTIL dirs$ = ""
      sort_dir_listing Remote_files(), boxes(2).length
    END IF
  CASE "425", "426", "451"
    boxes(2).length = 2
    boxes(2).selected = 1
    boxes(2).offset = 0
    put_str Remote_files(1).nam, "FTP Server doesn't support NlST"
    put_str Remote_files(2).nam, "Try using the command line"
END SELECT
print_files boxes(2), Remote_files()
update_scrn
END SUB

SUB start_PASV_mode () 'Call sub to start a PASV connect with FTP server on data_connect&
pasv$ = "PASV" + crlf$
PUT command_connect&, , pasv$
'DO: _LIMIT 1000
a2$ = get_response_code$
SELECT CASE LEFT$(a2$, 3)
  CASE "500", "501", "502", "421", "530"
    dialog_disp "PASV Failed, disconnecting from server. Please try again."
    is_connected = 0
    status$ = "Not Connected."
    CLOSE command_connect&
    data_connect& = 0
    EXIT SUB
END SELECT
por$ = MID$(a2$, INSTR(a2$, "(") + 1)
DIM ip$(4)
FOR x = 1 TO 4
  ip$(x) = MID$(por$, 1, INSTR(por$, ",") - 1)
  por$ = MID$(por$, INSTR(por$, ",") + 1)
  ips$ = ips$ + ip$(x) + "."
NEXT x
ips$ = LEFT$(ips$, LEN(ips$) - 1)
p1$ = MID$(por$, 1, INSTR(por$, ",") - 1)
por$ = MID$(por$, INSTR(por$, ",") + 1)
p2$ = MID$(por$, 1, INSTR(por$, ")") - 1)
por$ = MID$(por$, INSTR(por$, ",") + 1)
port$ = STR$(VAL(p1$) * 256 + VAL(p2$))
data_connect& = _OPENCLIENT("TCP/IP:" + port$ + ":" + ips$)
END SUB

SUB get_file (file$) 'Gets a file from the FTP server and saves it in the local DIR
'grab data in 1 MB chunks


IF NOT cmd_mode THEN
  DIM box AS box_type
  'box.nam = n$
  put_str box.nam, n$
  box.row1 = _HEIGHT(0) \ 2 - 1
  box.row2 = _HEIGHT(0) \ 2 + 1
  box.col1 = _WIDTH(0) \ 2 - 25
  box.col2 = _WIDTH(0) \ 2 + 25
  box.shadow = -1
  box.c1 = box_c1
  box.c2 = box_c2
  box.text_box = -1
  draw_box box, 0
END IF
file$ = RTRIM$(file$)
IF cmd_mode AND is_connected THEN PRINT "Getting file: "; Local_dir$ + sep$ + file$
IF is_connected = 0 THEN text$ = "Please connect to a FTP Server first." ELSE text$ = "Recieving File...()"

IF NOT cmd_mode THEN LOCATE box.row1 + 1, _WIDTH(0) \ 2 - LEN(text$) \ 2
PRINT text$;
IF NOT cmd_mode THEN _DISPLAY

IF (is_connected = 0 AND NOT cmd_mode) THEN
  t# = TIMER
  DO: _LIMIT 100: LOOP UNTIL INKEY$ > "" OR TIMER - t# > 1
  EXIT SUB
ELSEIF is_connected = 0 AND cmd_mode THEN
  EXIT SUB
END IF

file_size& = Remote_files(boxes(2).selected).size
IF cmd_mode THEN PRINT "File size: "; file_size&
start_PASV_mode

IF data_connect& = 0 THEN EXIT SUB
typei$ = "TYPE I" + crlf$
PUT command_connect&, , typei$
r$ = get_response_code$
SELECT CASE LEFT$(r$, 3)
  CASE "421"
    dialog_disp "Error: FTP Server Disconnected."
    is_connected = 0
    CLOSE command_connect&, data_connect&
    EXIT SUB
END SELECT

retr$ = "RETR " + LTRIM$(file$) + crlf$
PUT command_connect&, , retr$
r$ = get_response_code$
SELECT CASE LEFT$(r$, 3)
  CASE "450", "550"
    dialog_disp "Error: FTP Server refused to send the file"
    CLOSE data_connect&
    EXIT SUB
  CASE "500", "501", "530"
    dialog_disp "Error: FTP Server didn't reconise RETR command."
    CLOSE data_connect&
    EXIT SUB
END SELECT
sto$ = ""
'_AUTODISPLAY
OPEN RTRIM$(Local_dir$ + sep$ + file$) FOR BINARY AS #1
'OPEN is way way WAY to slow...
'file_offset = fopen(local_dir$ + sep$ + file$, "w")
'data_buffer = _MEMNEW(1024 * 1024 * 1024) '1 MB
'data_buf$ = space$(1024 * 1024 * 1024)
e_flag_1 = 0
e_flag_2 = 0
t# = 0
f_downloaded = 0
BUFFER_LEN = 10 * 1024 * 1024 * 1024 '10 MB
DO
  _LIMIT 100

  GET data_connect&, , filedat$

  IF filedat$ = "" AND e_flag_1 THEN e_flag_2 = -1
  filef$ = filef$ + filedat$

  GET command_connect&, , a$

  a2$ = a2$ + a$
  'IF (TIMER - t# > .1 AND NOT CLI) OR (TIMER - t# > .5) THEN
  IF LEN(filef$) > BUFFER_LEN THEN
    tsav# = TIMER - t#
    f_downloaded = f_downloaded + LEN(filef$)
    c = LEN(filef$)
    PUT #1, , filef$
    filef$ = ""
    kbpers = (c) / 1024 / tsav# 'c is how much we downloaded in our last loop
    
    IF file_size& = 0 THEN s$ = STR$(c) + " Bytes," ELSE s$ = STR$(INT(c / file_size& * 100) / 100) + "%,"
    
    text$ = "Recieving File...(" + s$ + STR$(kbpers) + " KB/s)"
    
    IF NOT cmd_mode THEN
      draw_box box, 0
      IF NOT CLI THEN
        LOCATE box.row1 + 1, _WIDTH(0) \ 2 - LEN(text$) \ 2
      ELSE
        LOCATE , 1
      END IF
    END IF
    PRINT text$
    IF NOT cmd_mode THEN _DISPLAY
    'PRINT "got here!!!!"
    'k = k + 1

    't# = TIMER
    'c = (LEN(filef$) - c1) * 10
    'IF c > 0 THEN kbpers = c / 1024 \ 1 ' ELSE kbpers = 0
    'c1 = LEN(filef$)
    'IF file_size& = 0 THEN s$ = STR$(c1) + " Bytes," ELSE s$ = STR$(INT(c1 / file_size& * 100) / 100) + "%,"

    'IF NOT cmd_mode THEN draw_box box, 0
    'text$ = "Recieving File...(" + s$ + STR$(kbpers) + " KB/s)"

    'IF NOT CLI THEN
    '  IF NOT cmd_mode THEN LOCATE box.row1 + 1, _WIDTH(0) \ 2 - LEN(text$) \ 2 ELSE LOCATE , 1
    'ELSE
    '  PRINT CHR$(13); 'move cursor back
    'END IF
    'PRINT text$;
    'if not cmd_mode then _DISPLAY
    t# = TIMER
  END IF
  IF INSTR(a2$, crlf$) AND MID$(a2$, 4, 1) = "-" THEN
    DO
      sto$ = sto$ + MID$(a5$, 1, INSTR(a2$, crlf$) + 1)
      a2$ = MID$(a2$, INSTR(a2$, crlf$) + 2)
    LOOP UNTIL MID$(a2$, 4, 1) <> "-"
  END IF
  IF INSTR(a2$, crlf$) THEN e_flag_1 = -1
LOOP UNTIL e_flag_2
'PUT #1, , filef$
CLOSE #1
IF cmd_mode THEN PRINT
SELECT CASE LEFT$(a2$, 3)
  CASE "226", "250"
    CLOSE data_connect&
    IF NOT cmd_mode THEN draw_box box, 0
    text$ = "File Sucessfully Recieved!"
    IF NOT cmd_mode THEN LOCATE box.row1 + 1, _WIDTH(0) \ 2 - LEN(text$) \ 2
    PRINT text$
    IF NOT cmd_mode THEN _DISPLAY
    IF NOT cmd_mode THEN
      t# = TIMER
      DO: _LIMIT 100: LOOP UNTIL INKEY$ > "" OR TIMER - t# > 1.5
      refresh_Local_files
    END IF
  CASE "425", "426", "451"
    CLOSE data_connect&
    KILL Local_dir$ + sep$ + RTRIM$(get_str$(Remote_files(boxes(2).selected).nam))
    dialog_disp "Error: File could not be recieved."

END SELECT
IF cmd_mode THEN PRINT "File Recieved"
END SUB

FUNCTION get_response_code$ () 'Get's a response code from the FTP server
sto$ = ""
t# = TIMER
DO: _LIMIT 100
  GET command_connect&, , a$
  a5$ = a5$ + a$
  IF INSTR(a5$, crlf$) AND MID$(a5$, 4, 1) = "-" THEN
    if cmd_mode then PRINT "Extended response..."
    DO
      sto$ = sto$ + MID$(a5$, 1, INSTR(a5$, crlf$) + 1)
      a5$ = MID$(a5$, INSTR(a5$, crlf$) + 2)
    LOOP UNTIL MID$(a5$, 4, 1) <> "-"
  END IF
  IF NOT _CONNECTED(command_connect&) OR TIMER - t# > 10 THEN a5$ = "421 Server Disconnected." + crlf$
LOOP UNTIL INSTR(a5$, crlf$)
IF sto$ = "" THEN
  r$ = MID$(a5$, 1, INSTR(a5$, crlf$) - 1)
ELSE
  r$ = sto$ + MID$(a5$, 1, INSTR(a5$, crlf$) - 1)
END IF
if cmd_mode then PRINT r$
get_response_code$ = r$
END FUNCTION

SUB Rename_remote_file_dir (file$, newname$, file_dir) 'Renames a remote file
'file_dir = -1 if a file
'file_dir = 0 if a directory
rf$ = "RNFR " + file$ + crlf$
PUT #command_connect&, , rf$
a2$ = get_response_code$
SELECT CASE LEFT$(a2$, 3)
  CASE "450", "550", "501", "502", "503"
    dialog_disp "Error requesting name change..."
    EXIT SUB
  CASE "421"
    dialog_disp "Error change name, server closed connection"
    CLOSE #command_connect&
    is_connected = 0
    status$ = "Not Connected."
    EXIT SUB
END SELECT
nf$ = "RNTO " + newname$ + crlf$
PUT #command_connect&, , nf$
a2$ = get_response_code$
SELECT CASE LEFT$(a2$, 3)
  CASE "552", "553", "500", "501", "502", "503", "530"
    dialog_disp "Error requesting name chance..."
    EXIT SUB
  CASE "421"
    dialog_disp "Error changing name, server closed connection"
    CLOSE #command_connect&
    is_connected = 0
    status$ = "Not Connected."
    EXIT SUB
END SELECT
dialog_disp "Name changed."
END SUB

SUB delete_remote_file (f$) 'Deletes remote file f$
msg$ = "DELE " + RTRIM$(f$) + crlf$

END SUB

SUB delete_local_file (f$) 'Uses KILL. Deletes file f$
err_flag = 0
ON ERROR GOTO error_flag
KILL RTRIM$(f$)
ON ERROR GOTO 0
IF err_flag THEN
  dialog_disp "Error deleting local file."
END IF
END SUB

SUB Start_ftp_connect () 'Starts a FTP connection
IF server$ = "" THEN dialog_disp "Please give a server name.": EXIT SUB
IF username$ = "" THEN username$ = "anonymous" 'dialog_disp "Please give a Username.": EXIT SUB
IF password$ = "" THEN password$ = "" 'dialog_disp "Please give a password.": EXIT SUB
IF port$ = "" THEN port$ = "21" 'dialog_disp "Please give a port number.": EXIT SUB
IF NOT cmd_mode THEN
  DIM disp_box AS box_type
  disp_box.row1 = _HEIGHT(0) \ 2 - 1
  disp_box.row2 = _HEIGHT(0) \ 2 + 1
  disp_box.c1 = 0
  disp_box.c2 = 7
  disp_box.text_box = -1
  'disp_box.nam = ""
  put_str disp_box.nam, ""
  disp_box.col1 = _WIDTH(0) \ 2 - 20
  disp_box.col2 = disp_box.col1 + 40
  disp_box.shadow = -1
END IF
text$ = "Connecting to FTP server..."
IF NOT cmd_mode THEN
  draw_box disp_box, 0
  LOCATE disp_box.row1 + 1, disp_box.col1 + 20 - LEN(text$) \ 2
END IF
PRINT text$
IF NOT cmd_mode THEN _DISPLAY
is_connected = 0
t# = TIMER
IF command_connect& <> 0 THEN CLOSE command_connect&: command_connect& = 0
command_connect& = _OPENCLIENT("TCP/IP:" + port$ + ":" + server$)
IF command_connect& <> 0 THEN
  a2$ = get_response_code$
  SELECT CASE LEFT$(a2$, 3)
    CASE "120"
      text$ = MID$(a2$, 4)
      GOTO exit_f
    CASE "220" 'Good connection
    CASE "421" 'Bad connection
      text$ = "Error: FTP Service was closed by the Server"
  END SELECT
  a2$ = ""
  user$ = "USER " + username$ + crlf$
  pass$ = "PASS " + password$ + crlf$
  PUT command_connect&, , user$
  a2$ = get_response_code$
  IF TIMER - t# > 10 THEN GOTO exit_f
  n$ = LEFT$(a2$, 3)
  SELECT CASE n$
    CASE "530"
      text$ = "Error: Not logged in."
      GOTO exit_f
    CASE "500", "501"
      text$ = "Error: Server didn't reconize the syntax"
      GOTO exit_f
    CASE "421"
      text$ = "Error: FTP Service was closed by the Server" '
      GOTO exit_f
  END SELECT
  a2$ = ""
  IF n$ = "331" THEN
    PUT command_connect&, , pass$
    a2$ = get_response_code$
    n$ = LEFT$(a2$, 3)
    SELECT CASE n$
      CASE "202"
        text$ = "Error: Password not needed or not supported."
        GOTO exit_f
      CASE "530"
        text$ = "Error: Password or Username incorrect."
        GOTO exit_f
      CASE "500", "501", "503"
        text$ = "Error: Server didn't reconize the syntax"
        GOTO exit_f
      CASE "421"
        text$ = "Error: FTP Service was closed by the Server" '
        GOTO exit_f
      CASE "332"
        text$ = "Error: Need account for login"
        GOTO exit_f
    END SELECT
  END IF
  a2$ = ""
  is_connected = -1
  text$ = "Connected!"
  status$ = "Connected to " + server$
  syst$ = "SYST" + crlf$
  PUT command_connect&, , syst$
  a2$ = get_response_code$
  SELECT CASE LEFT$(a2$, 3)
    CASE "215"
      server_syst$ = MID$(a2$, INSTR(a2$, " ") + 1)
      server_syst$ = MID$(server_syst$, 1, INSTR(server_syst$, " ") - 1)
    CASE ELSE
      server_syst$ = "UNIX" 'Default
  END SELECT
  status$ = status$ + ", " + server_syst$
  IF NOT cmd_mode THEN Update_Remote_Files
ELSE
  text$ = "Error Connecting..."
  exit_f:
  status$ = "Not Connected."
END IF
IF NOT cmd_mode THEN
  draw_box disp_box, 0
  LOCATE disp_box.row1 + 1, disp_box.col1 + 20 - LEN(text$) \ 2
END IF
PRINT text$
IF NOT cmd_mode THEN _DISPLAY ELSE IF is_connected THEN PRINT "Server type: "; server_syst$
free_gui_element disp_box
END SUB

SUB Get_remote_dir () 'Get's the remote DIR
upd$ = "PWD" + crlf$
PUT command_connect&, , upd$
a2$ = get_response_code$
SELECT CASE LEFT$(a2$, 3)
  CASE "500", "501", "502", "550"
    Remote_dir$ = "FTP Serv doesn't support PWD"
  CASE "421"
    Remote_dir$ = ""
    is_connected = 0
    CLOSE command_connect&
    status$ = "Not Connected."
    dialog_disp "Error: Server disconnected."
    EXIT SUB
END SELECT
Remote_dir$ = MID$(a2$, INSTR(a2$, CHR$(34)) + 1)
Remote_dir$ = MID$(Remote_dir$, 1, INSTR(Remote_dir$, CHR$(34)) - 1)
END SUB
