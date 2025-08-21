MainLoop:
ldi R22, 10
rcall DelayInMs ;
rjmp MainLoop

DelayInMs:
CLCK: rcall DelayOneMs
      dec R22
      brne CLCK
ret

DelayOneMs:
nop
ldi R24, $CD
ldi R25, $7
WEWN: sbiw R25:R24, 1
      brne WEWN
ret