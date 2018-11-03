'sensorRoutines.bas
'for Sierra College Robotics Club
'subroutines for getting data from sensors

'this .h.bas file is not actually run by the program, 
'but is used to communicate to humans what variables are 
'written and read to/from in subroutine in the included file


getpulse (arg1 : USRF_PIN_TO_PULSE, arg2 : USRF_INPUT_PIN)
return (returnw1 : DISTANCE_IN_CM)

getldr (arg1 : LDR_PIN)
return (returnb1 : LDR_VALUE)

getpower ()
return (returnw1 : VOLTAGE_IN_10_mVOLT_STEPS, returnw2 : GARBAGE_DATA)