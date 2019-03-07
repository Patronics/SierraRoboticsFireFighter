goto start
#include "28x2symbols.bas"
#include sensorroutines.bas

start:

gosub verifychip
hi2csetup i2cslave, slaveaddr

main:
pause 100    ''delay for testing, likely unneded
argb1=j11b    'usrf pins
argb2=j11a    'usrf pins
pushram
gosub sgetpulse    '''assuming usrf connected to J11 for testing
popram
if returnb1<>returnw1 then
	integeroverflowflag=1
else
	integeroverflowflag=0
endif
returnb1=returnw1
put slaveerrorstatusflags, slaveerrorstatusflags_ptr     'store to send for master
put returnb1, slaveusrf_ptr_start     'store to send for master

sertxd ("usrf ",#returnb1)

slavetimestamp=slavetimestamp+1
put slavetimestamp_ptr, slavetimestamp 'store to send for master
goto main