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

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

clr PulseEdgeCtrL
clr PulseEdgeCtrH

MainLoop:
    inc PulseEdgeCtrL
    brne Overflow
    inc PulseEdgeCtrH
    Overflow:
    LOAD_CONST R17, R16, 10000
    cp PulseEdgeCtrL, R16
    brne NoOverflow
    cp PulseEdgeCtrH, R17
    brne NoOverflow

    clr PulseEdgeCtrL
    clr PulseEdgeCtrH

    NoOverflow:
    mov R16, PulseEdgeCtrL
    mov R17, PulseEdgeCtrH

    rcall NumbersToDigits

    mov Digit_0, R16
    mov Digit_1, R17
    mov Digit_2, R18
    mov Digit_3, R19

    SET_DIGIT 0
    SET_DIGIT 1
    SET_DIGIT 2
    SET_DIGIT 3

rjmp MainLoop

;*** Divide ***
    ; X/Y -> Quotient,Remainder
    ; Input/Output: R16-19, Internal R24-25

    ; inputs
    .def XL=R16 ; divident
    .def XH=R17

    .def YL=R18 ; divisor
    .def YH=R19

    ; outputs
    .def RL=R16 ; remainder
    .def RH=R17

    .def QL=R18 ; quotient
    .def QH=R19

    ; internal
    .def QCtrL=R24
    .def QCtrH=R25

    ;*** NumberToDigits ***
    ;input : Number: R16-17
    ;output: Digits: R16-19
    ;internals: X_R,Y_R,Q_R,R_R - see _Divide

    ; internals

    .def Dig0=R22 ; Digits temps
    .def Dig1=R23 ;
    .def Dig2=R24 ;
    .def Dig3=R25 ;

NumbersToDigits:
    push Dig0
    push Dig1
    push Dig2
    push Dig3

    LOAD_CONST YH, YL, 1000
    rcall Divide
    mov Dig0, QL

    LOAD_CONST YH, YL, 100
    rcall Divide
    mov Dig1, QL
    
    LOAD_CONST YH, YL, 10
    rcall Divide
    mov Dig2, QL

    mov Dig3, RL

    mov XL, Dig3
    mov XH, Dig2
    mov YL, Dig1
    mov YH, Dig0

    pop Dig3
    pop Dig2
    pop Dig1
    pop Dig0
    ret

Divide:

    push R24
    push R25

    clr R24
    clr R25

    DivLoop:
    cp XL, YL
    cpc XH, YH
    brcs DivEnd

    sub XL, YL
    sbc XH, YH

    adiw QCtrH:QctrL, 1

    rjmp DivLoop

    DivEnd:

    movw QH:QL, QCtrH:QCtrL

    pop R25
    pop R24

ret

DelayInMs:
    push R24
    push R25
    LOAD_CONST R25, R24, 5
    CLCK: rcall DelayOneMs
          sbiw R24, 1
          brne CLCK
    pop R25
    pop R25
ret

DelayOneMs:
    push R16
    push R17

    LOAD_CONST R17, R16, $07CB

    WEWN: subi R16, 1
          sbci R17, 0
          brne WEWN

    pop R17
    pop R16

ret

DigitTable: .db $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F

DigitTo7segCode:
    
    
    push R30
    push R31


    ldi R30, low(DigitTable<<1)
    ldi R31, high(DigitTable<<1)

    add R30, R16

    lpm R16, Z 

    pop R31
    pop R30

ret

