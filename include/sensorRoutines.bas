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
	gosub mgetpulse
	@bptrinc = returnb1
next
	
'byte pointer = 24 m+ count'
'@bpointer inc
return

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


getldr:
readadc argb1, returnb1

return

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


getpower:
symbol CALVDD = 52429	; 1024*1.024*1000/20  (DAC steps * Ref V / Resolution in mV)  
	calibadc10 returnw1		; Measure FVR (nominal 1.024 v) relative to Vdd (1024 steps)
	tempw1 = returnw1 / 2 + CALVDD	; Effectively round up CALVDD by half a (result) bit
	tempw1 = tempw1 / returnw1		; Take the reciprocal to calculate (half) Vdd (tens of mV)
	calibadc10 returnw1		; Read the value again because noise may be present :P
	returnw1 = CALVDD / returnw1 + tempw1	; Calculate Vdd/2 again and add in the first value
return

getAlignmentR:
gosub mgetpulses 
rightDistance=RFusrf+RBusrf/2 ' average distance from wall 
  
 if RFusrf < RBusrf then 
	 rightDir = 1 
	 rightAngle = RBusrf - RFusrf 
else 
	 rightDir = 0 
	 rightAngle = RFusrf - RBusrf
endif
return

getAlignmentF:
gosub mgetpulses 
frontDistance=FRusrf+FLusrf/2 ' average distance from wall 
  
 if FRusrf < FLusrf then 
	 frontDir = 1 
	 frontAngle = FRusrf - FLusrf 
else 
	 frontDir = 0 
	 frontAngle =FLusrf - FRusrf
endif
return











