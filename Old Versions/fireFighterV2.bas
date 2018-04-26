#PICAXE 28X2
#no_data
#no_table

sertxd("restarting complete")
'-------pin assignements-------
'Ultrasonic Range Finders
#define usrf_test
#define motor_test

symbol usrf1=C.1   'TODO: pick pins 
symbol usrf1_in=C.0
symbol Fusrf=usrf1
symbol Fusrf_In=usrf1_in
symbol usrf2= A.2
symbol usrf2_in=A.3
symbol Rusrf=usrf2
symbol Rusrf_in=usrf2_in
'symbol usrf3=
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
symbol LmotorDir1=B.6  ''TODO
symbol LmotorDir2=B.7
symbol RmotorDir1=B.4
symbol RmotorDir2=B.5
'symbol LmotorForward=LmotorDir1
'symbol LmotorReverse=LmotorDir2
'symbol RmotorForward=RmotorDir1
'symbol RmotorReverse=RmotorDir2
''Light Dependent Resistor
'symbol ldr1=
'symbol ldr2=
'symbol ldr3=
'Other I/O
'symbol solenoidDriver=
'symbol irSensor=
'-----contstants------
symbol fullspeed=1023
symbol halfspeed=512
symbol quarterspeed=256
symbol stopspeed=0
'-----Variables-------
symbol arg1=b0
symbol arg2=b1
symbol argw1=w0
symbol returnw=w4
symbol Fusrfval=w5
symbol Rusrfval=w6
#ifdef motor_test
hpwm pwmsingle, pwmHHHH, %0110, 128,1023
high RmotorDir1
low RmotorDir2
high LmotorDir1
low LmotorDir2
#endif


'-------------main---------------
main:
#ifdef usrf_test
arg1=usrf1    'send pin of usrf 1 to getpulse
arg2=usrf1_in
gosub getpulse
w5=returnw           'average two samples, smoothing out data
gosub getpulse
w5=w4+w5/2

arg1=Rusrf
arg2=Rusrf_in
gosub getpulse
w6=returnw           'average two samples, smoothing out data
gosub getpulse
w6=w4+w6/2

#ifdef motor_test
if w5<10 then             'backup if too close to wall
	gosub gobackward
'hpwmDuty 1023
elseif Fusrfval<45 then      '''stop if near wall
	if Rusrfval < 45 then    'if wall detected on right
		gosub turnleft  'turn left
	else                       
		gosub turnright  'otherwise right
		;gosub powerstop
	endif
'hpwmDuty 1023
else                           'go forward until near a wall
gosub goforward
endif
#endif
pause 50
'arg1=usrf2    'enable to use 2nd ultrasonic
'gosub getpulse
'debug
sertxd ("USRF 1 returned a distance of ",#w5," cM",CR,LF)
sertxd ("USRF 2 returned a distance of ",#w6," cM",CR,LF,cr,lf)
'if w4>10 then
#endif
'	high motor1
'else
'	low motor1
'endif

goto main

goforward:
	sertxd("Going Forward",cr,lf)
	high LmotorDir1
	low LmotorDir2
	high RmotorDir1
	low RmotorDir2
return

turnright:
	sertxd("Turning Right",cr,lf)
	high LmotorDir1
	low LmotorDir2
	low RmotorDir1
	high RmotorDir2
return

turnleft:
	sertxd("Turning Left",cr,lf)
	low LmotorDir1
	high LmotorDir2
	high RmotorDir1
	low RmotorDir2
return

gobackward:
	sertxd("Backing Up",cr,lf)
	low LmotorDir1
	high LmotorDir2
	low RmotorDir1
	high RmotorDir2
return

powerstop:
	sertxd("Active Stop",cr,lf)
	high LmotorDir1
	high LmotorDir2
	high RmotorDir1
	high RmotorDir2
return

idlestop:
	sertxd("Passive Stop",cr,lf)
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
'readadc    ''TODO finish:

return
