ldi R20, 5
ZEWN: ldi R21, 100
      WEWN: nop
            dec R21
            brne WEWN
      dec R20
      brne ZEWN