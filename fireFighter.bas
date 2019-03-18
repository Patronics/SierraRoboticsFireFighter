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


argb1=100
gosub setspeed   'set speed to 100 (50%)

main:


hi2cin slaveerrorstatusflags_ptr, (slaveerrorstatusflags)
hi2cin slavetimestamp_ptr, (slavetimestamp)

'Simple testing

sertxd("error status flags:  ",#slaveerrorstatusflags,cr,lf)
sertxd("timestamp:  ",#slavetimestamp,cr,lf)


gosub ultratest



goto main


ultratest:

argb1=0
pushram
gosub mgetpulse
popram
tempb1=returnb1
argb1=1
pushram
gosub mgetpulse
popram
tempb2=returnb2

if returnb2 < 8 then
	if returnb1 <8 then
		gosub gobackward
	else
		gosub idlestop
	endif
elseif returnb1 < 8 then
	gosub idlestop
else
	gosub goforward
endif

sertxd("usrf data:  ",#returnb1,cr,lf)
return

