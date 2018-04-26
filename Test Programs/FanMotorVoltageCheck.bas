symbol fan=C.4
symbol arg1=b2
symbol arg2=b3
symbol argw1=w1
symbol returnw=w3
symbol returnw1=returnw
symbol returnb1=b6
symbol returnb2=b7
symbol returnw2=w4
symbol returnb3=b8
symbol returnb4=b9
symbol Fusrfval=w5
symbol Rusrfval=w6
symbol Lusrfval=w7
symbol ldr1val=b16
symbol ldr2val=b17
symbol ldr3val=b18
symbol loopcount=b19
symbol currentlyturning=bit0
symbol turningright=bit1
symbol ldr1on=bit2
symbol ldr2on=bit3
symbol ldr3on=bit4
main:


high fan

pause 2000
low fan
pause 2000
gosub getpower


goto main


getpower:
symbol CALVDD = 52429	; 1024*1.024*1000/20  (DAC steps * Ref V / Resolution in mV)  
	calibadc10 returnw1		; Measure FVR (nominal 1.024 v) relative to Vdd (1024 steps)
	returnw2 = returnw1 / 2 + CALVDD	; Effectively round up CALVDD by half a (result) bit
	returnw2 = returnw2 / returnw1		; Take the reciprocal to calculate (half) Vdd (tens of mV)
	calibadc10 returnw1		; Read the value again because noise may be present :P
	returnw1 = CALVDD / returnw1 + returnw2	; Calculate Vdd/2 again and add in the first value
printpower:
	returnw2 = returnw1 / 100		; Integer volts
	returnw1 = returnw1 // 100		; Decimal part (remainder)
	returnb2 = returnb1 // 10		; Hundredths digit
	returnb1 = returnb1 / 10		; Tenths digit
	sertxd("Vdd= ",#returnw2,".",#returnb1,#returnb2," Volts ")
	return