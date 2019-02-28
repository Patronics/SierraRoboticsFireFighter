
goto start
#include "28x2symbols.bas"
#include sensorroutines.bas

start:
hi2csetup i2cslave, slaveaddr

main:
pause 100    ''delay for testing, likely unneded
arg1=j11b    'usrf pins
arg2=j11a    'usrf pins

gosub sgetpulse    '''assuming usrf connected to J11 for testing

if returnb1<>returnw1 then
	bit0=1
else
	bit0=0
endif
put b0, slaveerrorstatusflags_ptr     'store to send for master
put returnb1, slaveusrf_ptr_start     'store to send for master


slavetimestamp=slavetimestamp+1
put slavetimestamp_ptr, slavetimestamp 'store to send for master
goto main