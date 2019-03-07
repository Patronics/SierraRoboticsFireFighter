'Main Program for v2 of the FireFighter Bot
'written by Patrick Leiser, [insert your name here], ...
'and the rest of the firebot team in Sierra College Robotics Club [Team]

goto start




#include "include/40X2Symbols.bas"
#include "include/sensorRoutines.bas"
#include "include/motorRoutines.bas"

   '''To consider: worth making a setup.bas include file? or keep in main file?
   
start: 
gosub verifychip
hi2csetup i2cmaster, slaveaddr, i2cfast, i2cbyte

pushram
gosub setupmotors
popram

main:


hi2cin slaveerrorstatusflags_ptr, (slaveerrorstatusflags)
hi2cin slavetimestamp_ptr, (slavetimestamp)
argb1=0
gosub mgetpulse
'Simple testing
sertxd("usrf data:  ",#returnb1,cr,lf)
sertxd("error status flags:  ",#slaveerrorstatusflags,cr,lf)
sertxd("timestamp:  ",#slavetimestamp,cr,lf)



pause 1000





goto main