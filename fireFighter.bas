'Main Program for v2 of the FireFighter Bot
'written by Patrick Leiser, [insert your name here], ...
'and the rest of the firebot team in Sierra College Robotics Club [Team]

goto start

#define bigblue

#include "include/40X2Symbols.bas"
#include "include/sensorRoutines.bas"
#include "include/motorRoutines.bas"

   '''To consider: worth making a setup.bas include file? or keep in main file?
   
start: 

hi2csetup i2cmaster, slaveaddr, i2cfast, i2cbyte

gosub setupmotors

main:
;;;Simple motor test
sertxd("looping")
arg1=50
gosub setspeed
gosub goforward
pause 3000

arg1=100
gosub setspeed
pause 3000

arg1=50
gosub setspeed
gosub gobackward
pause 3000








goto main: