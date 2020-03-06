goto start
#define slave
#include "28x2symbols.bas"
#include "sensorroutines.bas"



start:

gosub verifychip
hi2csetup i2cslave, slaveaddr

main:
'pause 100    ''delay for testing, likely unneded
argb1=j11b    'usrf pins
argb2=j11a    'usrf pins
argb3=0       'usrf number; memory slot+65 
gosub sgetpulse    '''assuming usrf connected to J11 for testing

pause 30
argb1=j13b    'usrf pins
argb2=j13a    'usrf pins
argb3=1       'usrf number; memory slot+65
gosub sgetpulse    '''assuming usrf connected to J11 for testing
#REM
pause 30
argb1=j15b
argb2=j15a
argb3=3
gosub sgetpulse

pause 30
argb1=j14b
argb2=j14a
argb3=2
gosub sgetpulse
#ENDREM

'pause 20
'argb1=j16b
'argb2=j16a
'argb3=4
'gosub sgetpulse

put slaveerrorstatusflags_ptr, slaveerrorstatusflags    'store to send for master




slavetimestamp=slavetimestamp+1
put slavetimestamp_ptr, slavetimestamp 'store to send for master
goto main