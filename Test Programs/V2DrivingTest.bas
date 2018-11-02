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


hi2csetup i2cmaster, 62, i2cfast, i2cbyte

main:

gosub getpulse

if w0>8 then
	pwmout MotorpwmA, 150, 150
	pwmout MotorpwmB, 150, 150
else
	pwmout MotorpwmA, 150, 0
	pwmout MotorpwmB, 150, 0

endif

hi2cin 1,(b3)
sertxd ("data from slave", #b3,cr,lf)

goto main





 getpulse:
pulsout gpio21b,2'arg1,2
pulsin gpio21a,1,w0
pause 30
w0=w0*10/58
return