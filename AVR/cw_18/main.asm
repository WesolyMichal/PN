ldi R22, 10
CLCK: ldi R20, $C1
      ldi R21, $F9
      WEWN: inc R20
            brne NCAR
            inc R21
            NCAR: brne WEWN
      nop
      dec R22
      brne CLCK
nop