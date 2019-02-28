'Main Program for v2 of the FireFighter Bot
'written by Patrick Leiser, [insert your name here], ...
'and the rest of the firebot team in Sierra College Robotics Club [Team]

goto start



#include "include/40X2Symbols.bas"
#include "include/sensorRoutines.bas"
#include "include/motorRoutines.bas"

   '''To consider: worth making a setup.bas include file? or keep in main file?
   
start: 

hi2csetup i2cmaster, slaveaddr, i2cfast, i2cbyte
pushram
gosub setupmotors
popram
main:

hi2cin slaveerrorstatusflags_ptr, (slaveerrorstatusflags)
hi2cin slavetimestamp_ptr, (slavetimestamp)
hi2cin slaveusrf_ptr_start,(tempb1)
'Simple testing
sertxd("usrf data:  ",#tempb1)
sertxd("error status flags:  ",#slaveerrorstatusflags)
sertxd("timestamp:  ",#slavetimestamp)











goto main: