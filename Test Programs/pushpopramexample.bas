goto start




#include "include/40X2Symbols.bas"
#include "include/sensorRoutines.bas"
#include "include/motorRoutines.bas"

   '''To consider: worth making a setup.bas include file? or keep in main file?
   
start: 

gosub foo

goto start

foo:

for tempb1=0, 10
	pushram
	gosub bar
	popram
loop

return

bar:

tempb1=7
return
