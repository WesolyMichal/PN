.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro

MainLoop:

LOAD_CONST R17, R16, 11
LOAD_CONST R19, R18, 4

rcall Divide

rjmp MainLoop

Divide:

    push R24
    push R25

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