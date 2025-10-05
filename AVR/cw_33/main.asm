.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)
.endmacro

.equ Digits_P=PORTB
.equ Segments_P=PORTD

.def Digit_0=R2
.def Digit_1=R3
.def Digit_2=R4
.def Digit_3=R5

ldi R18, $7F ; piny wyjœcia portu D
ldi R19, $1E ; piny wyjœcia portu B

out DDRB, R19
out DDRD, R18

ldi R20, $3F
mov Digit_0, R20
ldi R20, $06
mov Digit_1, R20
ldi R20, $5B
mov Digit_2, R20
ldi R20, $4F
mov Digit_3, R20
 
MainLoop:
out Segments_P, Digit_0

ldi R21, 0b00000010

out Digits_P, R21 

LOAD_CONST R17, R16, 5 
rcall DelayInMs

out Segments_P, Digit_1

ldi R21, 0b00000100

out Digits_P, R21 

LOAD_CONST R17, R16, 5 
rcall DelayInMs

out Segments_P, Digit_2

ldi R21, 0b00001000

out Digits_P, R21 

LOAD_CONST R17, R16, 5 
rcall DelayInMs

out Segments_P, Digit_3

ldi R21, 0b00010000

out Digits_P, R21 

LOAD_CONST R17, R16, 5 
rcall DelayInMs

rjmp MainLoop

DelayInMs:
CLCK: rcall DelayOneMs
      subi R16, 1
      sbci R17, 0
      brne CLCK
ret

DelayOneMs:
push R16
push R17

LOAD_CONST R17, R16, $7CB

WEWN: subi R16, 1
      sbci R17, 0
      brne WEWN

pop R17
pop R16

ret