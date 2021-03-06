#! /bin/sh

echo Needed packages for cygwin:
echo - scons gcc-g++ make patch subversion wget bison 
echo - libgmp-devel libmpfr-devel libmpc-devel    
echo - doxygen
echo -----------------------------------
echo ----- build gcc does not work -----
echo -----------------------------------
echo Press ENTER to continue
read VAR

set -x
set -e

USRNAME=`whoami`
#PREFIX=/home/${USRNAME}/opt/avr/
PREFIX=/usr/local/
export PREFIX

PATH=${PREFIX}bin:${PATH}

BINUTILS_VERSION=2.22
#MPC_VERSION=0.9
#MPFR_VERSION=3.1.2
GCC_VERSION=4.6.3
AVR_LIBC_VERSION=1.7.2rc2252
#AVRDUDE_VERSION=5.10
AVRDUDE_VERSION=6.1

#MPC_PREFIX=/home/${USRNAME}/opt/mpc-${MPC_VERSION}
MPC_PREFIX=/

#echo Next step: binutils - press ENTER
#read VAR

#if test ! -d binutils-${BINUTILS_VERSION}
#then
	wget -N -P incoming http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.bz2
	bzip2 -dc incoming/binutils-${BINUTILS_VERSION}.tar.bz2 | tar xf -
#fi
if test ! -d binutils-${BINUTILS_VERSION}/obj-avr
then
	mkdir binutils-${BINUTILS_VERSION}/obj-avr
fi
	cd binutils-${BINUTILS_VERSION}/obj-avr
	../configure --prefix=${PREFIX} --target=avr --disable-nls --enable-install-libbfd
	make
	make install
	cd ../..


#echo Next step: mpfr - press ENTER
#read VAR

#if test ! -d  mpfr-${MPFR_VERSION}
#then
#	wget -N -P incoming http://www.mpfr.org/mpfr-current/mpfr-${MPFR_VERSION}.tar.bz2
#	bzip2 -dc incoming/mpfr-${MPFR_VERSION}.tar.bz2 | tar xf -
#fi

#if test ! -d mpfr-${MPFR_VERSION}
#	cd mpfr-${MPFR_VERSION}
#	./configure --prefix=${PREFIX}
#	make
#	make install
#	cd ..
#exit


#echo Next step: mpc - press ENTER
#read VAR

#if test ! -d mpc-${MPC_VERSION}
#then
#	wget -N -P incoming http://www.multiprecision.org/mpc/download/mpc-${MPC_VERSION}.tar.gz
# 	gzip -dc incoming/mpc-${MPC_VERSION}.tar.gz | tar xf -
# 	cd mpc-${MPC_VERSION}
#	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/me/local/lib
#	#apt-get install  libgmp4-dev # may be needed for gmp.h header
# 	./configure --prefix=${MPC_PREFIX} 
# 	make
# 	make install
# 	cd ..
#fi

# export LD_LIBRARY_PATH=${MPC_PREFIX}/lib/

echo Next step: gcc - press ENTER
read VAR

wget -N -P incoming http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-core-${GCC_VERSION}.tar.bz2
wget -N -P incoming http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-g++-${GCC_VERSION}.tar.bz2
	bzip2 -dc incoming/gcc-core-${GCC_VERSION}.tar.bz2 | tar xf -
	bzip2 -dc incoming/gcc-g++-${GCC_VERSION}.tar.bz2 | tar xf -
if test ! -d gcc-${GCC_VERSION}/obj-avr
then
	mkdir gcc-${GCC_VERSION}/obj-avr
fi
	cd gcc-${GCC_VERSION}/obj-avr
	../configure --prefix=$PREFIX --target=avr --enable-languages=c,c++ --enable-lto --disable-nls --disable-libssp --with-dwarf2 MISSING=texinfo # --with-mpc=${MPC_PREFIX}
	make
	make install
	cd ../..


echo Next step: libc - press ENTER
read VAR

wget -N -P incoming http://download.savannah.gnu.org/releases/avr-libc/avr-libc-${AVR_LIBC_VERSION}.tar.bz2
#if test ! -d avr-libc-${AVR_LIBC_VERSION}
#then
	bzip2 -dc incoming/avr-libc-${AVR_LIBC_VERSION}.tar.bz2 | tar xf -
	if test -f incoming/avr-libc-${AVR_LIBC_VERSION}-gcc-${GCC_VERSION}.patch
	then
		cd avr-libc-${AVR_LIBC_VERSION}
		patch -p1 < ../incoming/avr-libc-${AVR_LIBC_VERSION}-gcc-${GCC_VERSION}.patch
		# autoreconf
		cd ..
	fi
	cd avr-libc-${AVR_LIBC_VERSION}
	./configure --prefix=${PREFIX} --build=$(./config.guess) --host=avr
	make
	make install
	cd ..
#fi


echo Next step: avrdude - press ENTER
read VAR

# if test ! -d avrdude-${AVRDUDE_VERSION}
# then
	wget -N -P incoming http://download.savannah.gnu.org/releases/avrdude/avrdude-${AVRDUDE_VERSION}.tar.gz
 	gzip -dc incoming/avrdude-${AVRDUDE_VERSION}.tar.gz | tar xf -
 	cd avrdude-${AVRDUDE_VERSION}
 	./configure --prefix=/home/mws/opt/avrdude-${AVRDUDE_VERSION}
 	make
 	make install
 	cd ..
# fi
