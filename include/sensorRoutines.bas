'sensorRoutines.bas
'for Sierra College Robotics Club
'subroutines for getting data from sensors
'
' 'ambidextrous' functions eg getpulse
' master function eg mgetpulse
' slave function eg sgetpulse

'get distance from ultrasonic

mgetpulses:

'argb1=0
'gosub mgetpulse
'put slaveusrf_ptr_start,returnb1
'argb1=1
'gosub mgetpulse
'put ,returnb1
bptr = 24
for loopCount = 0 to 7
	argb1 = loopCount
	pushram
	gosub mgetpulse
	popram
	@bptrinc = returnb1
next
	
'byte pointer = 24 m+ count'
'@bpointer inc
return
;**DOC:  This is the basic USRF data collection function. both mgetpulse and sgetpulse call this function to get data from the USRFs. 
getpulse:
	pulsout argb1,2
	pulsin argb2,1,returnw1
	pause 30
	returnw1=returnw1*5/58  ''''we are changing the number from 10/58 which gives cm this is no longer the case!!!!!""""""
return

mgetpulse:
'TODO: get pulse to master from slave
tempb1=argb1+slaveusrf_ptr_start   'calculate memory offset for usrf in slave scratchpad
;sertxd("getting address ",#tempb1)
hi2cin tempb1, (returnb1)
'sertxd("usrf #",#argb1,"  data:  ",#returnb1,cr,lf)
return

sgetpulse:
	gosub getpulse
	if returnb1<>returnw1 then
		returnb3=1
	else
		returnb3=0
	endif
	returnb1=returnw1
	argb3=slaveusrf_ptr_start+argb3
	'sertxd ("storing utra: ", #returnb1,cr,lf)
	put argb3, returnb1     'store to send for master
return


mgetstatusflag:
hi2cin 127, (returnb1)

return
#ifndef slave
getldrs:
readadc ldr1,ldrl
readadc ldr2,ldrr
#endif

return
'getldr:      ''1 line comand makes it unnecessary
'readadc argb1, returnb1

'return

verifychip:

readtable tableID_ptr, tempb1
'sertxd ("TableValue: ",tempb1)
if tempb1 <> tableID then
	traploop:
		sertxd (cr,lf,"Warning: Device ID ")    'device ID set by table location zero
		if tempb1=0 then
			sertxd ("Unset")
		else
			sertxd ("Unknown: ",tempb1)
		endif
		pause 500
	goto traploop
endif

return

'evalSuggestion:     ''pick the higher priority of two suggested behaviors
'if possibleSuggestionPriority > SuggestionPriority then
'	SuggestedBehavior=possibleSuggestedBehavior
'	SuggestionPriority=possibleSuggestionPriority
'	SuggestionIntensity=possibleSuggestionIntensity
'	'else keep original suggestion (higher priority)
'endif
'return

'	gosubgetub mgetpulses 
	 'rightDistance=RFusrf+RBusrf/2 ' average distance from wall 
' 	if RFusrf < RBusrf then
 ''		rightDistance = RFusrf
 '	else
 '		rightDistance = RBusrf
 '	endif
 '	if RFusrf < RBusrf then 
'		 rightDir = 1 
'		rightAngle = RBusrf - RFusrf 
 '	else 
'		 rightDir = 0 
'		 rightAngle = RFusrf - RBusrf
 '	endif
'return

'getAlignmentF:
'	  gosub mgetpulses 
'	  'frontDistance=FRusrf+FLusrf/2 ' average distance from wall 
 ' 	if FRusrf < FLusrf then
  '		frontDistance = FRusrf
  '	else 
  '		frontDistance = FLusrf
  '	endif
  '	
'	 if FRusrf < FLusrf then 
'		 frontDir = 1 
'		 frontAngle = FLusrf - FRusrf 
'	 else 
'		 frontDir = 0 
'	 	frontAngle =FRusrf - FLusrf
'	 endif
'return


getpower:
symbol CALVDD = 52429	; 1024*1.024*1000/20  (DAC steps * Ref V / Resolution in mV)  
	calibadc10 returnw1		; Measure FVR (nominal 1.024 v) relative to Vdd (1024 steps)
	tempw1 = returnw1 / 2 + CALVDD	; Effectively round up CALVDD by half a (result) bit
	tempw1 = tempw1 / returnw1		; Take the reciprocal to calculate (half) Vdd (tens of mV)
	calibadc10 returnw1		; Read the value again because noise may be present :P
	returnw1 = CALVDD / returnw1 + tempw1	; Calculate Vdd/2 again and add in the first value
return
 
 hardmovecheck:
 
 	'sertxd("the sensor data from the left encoder is: ", #Lencoder, cr, lf,  "the sensor data from the right encoder is: ", #Rencoder, cr, lf)
 	if oldLencoder = Lencoder then
 		Lencodercount = Lencodercount + 1
 		low green
 	else
 		Lencodercount = 0
 		oldLencoder = Lencoder
 		high green
 		
 	endif
 	
 	if Lencodercount = 18 then
 		low white
 		'high green
 		'low red
 		argb1 = 35
 		gosub setspeed
 		gosub gobackward
 		pause 1000
 		Lencodercount = 0
 		Rencodercount = 0
 		argb1 = 70
 		gosub setspeed
 		gosub turnright
 		pause 1000
 	endif
 	
 	if oldRencoder = Rencoder then
 		Rencodercount = Rencodercount + 1
 		low red
 	else
 		Rencodercount = 0
 		oldRencoder = Rencoder
 		high red
 	endif
 	
 	if Rencodercount = 18 then
 		high white
 		'low green
 		'low red
 		argb1 = 35
 		gosub setspeed
 		gosub gobackward
 		pause 1000
 		Rencodercount = 0
 		Lencodercount = 0
 		'turn left
 		argb1 = 70
 		gosub setspeed
 		gosub turnleft
 		pause 1000
 	endif
 	
 	
 return
 
 
 debugled: 
 	
 	low red
 	low green 
 	low white
 	if suggestedbehavior= 2 then
 		high white
 		low red
 		low green 
 	else if suggestedbehavior = 3 then
 		high red
 		low green
 		low white
 	else if suggestedbehavior = 1 then
 		high green
 		low red
 		low green
 	else
 		low red
 		low green
 		low white
 	endif
 	
 return








