#picaxe 40X2
symbol motorAin1 = D.1
symbol motorAin2 = D.0
symbol motorBin1 = D.2
symbol motorBin2 = D.3

symbol motorpwmA = C.1
symbol motorpwmB = C.2

'symbol RmotorPWM=  'hpwm outputs
'symbol LmotorPWM=B.1   'hpwm outputs
'symbol LmotorDir1=B.7 
'symbol LmotorDir2=B.6
'symbol RmotorDir1=B.5
'symbol RmotorDir2=B.4

symbol gpio21a=A.0
symbol gpio21b=A.1
symbol usrf1=gpio21b   
symbol usrf1_in=gpio21a

output  motorpwmA
output  motorpwmB
low motorAin1
high motorAin2
low motorBin2
high motorBin1

main:

gosub getpulse

if w0>8 then
	pwmout MotorpwmA, 20, 1023
	pwmout MotorpwmB, 20, 1023
else
	pwmout MotorpwmA, 20, 0
	pwmout MotorpwmB, 20, 0

endif



goto main





 getpulse:
pulsout gpio21b,2'arg1,2
pulsin gpio21a,1,w0
pause 30
w0=w0*10/58
return