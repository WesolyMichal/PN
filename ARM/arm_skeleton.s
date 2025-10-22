#include <LPC21xx.H>

LDR R0, =1000

adr R1, MainLoop:
	nop
	subs R0, #1
BEQ R1

end