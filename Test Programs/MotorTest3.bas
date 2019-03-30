

goto start
#include "include/40X2Symbols.bas"
#include "include/sensorRoutines.bas"
#include "include/motorRoutines.bas"



start:

pushram
gosub setupmotors
popram

argb1=100
gosub setspeed   'set speed to 100 (50%)

main:

gosub steerright

pause 1000

gosub idlestop

pause 1000


goto main