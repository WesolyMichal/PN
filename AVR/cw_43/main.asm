.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro

MainLoop:

LOAD_CONST R17, R16, 1234

rcall NumbersToDigits

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