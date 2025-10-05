MainLoop:
ldi R16, 5
rcall SquareNm
rjmp MainLoop


SquareNm:
push R29
push R30
push R31

ldi R29, 0

ldi R30, low(SqTable<<1)
ldi R31, high(SqTable<<1)

add R30, R16
adc R31, R29

lpm R16, Z 

pop R31
pop R30
pop R29
SqTable: .db 0, 1, 4, 9, 16, 25, 36, 49, 64, 81
ret