goto start
#include "28x2symbols.bas"
#include "sensorroutines.bas"

start:

gosub verifychip
hi2csetup i2cslave, slaveaddr

main:
pause 100    ''delay for testing, likely unneded
argb1=j11b    'usrf pins
argb2=j11a    'usrf pins
argb3=0       'usrf number; memory slot+65 
gosub sgetpulse    '''assuming usrf connected to J11 for testing

pause 20
argb1=j12b    'usrf pins
argb2=j12a    'usrf pins
argb3=1       'usrf number; memory slot+65
gosub sgetpulse    '''assuming usrf connected to J11 for testing


put slaveerrorstatusflags_ptr, slaveerrorstatusflags    'store to send for master




slavetimestamp=slavetimestamp+1
put slavetimestamp_ptr, slavetimestamp 'store to send for master
goto main