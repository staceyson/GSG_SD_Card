#!/bin/sh

# Copyright 2026 Stacey D. Son (aka. Uncle Ted, atariage)
# Copyright 2026 Paul Tamborello (aka. BuckysRevenge, atariage)
#
# Redistribution and use in source and binary forms, with or without
# modification, are#  permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Args:
#   $1 is the "-k" arg
#   $2 is the "system number" that /usr/bin/game gives
#   $3 is the full path to the config file
#   $4 is the full path to the game ROM

LOCAL_BIN="/userdata/bin"

# Paths for the game custom "pre" and "post" scripts, if any.
PRE_SCRIPT="${4%.*}.pre"
POST_SCRIPT="${4%.*}.post"

# Add $LOCAL_BIN to the path.
export PATH="$LOCAL_BIN:$PATH"

# On the first run put the local binaries in a non-FAT file space
if [ -f "$LOCAL_BIN"/retroarch ]; then
    mkdir -p "$LOCAL_BIN"
    cp /sdcard/bin/retroarch "$LOCAL_BIN"
    chmod 755 "$LOCAL_BIN/retroarch"
    cp /sdcard/bin/gsgparm "$LOCAL_BIN"
    chmod 755 "$LOCAL_BIN/gsgparm"
    cp /sdcard/bin/hotkeyd "$LOCAL_BIN"
    chmod 755 "$LOCAL_BIN/hotkeyd"
fi

# Make sure hotkeyd is running in the background
if [ -f "$LOCAL_BIN/hotkeyd" ]; then
   hotkeyd --home-r1 /usr/bin/uiswitch.sh
fi

# Setup the environment for running retroarch
export HOME=/sdcard
export XDG_CONFIG_HOME=/sdcard
export XDG_RUNTIME_DIR=/sdcard


GAME_PATH=
GAME_LIB=

# The LED lights are controlled with the 'gsgparm' command-line options as follows:
#
# To turn on LED lights:
# -1 <lights> where the lights are specified in a comma separated list
#             with the following members:
#               "tball"     is the trackball LED
#               "spin"      is the spinner LED
#               "dpad"      is the d-pad joystick LED
#               "A"         is the A button LED
#               "B"         is the B button LED
#               "X"         is the X button LED
#               "Y"         is the X button LED
#               "R1"        is the R1 shoulder button LED
#               "L1"        is the L1 shoulder button LED
#               "R2"        is the R2 shoulder button LED
#               "L2"        is the L2 shoulder button LED
#               "1"         is keypad number 1 key LED
#               "2"         is keypad number 2 key LED
#               "3"         is keypad number 3 key LED
#               "4"         is keypad number 4 key LED
#               "5"         is keypad number 5 key LED
#               "6"         is keypad number 6 key LED
#               "7"         is keypad number 7 key LED
#               "8"         is keypad number 8 key LED
#               "9"         is keypad number 9 key LED
#               "0"         is keypad number 0 key LED
#               "S"         is keypad number * (star) key LED
#               "P"         is keypad number # (pound) key LED
#            or, as a shortcut:
#               "all"       is all the LEDs
#
# To turn off LED lights:
# -0 <lights> where the lights are specified the same as above.
#
# To set the keymode:
# -k <num>    where <num> is the keymode
#
# Other command-line options for 'gsgparm', that might be useful, include:
# -b <num>      Set Display Brightness to <num> where 2=Dim, 252=Bright
#               or somewhere in between
#
# -m <num>      Set Background Music to <num> where Off=0, On=1
#
#
# Command-line options ONLY for My Arcade's 'retroarch' include:
# -a <num>      Set Display Aspect Ratio to <num> where Widescren=0, Original=1
#
# -i <num>      Set Aspect_Ratio_Index to <num> where 4:3=0, 3:4=8
#
# Examples:
#   (1) To turn on only the D-Pad, A, B, X, and Y button LED lights.
#       All other LEDs turrned off.  Set the keymode to 0.
#
#       gsgparm -0 all -1 dpad,A,B,X,Y -k 0
#
#   (2) To turn on the 1, 3, and 5 keypad LED lights, leaving the
#       state of the other LEDs as they are. Set the keymode to 18.
#
#       gsgparm -1 1,3,5 -k 18
#
#       Note:
#       This LED configuration is used with most of the retroarch cores below.
#       The 1 keypad button is use to save the game state, the 3 keypad button
#       is use to load the game state, and the 5 keypad button is used to
#       take a screenshot. By default (depending on the cfg file) the game
#       states are saved in /sdcard/retroarch/states/<emulator core name> and
#       the screenshots are stored in
#       /sdcard/retroarch/screenshots/<emulator core name>.


#Assign a library core based off of folder name
#key_led settings adjust the lights for buttons primarily used by that core
case "$4" in
  /sdcard/Games/Atari\ 2600/*)
    GAME_LIB=stella2014_libretro.so
    gsgparm -0 B,X,Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/Atari\ 2600\ Paddle/*)
    GAME_LIB=stella
    gsgparm -0 B,X,Y -1 spin
    ;;
  /sdcard/Games/Atari\ 5200/*)
    #GAME_LIB=atari800_libretro.so
    GAME_LIB=a5200_libretro.so
    #Turn on keypad
    gsgparm -0 X,Y -1 1,2,3,4,5,6,7,8,9,0,S,P -k 21
    ;;
  /sdcard/Games/Atari\ 7800/*)
    GAME_LIB=prosystem_nds_libretro.so
    gsgparm -0 X,Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/Atari\ Lynx/*)
    GAME_LIB=handy_libretro.so
    gsgparm -0 B,Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/ColecoVision/*)
    GAME_LIB=gearcoleco_libretro.so
    gsgparm -0 X,Y -1 1,2,3,4,5,6,7,8,9,0,S,P -k 21
    ;;
  /sdcard/Games/Doom/*)
    GAME_LIB=prboom_libretro.so
    gsgparm -0 X,Y -1 5,L1,L2,R1,R2 -k 21
    ;;
  /sdcard/Games/Dreamcast/*)
    GAME_LIB=flycast_libretro.so
    gsgparm -1 1,3,5 -k 18
    ;;
  /sdcard/Games/Gameboy/*)
    GAME_LIB=gambatte_libretro.so
    gsgparm -0 B,Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/Gameboy\ Advance/*)
    GAME_LIB=mgba_libretro.so
    gsgparm -0 B,Y -1 L1,R1,1,3,4 -K 18
    ;;
  /sdcard/Games/Gameboy\ Color/*)
    GAME_LIB=gambatte_libretro.so
    gsgparm -0 B,Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/Intellivision/*)
    GAME_LIB=freeintv_libretro.so
    gsgparm -0 X,Y -1 1,2,3,4,5,6,7,8,9,0,S,P -k 21
    ;;
  /sdcard/Games/Mame/*)
    GAME_LIB=mame2003_libretro.so
    #Turn on trackball and spinner
    gsgparm -1 tball,spin -k 22
    ;;
  /sdcard/Games/Mame\ 2003\ Plus/*)
    GAME_LIB=mame2003_plus_libretro.so
    gsgparm -1 tball,spin -k 22
    ;;
  /sdcard/Games/Neo\ Geo/*)
    GAME_LIB=fbneo_libretro.so
     ;;
  /sdcard/Games/Neo\ Geo\ Pocket\ Color/*)
    GAME_LIB=mednafen_ngp_libretro.so
    gsgparm -0 B,Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/NES/*)
    GAME_LIB=fceumm_libretro.so
    gsgparm -0 B,Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/PC\ Engine/*)
    GAME_LIB=mednafen_pce_fast_libretro.so
    gsgparm -0 B,Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/pcenginecd/*)
    GAME_LIB=mednafen_pce_fast_libretro.so
    gsgparm -0 B,Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/PlayStation/*)
    GAME_LIB=pcsx_rearmed_libretro.so
    gsgparm -1 1,3,5,7,8,9,L1,L2,R1,R2 -k 18
    ;;
  /sdcard/Games/ScummVM/*)
    GAME_LIB=scummvm_libretro.so
    #Give ScummVM the trackball for the mouse pointer
    gsgparm -1 5,0,tball,L1,R1,R2
    ;;
  /sdcard/Games/Sega\ 32x/*)
    GAME_LIB=picodrive_libretro.so
    gsgparm -0 Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/Sega\ CD/*)
    GAME_LIB=genesis_plus_gx_libretro.so
    gsgparm -0 Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/Sega\ Game\ Gear/*)
    GAME_LIB=picodrive_libretro.so
    gsgparm -0 X,Y-1 1,3,5 -k 18
    ;;
  /sdcard/Games/Sega\ Genesis/*)
    GAME_LIB=picodrive_libretro.so
    gsgparm -0 Y -1 1,3,5 -k 18
    ;;
  /sdcard/Games/Sega\ Master\ System/*)
    GAME_LIB=picodrive_libretro.so
    gsgparm -0 X,Y,1,3,5 -k 18
    ;;
  /sdcard/Games/SNES/*)
    GAME_LIB=snes9x2005_plus_libretro.so
    gsgparm -1 L1,R1,1,3,5 -k 18
    ;;
  /sdcard/Games/Virtual\ Boy/*)
    gsgparm -1 1,3,5 -k 18
    GAME_LIB=mednafen_vb_libretro.so
    ;;
  /sdcard/WonderSwan\ Color/*)
    GAME_LIB=mednafen_wswan_libretro.so
    gsgparm -0 B,Y -1 L1,R1,L2,R2,1,3,5 -k 18
    ;;
  *)
    GAME_LIB=NONE
    ;;
esac

# Check for a per-game pre-script, if there's one run it.
if [ -f "$PRE_SCRIPT" ]; then
    source "$PRE_SCRIPT"
fi

case "$GAME_LIB" in
  a5200_libretro.so|atari800_libretro.so|gearcoleco_libretro.so|freeintv_libretro.so|mame2003_libretro.so|mame2003_plus_libretro.so)
    retroarch \
      -c ~/retroarch/config/retroarch.cfg \
      -L ~/retroarch/cores/$GAME_LIB "$4"
    ;;
  prboom_libretro.so)
    #Run Doom, tested on Doom (shareware and full), Doom 2, Plutonium, and TNT wad files,
    #create a corresponding zip file so you can launch the respective wad file
    #To play a specific custom map dependent on a WAD, you'll need to look into how to
    #launch that in the prboom libretro documentation
    folder_path=$(dirname "$4")
    game_filename="${4##*/}"
    game_name="${game_filename%.*}"
    retroarch\
      -c ~/retroarch/config/retroarch.cfg \
      -L ~/retroarch/cores/$GAME_LIB \
      $folder_path/$game_name.WAD
    ;;
  scummvm_libretro.so)
    retroarch \
      -c ~/retroarch/config/retroarch.cfg \
      -L ~/retroarch/cores/$GAME_LIB
    ;;
  stella)
    #Run 2600 paddle games
    /usr/bin/stella $3 "$4"
    ;;
  *)
    #Run any other game
    retroarch \
      -c ~/retroarch/config/retroarch.cfg \
      -L ~/retroarch/cores/$GAME_LIB "$4"
    ;;
esac

#Exiting game, reset button LEDs, keymode, etc. to defaults
gsgparm -0 all -1 dpad,A,B,X,Y -k 0 -a 1 -i 0

# If there is a post script, run it now.
if [ -f "$POST_SCRIPT" ]; then
    source "$POST_SCRIPT"
fi

#checking to see if the user is trying to reset to the main menu
evtest --query /dev/input/event1 1 16
RESET_CHECK=$?

if [ $RESET_CHECK == 10 ]; then
  #Restart the GSG main menu on exit if the select button is being held
  /usr/bin/uiswitch.sh
fi
