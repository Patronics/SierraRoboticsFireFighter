symbol CALVDD = 52429	; 1024*1.024*1000/20  (DAC steps * Ref V / Resolution in mV)  
Vdd2dp:
	calibadc10 w1		; Measure FVR (nominal 1.024 v) relative to Vdd (1024 steps)
	w2 = w1 / 2 + CALVDD	; Effectively round up CALVDD by half a (result) bit
	w2 = w2 / w1		; Take the reciprocal to calculate (half) Vdd (tens of mV)
	calibadc10 w1		; Read the value again because noise may be present :)
	w1 = CALVDD / w1 + w2	; Calculate Vdd/2 again and add in the first value
Show2dp:
	w2 = w1 / 100		; Integer volts
	w1 = w1 // 100		; Decimal part (remainder)
	b3 = b2 // 10		; Hundredths digit
	b2 = b2 / 10		; Tenths digit
	sertxd("Vdd= ",#w2,".",#b2,#b3," Volts ")
	return