InfL: nop
      nop
      nop
      nop
      ldi R20, 5
Loop: dec R20
      nop
      breq InfL
      rjmp Loop ; Cycles = (R20*5)