MainLoop:
ldi R16, 5
rcall DigitTo7segCode
rjmp MainLoop


DigitTo7segCode:
push R29
push R30
push R31

ldi R29, 0

ldi R30, low(DigitTable<<1)
ldi R31, high(DigitTable<<1)

add R30, R16
adc R31, R29

lpm R16, Z 

pop R31
pop R30
pop R29

DigitTable: .db $3F, $06, $5B, $4F, $66, $35, $7D, $07, $7F, $6F 

ret