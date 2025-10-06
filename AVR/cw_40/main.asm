.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro

.macro SET_DIGIT
    push R16
    push R17

    ldi R17, @0
    inc R17

    DIGIT0:
    dec R17
    brne DIGIT1

    out Segments_P, Digit_0
    ldi R16, 0b00010000
    out Digits_P, R16
     
    rjmp DIGIT_END

    DIGIT1:
    dec R17
    brne DIGIT2

    out Segments_P, Digit_1
    ldi R16, 0b00001000
    out Digits_P, R16
    
    rjmp DIGIT_END

    DIGIT2:
    dec R17
    brne DIGIT3

    out Segments_P, Digit_2
    ldi R16, 0b00000100
    out Digits_P, R16

    rjmp DIGIT_END

    DIGIT3:
    dec R17
    brne DIGIT_END

    out Segments_P, Digit_3
    ldi R16, 0b00000010
    out Digits_P, R16

    DIGIT_END:

    LOAD_CONST R17, R16, 5
    rcall DelayInMs

    pop R17
    pop R16
.endmacro

.equ Digits_P=PORTB
.equ Segments_P=PORTD

.def Digit_0=R5
.def Digit_1=R4
.def Digit_2=R3
.def Digit_3=R2


ldi R16, 0b00011110 ; piny wyjœcia portu B
out DDRB, R16

ldi R16, 0b01111111 ; piny wyjœcia portu D
out DDRD, R16

ldi R16, 0
rcall DigitTo7segCode
mov Digit_0, R16

ldi R16, 0
rcall DigitTo7segCode
mov Digit_1, R16

ldi R16, 0
rcall DigitTo7segCode
mov Digit_2, R16

ldi R16, 0
rcall DigitTo7segCode
mov Digit_3, R16
 
MainLoop:
    SET_DIGIT 0
    SET_DIGIT 1
    SET_DIGIT 2
    SET_DIGIT 3
    rjmp MainLoop

DelayInMs:
    CLCK: rcall DelayOneMs
          subi R16, 1
          sbci R17, 0
          brne CLCK
ret

DelayOneMs:
    push R16
    push R17

    LOAD_CONST R17, R16, $7CB

    WEWN: subi R16, 1
          sbci R17, 0
          brne WEWN

    pop R17
    pop R16

ret

DigitTo7segCode:
    push R29
    push R30
    push R31

    ldi R29, 0

    ldi R30, low(DigitTable<<1)
    ldi R31, high(DigitTable<<1)

    add R30, R16
    adc R31, R29

    lpm R16, Z 

    pop R31
    pop R30
    pop R29

    DigitTable: .db $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F 

ret