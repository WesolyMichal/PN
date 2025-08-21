MainLoop:
ldi R24, 10
sts $60, R24
rcall DelayInMs ;
rjmp MainLoop

DelayInMs:
CLCK: rcall DelayOneMs
      dec R24
      brne CLCK
ret

DelayOneMs:
sts $60, R24
sts $61, R25

ldi R24, $CB
ldi R25, $7

WEWN: sbiw R25:R24, 1
      brne WEWN

lds R24, $60
lds R25, $61
nop

ret