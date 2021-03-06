

#no_table      'to keep the unique identifier of master and slave
''''NOTE this also automatically does #no_data (so prepopulating eeprom will be nonfunctional until this is removed

symbol tableID_ptr = 0    'master/slave differentiator location in table

symbol slaveaddr=62
symbol slavetimestamp = b20     'incremented every time through the slave program loop
symbol slavetimestamp_ptr= 20

symbol slaveusrf_ptr_start = 65     'scratchpad locations 65-74 reserved for up to 10 usrf measurements

symbol slaveerrorstatusflags=b0
symbol slaveerrorstatusflags_ptr = 0

symbol integeroverflowflag=bit0

symbol argb1=b2
symbol argb2=b3
symbol argw1=w1

symbol argb3=b4
symbol argb4=b5
symbol argw2=w2
 
 
symbol returnb1=b16
symbol returnb2=b17
symbol returnw1=w8

symbol returnb3=b18
symbol returnb4=b19
symbol returnw2=w9


symbol tempb1=b8
symbol tempb2=b9
symbol tempw1=w4

symbol tempb3=b10
symbol tempb4=b11
symbol tempw2=w5

symbol tempb5 = b12
symbol loopCount=b14