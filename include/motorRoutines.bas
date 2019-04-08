
setupmotors:
	output RmotorPWM, LmotorPWM
	pwmout RmotorPWM,  199, 0
	pwmout LmotorPWM,  199, 0
	'with 199 period=10kHz, duty cycle can range from 0 (0%) to 800 (100%)
	'starts at 0% duty cycle.
	
return

setspeed:  'pass in byte value 0-200 for duty cycle
	tempw1=argb1*4
	pwmduty RmotorPWM, tempw1
	pwmduty LmotorPWM, tempw1
return

setspeedl:  'pass in byte value 0-200 for duty cycle for left motor
	tempw1=argb1*4
	pwmduty LmotorPWM, tempw1
return

setspeedr:  'pass in byte value 0-200 for duty cycle for left motor
	tempw1=argb1*4
	pwmduty RmotorPWM, tempw1
return

setspeeds:  'pass in byte value 0-200 for duty cycle for motors
	tempw1=argb1*4
	tempw2=argb2*4
	pwmduty RmotorPWM, tempw1
	pwmduty LmotorPWM, tempw2
	
return
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

rightwalldistance:
	'argb1 specifes target distance in 1/2 cm steps
	'tempb1 is difference between sensors*scalar
	'tempb2 is average distance from wall
	'tempb3 is offset distance to correct*scalar
	gosub goforward
	tempb4=argb1*2
	do
	gosub mgetpulses
	tempb2=RFusrf+RBusrf/2
	tempb3=tempb2*2-tempb4
	if RFusrf > RBusrf then    'if rightFront farther from wall than rightBack
		tempb1 = RFusrf-RBusrf
		tempb1 = tempb1 * 8 max 60
		argb1 = 60 - tempb1+tempb3 '+ 12
		gosub setspeedr
		argb1 = 60
		gosub setspeedl
	else                                'if rightBack farther from wall than rightFront
		tempb1 = RBusrf-RFusrf
		tempb1 = tempb1 * 8 max 60
		argb1 = 60 - tempb1-tempb3
		gosub setspeedl
		argb1 = 60 '+ 12
		gosub setspeedr
	endif
	loop
return


rightwallalign:
	gosub goforward
	do
	gosub mgetpulses 
	if RFusrf > RBusrf then 
		tempb1 = RFusrf-RBusrf
		tempb1 = tempb1 * 8 max 60
		argb1 = 60 - tempb1 '+ 12
		argb2 = 60
		gosub setspeeds
	else
		tempb1 = RBusrf-RFusrf
		tempb1 = tempb1 * 8 max 60
		argb2 = 60 - tempb2
		argb1 = 60 '+ 12
		gosub setspeeds
	endif
	loop
return



