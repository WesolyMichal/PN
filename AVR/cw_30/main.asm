.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)
.endmacro

.equ Digits_P=PORTB
.equ Segments_P=PORTD

ldi R18, $7F ; piny wyjœcia portu D
ldi R19, $1E ; piny wyjœcia portu B

out DDRB, R19
out DDRD, R18

ldi R20, $3F ; zero

out Segments_P, R20
 
MainLoop:
ldi R21, 0b00000010

out Digits_P, R21 

LOAD_CONST R17, R16, 5 
rcall DelayInMs

ldi R21, 0b00000100

out Digits_P, R21 

LOAD_CONST R17, R16, 5 
rcall DelayInMs

ldi R21, 0b00001000

out Digits_P, R21 

LOAD_CONST R17, R16, 5 
rcall DelayInMs

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