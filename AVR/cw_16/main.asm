ldi R20, 200
ZEWN: ldi R21, 8
      WEWN: nop
            dec R21
            brne WEWN
      dec R20
      brne ZEWN