.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)
.endmacro

MainLoop:
LOAD_CONST R17, R16, 10 
rcall DelayInMs ;
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