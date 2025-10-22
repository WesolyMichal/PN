/***MACRO***/        
.macro LOAD_CONST
ldi @0, low(@2)
ldi @1, high(@2)
.endmacro

/*** Display ***/
.equ DigitsPort = PORTB
.equ SegmentsPort = PORTD
.equ DisplayRefreshPeriod = 5

/*** SET_DIGIT***/
.macro SET_DIGIT
    push R16
    ldi r16, (1<<(@0+1))
    out DigitsPort, r16   ;Init Seg_0
    mov R16, Dig_@0  
    rcall DigitTo7segCode  
    out SegmentsPort, R16 ;Light Dig_0
    rcall DelayInMs
    pop R16
.endmacro

; ### GLOBAL VARIABLES ###
.def PulseEdgeCtrL=R0 
.def PulseEdgeCtrH=R1

.def Dig_0=R2
.def Dig_1=R3
.def Dig_2=R4
.def Dig_3=R5

.; ### INTERRUPT VECTORS ###
.cseg		     ; segment pamiêci kodu programu 

.org	 0      rjmp	_main	
.org OC1Aaddr	rjmp  _Timer_ISR
.org 0x0B   rjmp  _ExtInt_ISR   ;ZMIENIC NA 0x0B


/*** INTERRUPT SEERVICE ROUTINES ***/

_ExtInt_ISR: 	 
/**/
    push R24
    push R25
    in R24, SREG
Increment:
    inc PulseEdgeCtrL
    brne NoOverflow
    inc PulseEdgeCtrH
    rjmp NoOverflow
NoOverflow:
    out SREG, R24
    pop R25
    pop R24
/**/
reti      


_Timer_ISR:
    push R16
    push R17
    push R18
    push R19
/**/
    push r20
    in r20,SREG
        movw r16:r17, PulseEdgeCtrL:PulseEdgeCtrH
        clr PulseEdgeCtrL
        clr PulseEdgeCtrH
        rcall NumberToDigits
        movw Dig_0:Dig_1, r16:r17
        movw Dig_2:Dig_3, r18:r19
    out SREG, r20
    pop r20
/**/
	pop R19
    pop R18
    pop R17
    pop R16

  reti


_main:

/*** Ext. ints ***/
push R16
cli
ldi R16, (1 << PCIE0)    
out GIMSK, R16
ldi R16, (1 << ISC00) 
out PCMSK0, R16
sei
pop R16

/***Timer1 CTC wwich 256 Prescaler***/
    push r16
    push r17

    ldi r16, (1 << WGM12) | (1 << CS12)  
    out TCCR1B, r16
    ldi r16, (1 << OCIE1A)  
    out TIMSK, r16
    ldi R17, 61
    ldi R16, 8
    out OCR1AH, R17  
    out OCR1AL, R16
    pop r17
    pop r16

/***Display***/
ldi R18, $0
mov Dig_0, R18
ldi R18, $0
mov Dig_1, R18
ldi R18, $0
mov Dig_2, R18
ldi R18, $0
mov Dig_3, R18
clr r18   
ldi r16, 0x7F      
out DDRD, r16
ldi r16, 0x1E    
out DDRB, r16
clr r16

/***Enable Global Interrupts***/
SEI

MainLoop:

SET_DIGIT 0
SET_DIGIT 1
SET_DIGIT 2
SET_DIGIT 3       
   
rjmp MainLoop       

; internals 
.def Dig0=R22 ; Digits temps 
.def Dig1=R23 ;  
.def Dig2=R24 ;  
.def Dig3=R25 ;       
            
; inputs   ;MOVE HERE FROM BOTTOM
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




NumberToDigits:
push Dig0
push Dig1
push Dig2
push Dig3
/**/
;Thousand
LOAD_CONST YL, YH, 1000 
rcall Divide
mov Dig0,QL
;Hundreds
LOAD_CONST YL, YH, 100  
rcall Divide
mov Dig1, QL
 ;Tens
LOAD_CONST YL, YH, 10  
rcall Divide
mov Dig2, QL
;Ones
mov Dig3, RL
/**/
mov XL,Dig0
mov XH,Dig1
mov YL,Dig2
mov YH,Dig3
pop Dig3
pop Dig2
pop Dig1
pop Dig0
ret


Divide:
push R24
push R25
/**/
clr r24
clr r25
Compare:
    cp  XL, YL     
    cpc XH, YH    
    brcs end_div  
    sub XL, YL    
    sbc XH, YH   
    adiw QCtrL, 1  
    rjmp Compare  
end_div:
    movw RL, XL
    movw QL, QCtrl
/**/

    pop R25
    pop R24
    ret

/***DIGITT_TO_7_SEGMENT***/
Table: .db 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F 

DigitTo7segCode:
push R30
push R31
/**/
ldi R30, low(Table<<1)   
ldi R31, high(Table<<1) 
add R30, R16
lpm R16, Z    
/**/
pop R31
pop R30
ret

/***DelayInMs***/
DelayInMs:
    push R24
    push R25 
    LOAD_CONST R24, R25, $5 ;5ms  200Hz Segment (50Hz ca³y)
    InsideDelayInMs:
    rcall OneMsLoop
    sbiw R24, 1
    brne InsideDelayInMs
    pop R25
    pop R24
    ret

/***OneMsLoop***/
OneMsLoop:
    push r30
    push r31
    LOAD_CONST R30, R31, $07CB ;1995us
    InsideDelayOneMs:
        sbiw r30, 1
        brcc InsideDelayOneMs
        pop r31
        pop r30
        ret