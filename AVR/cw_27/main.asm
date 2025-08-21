MainLoop:
ldi R16, low(10)
ldi R17, high(10)
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

ldi R16, $CB
ldi R17, $7

WEWN: subi R16, 1
      sbci R17, 0
      brne WEWN

pop R17
pop R16

ret