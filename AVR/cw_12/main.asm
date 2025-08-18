      ldi R20, 5
Loop: brbs 1, end
      dec R20
      rjmp Loop
end:  nop