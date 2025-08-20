ldi R22, 10
CLCK: ldi R20, 200
      ZEWN: ldi R21, 9
            WEWN: nop
                  dec R21
                  brne WEWN
            nop
            dec R20
            brne ZEWN
      dec R22
      brne CLCK
nop