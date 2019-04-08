'Main Program for v2 of the FireFighter Bot
'written by Patrick Leiser, John Schneider, Kendrick Moore[insert your name here], ...
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


argb1=20
gosub leftwalldistance

'gosub rightwallalign




goto main


ultratest:


gosub mgetpulses


sertxd("Acting on sensor values   ",#usrf1, "  and  ",#usrf2, cr,lf)
if usrf2 < 8 then
	if usrf1 <8 then
		gosub gobackward
	else
		gosub idlestop
	endif
elseif usrf1 < 8 then
	gosub idlestop
else
	gosub goforward
endif

sertxd("usrf data:  ",#returnb1,cr,lf)
return

