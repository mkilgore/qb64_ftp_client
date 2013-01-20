'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

commands:
DATA 23
DATA "ECHO","Prints a line of text to the screen."," ","Syntax: ECHO string"," ","Where 'string' is any line of text.",
DATA "DIR","Prints the Remote directory structure"," ","Syntax: DIR [flags|--nlst]"," ","The 'flags' variable is not outlined because It's dependent on the server. What ever is specefied for flags will be passed directly to the server in a LIST command. --nlst forces the client to use NLST instead of LIST. If you don't get any text output or a error from the regular list, try using --nlst. You should note that NLST provides bare Dir/File names where as LIST (The default) Provides much more meaningfull data.",
DATA "CD","Changes the Remote directory"," ","Syntax: CD directory"," ","'directory' is the name of any valid directory on the Remote filesystem. To goto the parent directory, use the command 'CD ..'.",
DATA "PWD","Prints the current Remote directory"," ","Syntax: PWD"," ","PWD outputs the current Remote directory to the screen",
DATA "LDIR","Prints the Local directory structore"," ","Syntax: LDIR [flags]"," ","LDIR shell's out to the default directory list function for the system (ls for  Linux, dir for Windows). As a result, the flags variable is system dependent. The flags variable will be passed to the directory list function directly with no formatting.",
DATA "LCD","Changes the Local directory"," ","Syntax: LCD directory"," ","'directory' is the name of any valid directory on the Local filesystem. To goto the parent directory, use the command 'CD ..'.",
DATA "LPWD","Prints the current Local directory"," ","Syntax: LPWD"," ","LPWD outputs the current Local directory to the screen",
DATA "CONNECT","Used to connect to a FTP server"," ","Syntax: CONNECT [username[:password]@]ftp_server_address[:port]"," ","Using this command will disconnect from a FTP server if you're already connected to one, and then start a connection using the parameters you provided. It uses a FTP URL. You can leave off any of the parameters you wish besides the server address.",
DATA "DISCON","Used to disconnect from a FTP server"," ","Sytax: DISCON"," ","DISCON is used to disconnect for the current FTP server. (If the client is not connected then this command does nothing). This command is automatically done if you close the Client window or use the CONNECT command when you're already connected.",
DATA "PUT","Used to send a file to the FTP server"," ","Syntax: PUT Local_file_name"," ","PUT will send the file to the Current Remote directory (Assuming the FTP server allows you to do that).",
DATA "GET","Used to recieve a file from the FTP server"," ","Syntax: GET Remote_file_name"," ","GET will send a request to the FTP server to send the file specefied in 'Remote_file_name'. A status bar will come-up once the download starts, and the file will be saved with the same name to the current Local diectory.",
DATA "SCRIPT","Used to run a user written script"," ","Syntax: SCRIPT Local_file_name"," ","SCRIPT will run a file that contains a list of commands to run. The commands allowed to be used in the script are all the ones listed in the HELP command list, plus '@ECHO OFF' and '@ECHO ON' to turn echoing of commands on and off.",
DATA "RENAME","Used to rename a Remote File"," ","Syntax: RENAME Remote_file, New_name"," ","Where New_name is the new filename, and Remote_file is the original filename. It is recommended to have the names in quotes.",
DATA "LRENAME","Used to rename a Local File"," ","Syntax: LRENAME Local_file, New_name"," ","Where New_name is the new filename, and Local_file is the original filename. It is recommended to have the names in quotes.",
DATA "DEL","Used to delete a Remote File"," ","Syntax: DEL Remote_file"," ","This command will send a request to the server to delete Remote_file. Weither this command works or not depends on the file permissions of the file you are trying to delete and what the FTP server will allow.",
DATA "LDEL","Used to delete a Local File"," ","Syntax: LDEL Local_file"," ","This command will try to delete Local_file. It won't work if the user doesn't have permissions to delete the file.",
DATA "MKDIR","Used to make a Remote directory"," ","Syn1tax: MKDIR dir_name"," ","'dir_name' is the name for the new directry. Weither or not this command will succeed depends on your permission on the FTP server.",
DATA "LMKDIR","Used to make a Local directory"," ","Syntax: LMKDIR dir_name"," ","'dir_name; is the name for the new directory.",
DATA "RMDIR","Used to delete a Remote directory"," ","Syntax: RMDIR dir_name"," ","'dir_name' is the name of the directory to remove. Weither or not this command will succeed depends on your permission on the FTP server.",
DATA "LRMDIR","Used to delete a Local directory"," ","Syntax: LRMDIR dir_name"," ","'dir_name' is the name of the directory to remove. The directory will be deleted even if it has files in it.",
DATA "EXIT","Used to Exit from the CLI"," ","Syntax: EXIT"," ","If the command line was launched from start-up, then exit will close the program. If it was launched from the GUI then the Command line will exit to the GUI",
DATA "STATUS","Returns the status of the FTP connection"," ","Syntax: STATUS"," ","Prints the status of a FTP connection (Or 'No Connection' if you're not connected",
DATA "PAUSE","Waits for a keypress"," ","Syntax: PAUSE"," ","Prints the message 'Press Any Key to Continue' and then waits for a key press. Usefull in scripts",
