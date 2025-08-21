MainLoop:
rcall DelayNCycles ;
rjmp MainLoop
DelayNCycles: ;zwyk³a etykieta
rcall Simple
nop
nop
nop
ret ;powrót do miejsca wywo³ania

Simple:
nop
nop
nop
ret