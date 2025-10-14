.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro

.macro SET_DIGIT
    push R16
    
    ldi R16, (0b00010000>>@0)
    out Digits_P, R16

    mov R16, Digit_@0
    rcall DigitTo7segCode
    out Segments_P, R16

    rcall DelayInMs

    pop R16
.endmacro

; Porty

.equ Digits_P=PORTB
.equ Segments_P=PORTD

; Cyfry

.def Digit_0=R5
.def Digit_1=R4
.def Digit_2=R3
.def Digit_3=R2

ldi R16, 0b00011110 ; piny wyjœcia portu B
out DDRB, R16

ldi R16, 0b01111111 ; piny wyjœcia portu D
out DDRD, R16

ldi R16, 6
mov Digit_0, R16

ldi R16, 7
mov Digit_1, R16

ldi R16, 8
mov Digit_2, R16

ldi R16, 9
mov Digit_3, R16
 
MainLoop:
    SET_DIGIT 0
    SET_DIGIT 1
    SET_DIGIT 2
    SET_DIGIT 3
    rjmp MainLoop

DelayInMs:
    push R24
    push R25
    LOAD_CONST R25, R24, 1
    CLCK: rcall DelayOneMs
          sbiw R24, 1
          brne CLCK
    pop R25
    pop R25
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
    push R30
    push R31


    ldi R30, low(DigitTable<<1)
    ldi R31, high(DigitTable<<1)

    add R30, R16

    lpm R16, Z 

    pop R31
    pop R30

    DigitTable: .db $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F 

ret