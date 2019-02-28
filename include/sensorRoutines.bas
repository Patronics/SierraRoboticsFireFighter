'sensorRoutines.bas
'for Sierra College Robotics Club
'subroutines for getting data from sensors
'
' 'ambidextrous' functions eg getpulse
' master function eg mgetpulse
' slave function eg sgetpulse

'get distance from ultrasonic
getpulse:
	pulsout argb1,2
	pulsin argb2,1,returnw1
	pause 30
	returnw1=returnw1*10/58
return

mgetpulse:
'TODO: get pulse to master from slave
tempb1=argb1+slaveusrf_ptr_start   'calculate memory offset for usrf in slave scratchpad
hi2cin tempb1, (returnb1)


return

sgetpulse:

	gosub getpulse

return


mgetstatusflag:
hi2cin 127, (returnb1)

return


getldr:
readadc argb1, returnb1

return



getpower:
symbol CALVDD = 52429	; 1024*1.024*1000/20  (DAC steps * Ref V / Resolution in mV)  
	calibadc10 returnw1		; Measure FVR (nominal 1.024 v) relative to Vdd (1024 steps)
	tempw1 = returnw1 / 2 + CALVDD	; Effectively round up CALVDD by half a (result) bit
	tempw1 = tempw1 / returnw1		; Take the reciprocal to calculate (half) Vdd (tens of mV)
	calibadc10 returnw1		; Read the value again because noise may be present :P
	returnw1 = CALVDD / returnw1 + tempw1	; Calculate Vdd/2 again and add in the first value
return
