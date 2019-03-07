Fire Bot Basic List of Definitions
==================================

Main Directories
----------------

* firefighter.bas is the main file where all others will be called from
* slave.bas is the secondary picaxe controller
* sensorRoutines.bas is where all of the sensor programs are collected
* 40XSymbols.bas contains all of the symbols for the master picaxe
* 28XSymbols.bas contains all of the symbols for the slave picaxe
* motorRoutines.bas holds all of the routines that control the movement through individual motors

Individual Programs
-------------------
* getpulse is the function that sends out and measures the returing pulse
* setupmotors is the function that modulates and initializes the power requiremnts for the motor
* setspeed sets the analog level of the motors
* setspeedl initializes the left motors for a long slow turn
* setspeedr initializes the right motors for a long slow turn
* goforward sets the front two motors to high power which moves the robot straight forward
* steerright allows the robot to turn right in conjunction with forward motion
* steerleft allows the robot to turn left in conjunction with forward motion
* turnright stops the robot and pivots right
* turnleft stops the robot and pivots left
* gobackward immediatly sets the robot in reverse
* powerstop locks the wheels in place
* idlestop allows for momentum to carry the robot foward until it eventually stops

Special Vocabulary Commands
---------------------------
* pulsout sends out an electrical pulse
* pulsin receives the pulse and measures the length
* pause is a break for specific time
* returnw1 is sending data back to the called given function
* pwm duty- sets the analog level for a specific function

Picaxe Commands
---------------
* Put stores memory from a variable into a different section called scratchpad(I2C)
* pause puts a stall in the program allowing time to pass
* gosub calls a sub procedure and temporarily jumps to it and then must jump back

