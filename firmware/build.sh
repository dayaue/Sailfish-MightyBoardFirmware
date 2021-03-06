#!/bin/sh

FWDIR=`pwd`
DISTDIR=
REPGDIR=$HOME/.replicatorg/firmware

if [ -f $HOME/.makerbot_config_build.sh ] ; then
    . $HOME/.makerbot_config_build.sh
    if [ $FWDIR_MB ] ; then
	FWDIR="$FWDIR_MB"
    fi
fi

if [ -d ../../../../branches ] ; then
  SVN=`svnversion ../../../.. | awk -f $FWDIR/svnversion.awk`
else
  SVN=`svnversion $FWDIR | awk -f $FWDIR/svnversion.awk`
fi

VER=`awk -F'.' '{printf("%d.%d.%d",$1,$2,$3); exit}' $FWDIR/current_version.txt`

for BUILD in "mighty_one" "mighty_one-corexy" "mighty_one-2560" "mighty_one-2560-max31855" "mighty_one-2560-corexy" "mighty_two" "mighty_two-2560" "mighty_twox" "mighty_twox-2560" "mighty_one-zlevel" "ff_creator" "ff_creator-2560" "wanhao_dup4"
do

    MAX31855=""
    BMAX31855=""
    ZLEVEL=""
    BZLEVEL=""
    COREXY=""
    BCOREXY=""

    if [ "$BUILD" = "mighty_one-2560-max31855" ] ; then
	BUILD="mighty_one-2560"
	MAX31855="max31855=1"
	BMAX31855="-max31855"
    fi

    if [ "$BUILD" = "mighty_one-2560-corexy" ] ; then
	BUILD="mighty_one-2560"
	COREXY="core_xy=1"
	BCOREXY="-corexy"
    fi

    if [ "$BUILD" = "mighty_one-corexy" ] ; then
	BUILD="mighty_one"
	COREXY="core_xy=1"
	BCOREXY="-corexy"
    fi

    if [ "$BUILD" = "mighty_one-zlevel" ] ; then
	BUILD="mighty_one"
	ZLEVEL="zlevel=1"
	BZLEVEL="-zlevel"
    fi

    rm -rf build/$BUILD

    scons platform=$BUILD $MAX31855 $ZLEVEL $COREXY
    ./checksize.sh $BUILD
    if [ $? -ne 0 ]; then
	exit 1
    fi

    if [ $REPGDIR ] ; then
	cp build/$BUILD/*.hex  $REPGDIR/$BUILD$BMAX31855$BCOREXY$BZLEVEL-Sailfish-v${VER}-r${SVN}.hex
    fi
    if [ $DISTDIR ] ; then
	cp build/$BUILD/*.hex  $DISTDIR/$BUILD$BMAX31855$BCOREXY$BZLEVEL-Sailfish-v${VER}-r${SVN}.hex
    fi

    rm -rf build/$BUILD

    scons platform=$BUILD broken_sd=1 $MAX31855 $ZLEVEL $COREXY
    ./checksize.sh $BUILD
    if [ $? -ne 0 ]; then
	exit 1
    fi

    if [ $REPGDIR ] ; then
	cp build/$BUILD/*b.hex  $REPGDIR/$BUILD$BMAX31855$BCOREXY$BZLEVEL-Sailfish-v${VER}-r${SVN}b.hex
    fi
    if [ $DISTDIR ] ; then
	cp build/$BUILD/*b.hex  $DISTDIR/$BUILD$BMAX31855$BCOREXY$BZLEVEL-Sailfish-v${VER}-r${SVN}b.hex
    fi

done
