.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)
.endmacro

ldi R20, $00
ldi R21, $1E

ldi R22, $3F
ldi R23, $06

ldi R24, $7F

out DDRB, R21
out DDRD, R24

out PORTB, R21

MainLoop:
out PORTD, R22

LOAD_CONST R17, R16, 250 
rcall DelayInMs

out PORTD, R23

LOAD_CONST R17, R16, 250 
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