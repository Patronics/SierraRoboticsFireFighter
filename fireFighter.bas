'Main Program for v2 of the FireFighter Bot
'written by Patrick Leiser, John Schneider, Kendrick Moore[insert your name here], ...
'and the rest of the firebot team in Sierra College Robotics Club [Team]

goto start




#include "include/40X2Symbols.bas"
#include "include/sensorRoutines.bas"
#include "include/motorRoutines.bas"

   '''To consider: worth making a setup.bas include file? or keep in main file?
   
start: 
timer = 10
gosub verifychip
hi2csetup i2cmaster, slaveaddr, i2cfast, i2cbyte
sertxd("starting!")
pushram
gosub setupmotors
popram
high fanpin 'starts with the fan off
toggle green
do while gobutton = 0
	gosub mgetpulses 
	'gosub getAlignmentR
	'gosub getAlignmentF
	sertxd("waiting for start button")
	high red
	toggle white, green
loop
argb1=35 'was 10 changed to 50
gosub setspeed   'set speed to 10 (5%)

'if timer = 0 then   ''should be unnecessary. delete?
'settimer t1s_8
'endif
'gosub goforward
'pause 3000
 'do while timer < 3 
'	gosub goforward
 'loop
	
'low red, white, green


main:
'gosub flamereact
; data collection for wall alignment and distance 
gosub mgetpulses 

gosub demoDrive
'gosub getAlignmentR
'sertxd("RightDir: ",#rightDir, cr,lf, "RightAngle: ",#RightAngle, cr,lf, "RightDistance", #rightDistance,cr,lf,cr,lf)



'sertxd("FrontDir: ",#frontDir, cr,lf, "FrontAngle: ",#frontAngle, cr,lf, "FrontDistance", #frontDistance,cr,lf,cr,lf)
'sertxd("RightDir: ", #rightDir, cr, lf, "RightAngle: ", #rightAngle, cr, lf, "RightDistance: ", #rightDistance, cr, lf, cr, lf)

hi2cin slaveerrorstatusflags_ptr, (slaveerrorstatusflags)
hi2cin slavetimestamp_ptr, (slavetimestamp)

'Simple testing

'sertxd("error status flags:  ",#slaveerrorstatusflags,cr,lf)
'sertxd("timestamp:  ",#slavetimestamp,cr,lf)


'argb1=15
'gosub rightwalldistance



'gosub resetSuggestion
'gosub rightwallsuggest
'gosub frontwallsuggest
 
'gosub resetSuggestion 
'if firesense=1 then
'gosub flamecheck
'endif
'argb4 = 15
'gosub rightwalldistancesuggestV
'gosub emergencystop
'gosub rightwalldistancesuggest
'gosub frontwallalignsuggest
'gosub rightwallsuggest
'gosub frontwallsuggest
'gosub hardmovecheck

'sertxd("Behavior ",#SuggestedBehavior, cr,lf, "priority: ",#SuggestionPriority, cr,lf, "intensity:", #SuggestionIntensity,cr,lf,cr,lf)
'gosub debugled
'gosub frontTurn

'on SuggestedBehavior gosub idlestop, goforward, proportionalSteerRight, proportionalSteerLeft, fixedturnright, fixedturnleft, powerstop


goto main

demoDrive:
	sertxd("L")
	'gosub mgetpulses
	argb1 = FRusrf + FLusrf
	if argb1  < 20 then
		gosub fixedTurnRight
		pause 100
		'argb1 = 15
		'gosub setspeedr
		'argb1 = 25
		'gosub setspeedl
	else
		argb1=35 'was 10 changed to 50
		gosub setspeed   'set speed to 10 (5%)
		gosub goForward
	endif
return


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

