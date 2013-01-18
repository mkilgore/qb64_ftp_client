#!/bin/sh
Pause()
{
OLDCONFIG=`stty -g`
stty -icanon -echo min 1 time 0
dd count=1 2>/dev/null
stty $OLDCONFIG
}
echo "Building libqbx_lnx.o from libqbx.cpp..."
g++ -c -w -Wall libqbx.cpp -o libqbx_lnx.o  `sdl-config --cflags`
echo "Press any key to exit..."
Pause

