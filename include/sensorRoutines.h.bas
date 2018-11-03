'sensorRoutines.bas
'for Sierra College Robotics Club
'subroutines for getting data from sensors


getpulse (arg1 : USRF_PIN_TO_PULSE, arg2 : USRF_INPUT_PIN)
return (returnw1 : DISTANCE_IN_CM)

getldr (arg1 : LDR_PIN)
return (returnb1 : LDR_VALUE)

getpower ()
return (returnw1 : VOLTAGE_IN_10_mVOLT_STEPS, returnw2 : GARBAGE_DATA)