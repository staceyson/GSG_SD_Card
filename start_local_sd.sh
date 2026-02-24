#!/bin/sh

cp /sdcard/bin/retroarch /tmp/
chmod +x /tmp/retroarch
export HOME=/sdcard
export XDG_CONFIG_HOME=/sdcard
export XDG_RUNTIME_DIR=/sdcard

# Add /sdcard/bin to the path.
export PATH="/sdcard/bin:$PATH"

GAME_PATH=
GAME_LIB=

#Assign a library core based off of folder name
#key_led settings adjust the lights for buttons primarily used by that core
case "$4" in
  /sdcard/Games/Atari\ 2600/*)
    GAME_LIB=stella2014_libretro.so
    gsgparm -0 B,X,Y
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
    gsgparm -0 X,Y
    ;;
  /sdcard/Games/Atari\ Lynx/*)
    GAME_LIB=handy_libretro.so
    gsgparm -0 B,Y
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
    ;;
  /sdcard/Games/Gameboy/*)
    GAME_LIB=gambatte_libretro.so
    gsgparm -0 B,Y
    ;;
  /sdcard/Games/Gameboy\ Advance/*)
    GAME_LIB=mgba_libretro.so
    gsgparm -0 B,Y -1 L1,R1
    ;;
  /sdcard/Games/Gameboy\ Color/*)
    GAME_LIB=gambatte_libretro.so
    gsgparm -0 B,Y
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
    gsgparm -0 B,Y
    ;;
  /sdcard/Games/NES/*)
    GAME_LIB=fceumm_libretro.so
    gsgparm -0 B,Y
    ;;
  /sdcard/Games/PC\ Engine/*)
    GAME_LIB=mednafen_pce_fast_libretro.so
    gsgparm -0 B,Y
    ;;
  /sdcard/Games/pcenginecd/*)
    GAME_LIB=mednafen_pce_fast_libretro.so
    gsgparm -0 B,Y
    ;;
  /sdcard/Games/PlayStation/*)
    GAME_LIB=pcsx_rearmed_libretro.so
    gsgparm -1 7,8,9,L1,L2,R1,R2
    ;;
  /sdcard/Games/ScummVM/*)
    GAME_LIB=scummvm_libretro.so
    #Give ScummVM the trackball for the mouse pointer
    gsgparm -1 5,0,tball,L1,R1,R2
    ;;
  /sdcard/Games/Sega\ 32x/*)
    GAME_LIB=picodrive_libretro.so
    gsgparm -0 Y
    ;;
  /sdcard/Games/Sega\ CD/*)
    GAME_LIB=genesis_plus_gx_libretro.so
    gsgparm -0 Y
    ;;
  /sdcard/Games/Sega\ Game\ Gear/*)
    GAME_LIB=picodrive_libretro.so
    gsgparm -0 X,Y
    ;;
  /sdcard/Games/Sega\ Genesis/*)
    GAME_LIB=picodrive_libretro.so
    gsgparm -0 Y
    ;;
  /sdcard/Games/Sega\ Master\ System/*)
    GAME_LIB=picodrive_libretro.so
    gsgparm -0 X,Y
    ;;
  /sdcard/Games/SNES/*)
    GAME_LIB=snes9x2005_plus_libretro.so
    gsgparm -1 L1,R1
    ;;
  /sdcard/Games/Virtual\ Boy/*)
    GAME_LIB=mednafen_vb_libretro.so
    ;;
  /sdcard/WonderSwan\ Color/*)
    GAME_LIB=mednafen_wswan_libretro.so
    gsgparm -0 B,Y -1 L1,R1,L2,R2
    ;;
  *)
    GAME_LIB=NONE
    ;;
esac

  case "$GAME_LIB" in
    a5200_libretro.so|atari800_libretro.so|gearcoleco_libretro.so|freeintv_libretro.so|mame2003_libretro.so|mame2003_plus_libretro.so)
      /tmp/retroarch\
        -c ~/retroarch/config/retroarch.cfg\
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
      /tmp/retroarch\
        -c ~/retroarch/config/retroarch.cfg\
        -L ~/retroarch/cores/$GAME_LIB\
        $folder_path/$game_name.WAD
      ;;
    scummvm_libretro.so)
      /tmp/retroarch\
        -c ~/retroarch/config/retroarch.cfg\
        -L ~/retroarch/cores/$GAME_LIB
      ;;
    stella)
      #Run 2600 paddle games
      /usr/bin/stella $3 "$4"
      ;;
    *)
      #Turn on the keypad for hot keys (1 to save state, 3 to load state, 5 for screenshots).
      #Save states are set by the cfg, they should be in /sdcard/retroarch/states/<emulator core name>
      #Screenshots are set by the cfg, they should be in /sdcard/retroarch/screenshots/<emulator core name>
      gsgparm -1 1,3,5 -k 18
      #Run any other game
      /tmp/retroarch\
        -c ~/retroarch/config/retroarch.cfg\
        -L ~/retroarch/cores/$GAME_LIB "$4"
      ;;
  esac

  #Exiting game, resetting button LEDs
  gsgparm -0 1,2,3,4,5,6,7,8,9,0,S,P,tball,spin,L1,L2,R1,R2 -1 dpad,A,B,X,Y

#checking to see if the user is trying to reset to the main menu
evtest --query /dev/input/event1 1 16
RESET_CHECK=$?

if [ $RESET_CHECK == 10 ]; then
  #Restart the GSG main menu on exit if the select button is being held
  /usr/bin/uiswitch.sh
fi
