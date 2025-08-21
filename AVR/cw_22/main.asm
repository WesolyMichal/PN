MainLoop:
ldi R22, 10
rcall DelayInMs ;
rjmp MainLoop

DelayInMs:
CLCK: ldi R24, $CF
      ldi R25, $7
      WEWN: sbiw R25:R24, 1
            brne WEWN
      dec R22
      brne CLCK
ret
