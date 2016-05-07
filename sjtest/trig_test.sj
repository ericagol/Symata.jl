#### Cosh, ACosh

T testUserSyms

T ACosh(1) == 0
T Cosh(0) == 1
T Cosh(ACosh(1)) == 1
T ACosh(0) == Pi*I/2
T Cosh(Pi*I/2) == 0
T ACosh(1/2) == Pi*I/3

T D(Cosh(x),x) == Sinh(x)
T D(Cosh(x),[x,4]) == Cosh(x)
T Integrate(Cosh(x),x) == Sinh(x)

 ClearAll(x)
T testUserSyms



