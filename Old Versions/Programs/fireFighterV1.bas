#PICAXE 20X2
#no_data
#no_table
symbol usrf1=B.0
'symbol usrf2=B.1    'add when more ultrasonic sensors 
symbol motor1=C.0   'LED for testing for now
symbol checkpin=b2
main:
checkpin=usrf1
gosub getpulse
'checkpin=usrf2
'gosub getpulse
'debug
sertxd ("USRF 1 returned a distance of ",#w4," cM",CR,LF)
if w4>10 then
	high motor1
else
	low motor1
endif

goto main


getpulse:
pulsout checkpin,2
pulsin checkpin,1,w4
pause 20
w4=w4*10/58
return