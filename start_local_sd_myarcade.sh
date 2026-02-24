#!/bin/sh
#FC		fceumm_libretro.so
#GB/GBA/GBC	mgba_libretro.so/gpsp_libretro.so
#MD		genesisplusgx_libretro.so
#SFC 		snes9x_libretro.so
#XC_ATARI2600		stella_libretro.so
#XC_ATARI7800		prosystem_libretro.so
#FB Jungle_libretro.so
#M3 Jungle2003_libretro.so
#M16 Jungle2016_libretro.so
#usr/lib/libretro

export XDG_CONFIG_HOME=/data
export XDG_RUNTIME_DIR=/data

GAME_PATH=
GAME_LIB=

export LC_ALL='zh_CN.utf8'

case "$2" in
  0)
    GAME_LIB=
    ;;
  1)
    #GAME_LIB=nestopia_libretro.so
	GAME_LIB=fceumm_libretro.so
    ;;
  2)
    GAME_LIB=genesisplusgx_libretro.so
    ;;
  3)
    GAME_LIB=snes9x_libretro.so
    ;;
  4)
    GAME_LIB=mgba_libretro.so
    ;;
  5)
    GAME_LIB=stella2014_libretro.so
    ;;
  6)
    GAME_LIB=prosystem_libretro.so
    ;;
  7)
    GAME_LIB=Jungle2016_libretro2.so
    ;;
  8)
    GAME_LIB=Jungle2016_libretro_new.so
    ;;
  9)
    GAME_LIB=fbneo_libretro.so
    ;;
  10)
    GAME_LIB=Jungle2003_libretro.so
    ;;
  11)
    GAME_LIB=Jungle2016_libretro.so
    ;;
  12)
    GAME_LIB=a5200_libretro.so
	#GAME_LIB=atari800_libretro.so
    ;;
  13)
    GAME_LIB=handy_libretro.so
    ;;
  14)
    GAME_LIB=virtualjaguar_libretro.so
    ;;
  15)
    GAME_LIB=stella
    ;;
  16)
    GAME_LIB=mednafen_pce_fast_libretro.so
    ;;
  17)
    GAME_LIB=mupen64plus_libretro.so
    ;;
  18)
    GAME_LIB=pcsx_rearmed_libretro.so
    ;;
  19)
    GAME_LIB=mednafen_ngp_libretro.so
    ;;
  20)
    GAME_LIB=flycast_libretro.so
    ;;
  21)
    GAME_LIB=mednafen_wswan_libretro.so
    ;;
  22)
    GAME_LIB=ppsppss.sh
    #GAME_LIB=ppsspp_libretro.so
    ;;
  23)
	GAME_LIB=freeintv_libretro.so
	;;
  24)
	GAME_LIB=snes9x2002_libretro.so
	;;
  *)
    echo "Have not game resources"
    return
    ;;
esac

if [ "$2" == 15 ]; then
#/usr/bin/stella "$3"
/usr/bin/stella $3 "$4"

else
	#if [[ "$2" == 11 || "$2" == 8 ]]; then
	if [ "$2" == 22 ]; then
		/userdata/ppsspp/ppsspp.sh "$4"
			
	else
		/usr/bin/retroarch -y "12"\
			-k "$1"\
			-c "$3"\
			-L /usr/lib/libretro/$GAME_LIB "$4"
			
	fi
	
#/usr/lib/libretro/$GAME_LIB "$3"
fi

