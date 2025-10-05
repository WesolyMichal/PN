.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)
.endmacro

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

ldi R20, $00
ldi R21, $1E

OUT DDRB, R21

MainLoop:
OUT PORTB, R21

LOAD_CONST R17, R16, 5 
rcall DelayInMs

OUT PORTB, R20

LOAD_CONST R17, R16, 5 
rcall DelayInMs

rjmp MainLoop