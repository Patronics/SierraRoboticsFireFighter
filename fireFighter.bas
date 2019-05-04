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
high fanpin 'starts with the fan off
toggle green
do while gobutton = 0
	gosub mgetpulses 
	gosub getAlignmentR
	gosub getAlignmentF
	sertxd("waiting for start button")
	high red
	toggle white, green
loop
argb1=50 'was 10 changed to 50
gosub setspeed   'set speed to 10 (5%)

if timer = 0 then
	settimer t1s_8
endif

 do while timer < 3 
	gosub goforward
 loop
	
low red, white, green


main:
; data collection for wall alignment and distance 
gosub mgetpulses 
gosub getAlignmentR
'sertxd("FrontDir: ",#frontDir, cr,lf, "FrontAngle: ",#frontAngle, cr,lf, "FrontDistance", #frontDistance,cr,lf,cr,lf)
'sertxd("RightDir: ", #rightDir, cr, lf, "RightAngle: ", #rightAngle, cr, lf, "RightDistance: ", #rightDistance, cr, lf, cr, lf)

hi2cin slaveerrorstatusflags_ptr, (slaveerrorstatusflags)
hi2cin slavetimestamp_ptr, (slavetimestamp)

'Simple testing

'sertxd("error status flags:  ",#slaveerrorstatusflags,cr,lf)
'sertxd("timestamp:  ",#slavetimestamp,cr,lf)


'argb1=15
'gosub rightwalldistance

 
gosub resetSuggestion 
if firesense=1 then
	gosub flamecheck
endif
argb4 = 15
gosub rightwalldistancesuggestV
'gosub emergencystop
'gosub rightwalldistancesuggest
'gosub frontwallalignsuggest
'gosub rightwallsuggest
gosub frontwallsuggest

'fan :low j21c
sertxd("Behavior ",#SuggestedBehavior, cr,lf, "priority: ",#SuggestionPriority, cr,lf, "intensity:", #SuggestionIntensity,cr,lf,cr,lf)
gosub debugled

on SuggestedBehavior gosub idlestop, goforward, proportionalSteerRight, proportionalSteerLeft, fixedturnright, fixedturnleft, powerstop


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

