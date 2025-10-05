ldi R22, 9
CLCK: ldi R24, $CF
      ldi R25, $7
      WEWN: sbiw R25:R24, 1
            brne WEWN
      dec R22
      brne CLCK
nop