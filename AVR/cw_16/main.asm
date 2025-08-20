ldi R20, 200
ZEWN: ldi R21, 9
      WEWN: nop
            dec R21
            brne WEWN
      nop
      dec R20
      brne ZEWN
nop