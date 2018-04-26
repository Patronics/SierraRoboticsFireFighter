#PICAXE 28X2
#no_data
#no_table

sertxd("restarting!",cr,lf)
'-------pin assignments-------
'Ultrasonic Range Finders
'			pinout:
'			28X2
'                _________________
'   Reset     |                        |   B.7   Left motor 1
'		|			|   B.6    Left motor 2
'		|			|
'                |
'
'
'
'
'
'
'
'
'
'
'
'

symbol usrf1=C.1    
symbol usrf1_in=C.0
symbol Fusrf=usrf1
symbol Fusrf_In=usrf1_in
symbol usrf2= A.2
symbol usrf2_in=A.3
symbol Rusrf=usrf2
symbol Rusrf_in=usrf2_in
symbol usrf3=A.0
symbol usrf3_in=A.1
symbol Lusrf=usrf3
symbol Lusrf_in=usrf3_in

'symbol usrf4=
'symbol usrf5=
'symbol usrf6=
'symbol usrfFront=usrf1
'symbol usrfLeft=usrf2
'symbol usrfRight=usrf3
'...
'Motor control pins
symbol RmotorPWM=B.2   'hpwm outputs
symbol LmotorPWM=B.1   'hpwm outputs
symbol LmotorDir1=B.7 
symbol LmotorDir2=B.6
symbol RmotorDir1=B.5
symbol RmotorDir2=B.4
'symbol LmotorForward=LmotorDir1
'symbol LmotorReverse=LmotorDir2
'symbol RmotorForward=RmotorDir1
'symbol RmotorReverse=RmotorDir2
''Light Dependent Resistor
symbol ldr1=19
symbol ldr2=18
symbol ldr3=17
'Other I/O
'symbol solenoidDriver=
symbol gobutton=pinB.0
symbol fan=C.4
symbol irSensor=pinC.2
'-----contstants------
symbol fullspeed=1023
symbol halfspeed=512
symbol quarterspeed=256
symbol stopspeed=0

'''LDR Data
symbol ldrthresh=125
symbol checkgreater=bit5   ''workaround for if statement bug
checkgreater=1     
'-----Variables-------
symbol arg1=b2
symbol arg2=b3
symbol argw1=w1
symbol returnw=w3
symbol returnw1=returnw
symbol returnb1=b6
symbol returnb2=b7
symbol returnw2=w4
symbol returnb3=b8
symbol returnb4=b9
symbol Fusrfval=w5
symbol Rusrfval=w6
symbol Lusrfval=w7
symbol ldr1val=b16
symbol ldr2val=b17
symbol ldr3val=b18
symbol loopcount=b19
symbol currentlyturning=bit0
symbol turningright=bit1
symbol ldr1on=bit2
symbol ldr2on=bit3
symbol ldr3on=bit4
symbol loopcount2=b20
symbol timer2=b21
symbol state=b22
rebootloop:

do
	sertxd("Waiting for 'GO'",cr,lf)
	gosub getUsrf
	gosub checkldrs         
	gosub printsensors
	'gosub getpower
	
loop while gobutton=0

	sertxd("Starting Main Program!",cr,lf,cr,lf)

settimer t1s_8

hpwm pwmsingle, pwmHHHH, %0110, 128,1023     'change back to 2023 for full speed
high RmotorDir1
low RmotorDir2
high LmotorDir1
low LmotorDir2




'-------------main---------------
main:
hpwmduty 1023
'goto firescan


gosub getUsrf


if fusrfval<10 and timer>2 then             'backup if too close to wall
	gosub gobackward
'hpwmDuty 1023
elseif Rusrfval > 165 and Lusrfval > 155 and state=0 then     '''both were 165     
	sertxd ("Turning right, 'infinite' distance seen")
	gosub steerright
	pause 1500
elseif Rusrfval > 165 and Fusrfval > 155 and state=1 then     '''test for front path    
	sertxd ("Turning right, 'infinite' distance seen")
	gosub steerright
	pause 1500
elseif Fusrfval<40 and timer>2 then    'if very close to wall, sharp turn
	if Rusrfval<Lusrfval then
		gosub turnleft
	else
		pause 500
		gosub turnright
		turningright=1    '''''TESTING, remove if fails
	endif
elseif Fusrfval<70 and timer>2 then   ''Was 85   'if farther away but approaching, start gradual turn
	if currentlyturning=1 then; and turningright=1 then
	'dont change from current turning pattern
	if turningright=1 then
		gosub turnright
	else
		gosub turnleft
	endif
	
	elseif Lusrfval <60 then    
		'gosub steerright
		'pause 200    'removal#7
		gosub turnright
		turningright=1
	elseif Rusrfval < 60 then    'if wall detected on right
		gosub steerleft'turnleft  'turn left
		'pause 200     'removal#7
		turningright=0
		'gosub turnleft

	else                       
		gosub steerright'turnright  'otherwise right
		'pause 200     'removal#7
		turningright=1
		;gosub powerstop
		'pause 500
	endif
	currentlyturning=1
'hpwmDuty 1023
elseif timer>2   then                        'go forward until near a wall
	currentlyturning=0
	if Rusrfval<13 then
		gosub steerleft
	elseif Lusrfval<13 then
		gosub steerright
	else
		gosub goforward
	endif
endif

'pause 50
'arg1=usrf2    'enable to use 2nd ultrasonic
'gosub getpulse
'debug
gosub checkldrs
gosub printsensors

if ldr1on=1 or ldr2on=1 or ldr3on=1 then     ''''''   now old: CHANGE BACK TO 4, 200 ONLY FOR TESTING!!
	timer2=timer2+3
	if timer2<timer then
		let loopcount2=0
		timer2=timer2-3
		goto firescan
	endif
	timer2=timer2-3
endif


goto main

firescan2:
	gosub goforward
	gosub checkldrs
	if ldr1on=1 and ldr2on=1 and ldr3on=1 then
		if loopcount2>1 then    'was 6
			goto firescan
		endif
		inc loopcount2
		for loopcount = 0 to 100' was 50
			gosub turnright
			'sertxd("firescan2 part 1",cr,lf)
			pause 20
			if irSensor=0 then
				high fan
				'sertxd("firescan2 part 2",cr,lf)
				'goto firescan2
				gosub powerstop
				pause 200
			else
				'sertxd("firescan2 part 3",cr,lf)
				gosub turnright
				'low fan
			
			endif

		next loopcount
		for loopcount = 0 to 200 ' was 100
			gosub turnleft
			pause 20
			if irSensor=0 then
				'sertxd("firescan2 part 4",cr,lf)
				high fan
				'goto firescan2
				gosub powerstop
				pause 200
			else
				'sertxd("firescan2 part 5",cr,lf)
				low fan
				gosub turnleft
			endif
		next loopcount
	endif
goto firescan2
firescan:                                                        '''TODO:  Add routine to exit fire scan after sucessful extuinguish or no fire found (see paper flowchart)
	if state=0 then
		state=1
	endif
	hpwmduty 255
	'sertxd("firescan part 1",cr,lf)
	gosub turnright
	
	inc loopcount2
	if loopcount2>1 then     'was 6
		timer2=timer
		goto main
	endif
	for loopcount = 0 to 100    'was 50
		gosub turnright
		pause 20
		if irSensor=0 then
			'high fan
			'sertxd("firescan part 2",cr,lf)
			let loopcount2=0 
			goto firescan2
			'gosub powerstop
			'pause 200
		else
			'sertxd("firescan part 3",cr,lf)
			gosub turnright
			'low fan
			
		endif

	next loopcount
	for loopcount = 0 to 200    '
		gosub turnleft
		pause 20
		if irSensor=0 then
			'high fan
			'sertxd("firescan part 4",cr,lf)
			goto firescan2
			'gosub powerstop
			'pause 5000
		else
			'sertxd("firescan part 5",cr,lf)
			'low fan
			gosub turnleft
		endif

	next loopcount


goto firescan
'goto main


goforward:
	'sertxd("Going Forward",cr,lf)
	high LmotorDir1
	low LmotorDir2
	high RmotorDir1
	low RmotorDir2
return

steerright:
	'sertxd("Steering Right (and forward)",cr,lf)
	high LmotorDir1
	low LmotorDir2
	low RmotorDir1
	low RmotorDir2
return
steerleft:
	'sertxd("Steering Left (and forward)",cr,lf)
	low LmotorDir1
	low LmotorDir2
	high RmotorDir1
	low RmotorDir2
return
turnright:
	'sertxd("Turning Right",cr,lf)
	high LmotorDir1
	low LmotorDir2
	low RmotorDir1
	high RmotorDir2
return

turnleft:
	'sertxd("Turning Left",cr,lf)
	low LmotorDir1
	high LmotorDir2
	high RmotorDir1
	low RmotorDir2
return

gobackward:
	'sertxd("Backing Up",cr,lf)
	low LmotorDir1
	high LmotorDir2
	low RmotorDir1
	high RmotorDir2
return

powerstop:
	'sertxd("Active Stop",cr,lf)
	high LmotorDir1
	high LmotorDir2
	high RmotorDir1
	high RmotorDir2
return

idlestop:
	'sertxd("Passive Stop",cr,lf)
	low LmotorDir1
	low LmotorDir2
	low RmotorDir1
	low RmotorDir2
return

getpulse:
pulsout arg1,2
pulsin arg2,1,returnw
pause 30
returnw=returnw*10/58
return

getldr:
readadc arg1, returnb1

return

checkldrs:
arg1=ldr1
gosub getldr
ldr1val=returnb1  
if ldr1val<ldrthresh and checkgreater=0  then
	ldr1on=1
elseif ldr1val>ldrthresh and checkgreater=1 then
	ldr1on=1
else
	ldr1on=0
endif
arg1=ldr2
gosub getldr
ldr2val=returnb1
if ldr2val>ldrthresh and checkgreater=1 then
	ldr2on=1
elseif ldr2val<ldrthresh and checkgreater=0 then
	ldr2on=1
else
	ldr2on=0
endif
arg1=ldr3
gosub getldr
ldr3val=returnb1
if ldr3val<ldrthresh and checkgreater=0 then
	ldr3on=1
elseif ldr3val>ldrthresh and checkgreater=1 then
	ldr3on=1
else
	ldr3on=0
endif
return

getUsrf:
	arg1=usrf1    'send pin of usrf 1 to getpulse
	arg2=usrf1_in
	gosub getpulse
	w5=returnw           'average two samples, smoothing out data
	gosub getpulse
	w5=returnw+w5/2

	arg1=Rusrf
	arg2=Rusrf_in
	gosub getpulse
	w6=returnw           'average two samples, smoothing out data
	gosub getpulse
	w6=returnw+w6/2

	arg1=Lusrf
	arg2=Lusrf_in
	gosub getpulse
	w7=returnw           'average two samples, smoothing out data
	gosub getpulse
	w7=returnw+w7/2
return


printsensors:
	sertxd ("USRF 1 returned a distance of ",#w5," cm",CR,LF)
	sertxd ("USRF 2 returned a distance of ",#w6," cm",CR,LF)
	sertxd ("USRF 3 returned a distance of ",#w7," cm",CR,LF,CR,LF)
	sertxd("LDR 1 returned a value of ",#ldr1val, cr,lf)
	sertxd("LDR 2 returned a value of ",#ldr2val, cr,lf)
	sertxd("LDR 3 returned a value of ",#ldr3val, cr,lf)
	if ldr1on=1 then 
		sertxd("LDR 1 detecting value over threshold", cr,lf)
	endif
	if ldr2on=1 then 
		sertxd("LDR 2 detecting value over threshold", cr,lf)
	endif
	if ldr3on=1 then 
		sertxd("LDR 3 detecting value over threshold",cr,lf)
	endif
	sertxd("timer=  ",timer,cr,lf)
return

''''''''''''''''''Power Supply Voltage Check

getpower:
symbol CALVDD = 52429	; 1024*1.024*1000/20  (DAC steps * Ref V / Resolution in mV)  
	calibadc10 returnw1		; Measure FVR (nominal 1.024 v) relative to Vdd (1024 steps)
	returnw2 = returnw1 / 2 + CALVDD	; Effectively round up CALVDD by half a (result) bit
	returnw2 = returnw2 / returnw1		; Take the reciprocal to calculate (half) Vdd (tens of mV)
	calibadc10 returnw1		; Read the value again because noise may be present :P
	returnw1 = CALVDD / returnw1 + returnw2	; Calculate Vdd/2 again and add in the first value
printpower:
	returnw2 = returnw1 / 100		; Integer volts
	returnw1 = returnw1 // 100		; Decimal part (remainder)
	returnb2 = returnb1 // 10		; Hundredths digit
	returnb1 = returnb1 / 10		; Tenths digit
	sertxd("Vdd= ",#returnw2,".",#returnb1,#returnb2," Volts ")
	return