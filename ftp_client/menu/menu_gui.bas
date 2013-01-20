'FTP Client
'Matt Kilgore -- 2011/2013

'This program is free software, without any warranty of any kind.
'You are free to edit, copy, modify, and redistribute it under the terms
'of the Do What You Want Public License, Version 1, as published by Matt Kilgore
'See file COPYING that should have been included with this source.

DIM SHARED Global_Menu$(g_menu_c), Menu$(g_menu_c, 9), Menun(g_menu_c)
g = 1
Global_Menu$(g) = " #File ": n = 1
Menu$(g, n) = " #Connect              ": n = n + 1
Menu$(g, n) = " #Disconnect           ": n = n + 1
Menu$(g, n) = " C#ommand Line         ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " E#xit                 "
Menun(g) = n

g = g + 1: Global_Menu$(g) = " #Local ": n = 1
Menu$(g, n) = " #Refresh Files         ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " R#ename File           ": n = n + 1
Menu$(g, n) = " #Delete File           ": n = n + 1
Menu$(g, n) = " #Show Hidden           ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " #Make Directory        ": n = n + 1
Menu$(g, n) = " Re#name Directory      ": n = n + 1
Menu$(g, n) = " De#lete Directory      "
Menun(g) = n

g = g + 1: Global_Menu$(g) = " #Remote ": n = 1
Menu$(g, n) = " #Refresh Files         ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " R#ename File           ": n = n + 1
Menu$(g, n) = " #Delete File           ": n = n + 1
Menu$(g, n) = " #Show Hidden           ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " #Makes Directory       ": n = n + 1
Menu$(g, n) = " Re#name Directory      ": n = n + 1
Menu$(g, n) = " De#lete Directory      "
Menun(g) = n

g = g + 1: Global_Menu$(g) = " #Transfer ": n = 1
Menu$(g, n) = " #Send File        ": n = n + 1
Menu$(g, n) = " #Recieve File     "
Menun(g) = n

g = g + 1: Global_Menu$(g) = " #Help ": n = 1
Menu$(g, n) = " #Help                ": n = n + 1
Menu$(g, n) = " #Change Settings     ": n = n + 1
Menu$(g, n) = "-": n = n + 1
Menu$(g, n) = " #About               "
Menun(g) = n

FOR x = 1 TO g_menu_c
  FOR y = 1 TO Menun(x)
    IF LEN(Menu$(x, y)) > menu_max_len(x) THEN
      menu_max_len(x) = LEN(Menu$(x, y))
    END IF
  NEXT y
NEXT x
