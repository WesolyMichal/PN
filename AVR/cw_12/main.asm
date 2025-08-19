      ldi R20, 5
Loop: brbs 1, End
      dec R20
      rjmp Loop
End:  nop