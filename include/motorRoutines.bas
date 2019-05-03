
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

fixedturnright:    ''turn right at a fixed speed
argb1= 80 '100
gosub setspeed
      '''Intentionally falls into turnright
turnright:
	'sertxd("Turning Right",cr,lf)
	high LmotorDir1
	low LmotorDir2
	low RmotorDir1
	high RmotorDir2
return


fixedturnleft:    ''turn left at a fixed speed
argb1= 80 '100
gosub setspeed
      '''Intentionally falls into turnleft
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

proportionalSteerRight:
	gosub goforward
	argb1 = 60 - SuggestionIntensity * 2 / 3
	argb2 = 60 * 2 / 3
	gosub setspeeds
return
proportionalSteerLeft:
	gosub goforward
	argb2 = 60 - SuggestionIntensity * 2 / 3
	argb1 = 60 * 2 / 3
	gosub setspeeds
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

resetSuggestion:
	SuggestedBehavior=0    ''default behavior is to stop
	SuggestionPriority=0     ''very low priority, overwritten by all other behaviors
	SuggestionIntensity=0   
	''''gosub evalSuggestion   'Intentionally removed to override priority higharchy 
return
rightwalldistancesuggestV:

	tempb1 = argb4 
	gosub getAlignmentR
	tempb2 = tempb1 + 10 'upper bound allowance
	tempb3 = tempb1 - 2 'lower bound allowance
	if rightAngle < 3 then
		if rightDistance < tempb1 then
			possibleSuggestedBehavior = 3
			possibleSuggestionPriority = tempb1 - rightDistance * 8 max 50
			possibleSuggestionIntensity = tempb1 - rightDistance * 6 max 50
			'argb1 =50
			'argb2 = 30
			'gosub setspeeds
			'gosub goforward
			sertxd("I am too close to the wall", cr, lf, "SuggestedBehavior: ", #possibleSuggestedBehavior, cr, lf )
			gosub evalSuggestion 
			'high blue low red low green
	
		else if rightDistance > tempb1 then
			possibleSuggestedBehavior = 2
			possibleSuggestionPriority = rightDistance - tempb1 * 10 max 50 '8
			'argb1 = 50
			'argb2 = 30
			'gosub setspeeds
			'gosub goforward 
			'high red low blue low green
			sertxd("I am too far to the wall", cr, lf, "SuggestedBehavior: ", #possibleSuggestedBehavior, cr, lf )
			possibleSuggestionIntensity = rightDistance - tempb1 * 6 max 50
			gosub evalSuggestion
		else
			possibleSuggestedBehavior = 1
			possibleSuggestionPriority = 5
			sertxd("I am perfectly close to the wall", cr, lf, "SuggestedBehavior: ", #possibleSuggestedBehavior, cr, lf )
			'argb1 = 50
			'argb2 = 50
			'gosub setspeeds
			'gosub goforward 
			'high green low red low blue
			gosub evalSuggestion
		
		endif
		
	else
		gosub rightwallsuggest
		
	endif
	
	
return

rightwalldistancesuggest:

	tempb1 = argb1
	
	gosub getAlignmentR
	tempb2 = tempb1 + 2 'upper bound allowance
	tempb3 = tempb1 - 2 'lower bound allowance
	if rightDistance < tempb3 then
		possibleSuggestedBehavior = 3
		possibleSuggestionPriority = tempb1 - rightDistance * 4 max 45
		possibleSuggestionIntensity = 30 'tempb1 - rightDistance * 6 max 50
		'argb1 = 60 -30
		'argb2 = 60
		'gosub steerleft
		gosub evalSuggestion
	
	else if rightDistance > tempb2 then
		possibleSuggestedBehavior = 2
		possibleSuggestionPriority = rightDistance - tempb1 * 4 max 45
		'argb1 = 60
		'argb2 = 60 - 30
		'gosub steerright
		possibleSuggestionIntensity = 30 'rightDistance - tempb1 * 6 max 50
		gosub evalSuggestion
	else
		possibleSuggestedBehavior = 1
		possibleSuggestionPriority = 5
		'argb1 = 60
		'argb2 = 60
		'gosub goforward
		gosub evalSuggestion
		
	endif
	
	
return

frontwallalignsuggest:

	gosub getAlignmentF
	if frontAngle = 0 then
		possibleSuggestedBehavior = 1
		possibleSuggestionPriority = 2
		gosub evalSuggestion
	else
		if frontDir = 0 then
			possibleSuggestedBehavior = 3
			possibleSuggestionPriority =20 + frontAngle max 30
			possibleSuggestionIntensity= frontAngle * 8 max 60
			gosub evalSuggestion
		else
			possibleSuggestedBehavior= 2
			possibleSuggestionPriority= 20 + rightAngle max 30
			possibleSuggestionIntensity=rightAngle * 8 max 60
			gosub evalSuggestion
		endif
	endif	
return
rightwallsuggest:    ''''Suggest behavior based on right wall sensors.

	gosub mgetpulses 
	gosub getAlignmentR
	if rightAngle=0 then
		possibleSuggestedBehavior=1
		possibleSuggestionPriority=10   ''mild preference for going straight
		gosub evalSuggestion
	else
		if rightDir=0 then   ''tend to align with wall, with medium-low priority
			possibleSuggestedBehavior=2
			possibleSuggestionPriority=12+rightAngle max 30
			possibleSuggestionIntensity=rightAngle*8 max 60
			gosub evalSuggestion
			'argb1 =30
			'argb2 = 50
			'gosub setspeeds
			'gosub goforward
			sertxd("I am angled too much away from the wall", cr, lf, "SuggestedBehavior: ", #possibleSuggestedBehavior, cr, lf)
		else
			possibleSuggestedBehavior=3
			possibleSuggestionPriority=12+rightAngle max 30
			possibleSuggestionIntensity=rightAngle*8 max 60
			gosub evalSuggestion
			'argb1 = 50
			'argb2 = 30
			'gosub setspeeds
			'gosub goforward
			sertxd("I am angled too nuch towards the wall", cr, lf, "SuggestedBehavior: ", #possibleSuggestedBehavior, cr, lf )
		endif
	endif
return

frontwallsuggest:
	gosub mgetpulses 
	gosub getAlignmentF
	
	if frontDistance < 32 then
		if RightDistance < 32 then ''TODO: Make this based on both left and right sensors
			possibleSuggestedBehavior=5
			possibleSuggestionPriority=50
			possibleSuggestionIntensity=35
			gosub evalSuggestion
	else' else                (should be more indented)
			possibleSuggestedBehavior=4
			possibleSuggestionPriority=50
			possibleSuggestionIntensity=35
			gosub evalSuggestion
	endif'endif           (should be more indented, stupid axepad bug preventing it	
	
	endif
return

rightwallalign:
	gosub goforward
	do
	gosub mgetpulses 
	gosub getAlignmentR
	if rightDir=0 then 
		tempb1 = rightAngle
		tempb1 = tempb1 * 8 max 60
		argb1 = 60 - tempb1
		argb2 = 60
		gosub setspeeds
	else
		tempb1 = rightAngle
		tempb1 = tempb1 * 8 max 60
		argb2 = 60 - tempb1
		argb1 = 60
		gosub setspeeds
	endif
	loop
return


