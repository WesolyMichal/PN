MainLoop:
rcall DelayNCycles ;
rjmp MainLoop
DelayNCycles: ;zwyk�a etykieta
rcall Simple
nop
nop
nop
ret ;powr�t do miejsca wywo�ania

Simple:
nop
nop
nop
ret