@testex testUserSyms

#### Cancel

@testex Cancel( (2*x^2-2)/(x^2-2*x+1)) == (-1 + x) ^ (-1) * (2 + 2 * x)

#### Collect

@testex  Args(Collect(a*x^2 + b*x^2 + a*x - b*x + c, x)) == [c,(a + -b) * x,(a + b) * (x ^ 2)]
@testex  Args(Collect(x^2 + y*x^2 + x*y + y + a*y, [x, y])) == [x * y,(1 + a) * y,(x ^ 2) * (1 + y)]
@testex  Collect(a*Sin(2*x) + b*Sin(2*x), Sin(2*x)) == (a + b) * Sin(2 * x)
@testex  Collect(a*x*Log(x) + b*(x*Log(x)), x*Log(x)) == (a + b) * x * Log(x)
@testex  Collect(a*x^c + b*x^c, x) == a*(x^c) + b*(x^c)
@testex  Collect(a*x^c + b*x^c, x^c) == (a + b)*(x^c)

@testex Collect(a*x + b*y + c*x, x) == (a + c) * x + b * y
@testex Collect(a*x^(2*c) + b*x^(2*c), x^c) == (a + b)*(x^(2*c))
@testex Collect(a*Exp(2*x) + b*Exp(2*x), Exp(x)) == (a + b)*(E^(2*x))

# sympy does not do this unless we use Expand. Mma does the expansion
@testex Collect(Expand((1+a+x)^4), x) == 1 + 4*a + 6*(a^2) + 4*(a^3) + a^4 + (4 + 12*a + 12*(a^2) + 4*(a^3))*x + (6 + 12*a + 6*(a^2))*(x^2) + (4 + 4*a)*(x^3) + x^4

# This differs from sympy. We can't quite do Derivative(1)f yet
@testex Collect( a*D(f(x),x) + b*D(f(x),x), D(f(x),x))  == (D(f(x),x))*(a + b)

#### Factor, Expand

@testex  Factor(Expand( (a+b)^2 )) == (a+b)^2
@testex  Expand( (a + f(x)) ^2 ) == a ^ 2 + 2 * a * f(x) + f(x) ^ 2
@testex  Expand(  (x+y+z)^2 ) == x^2 + 2*x*y + y^2 + 2*x*z + 2*y*z + z^2
@testex  Expand( Exp(x+y) ) == (E^x)*(E^y)


@ex      p = Expand((x-1)*(x-2)*(x-3)*(x^2 + x + 1))
@testex  p == -6 + 5 * x + -1 * (x ^ 2) + 6 * (x ^ 3) + -5 * (x ^ 4) + x ^ 5

@testex  Factor(p) == (-3 + x) * (-2 + x) * (-1 + x) * (1 + x + x ^ 2)
@testex  Factor(2*x^5 + 2*x^4*y + 4*x^3 + 4*x^2*y + 2*x + 2*y) == 2*((1 + x^2)^2)*(x + y)
@testex  Factor(x^2 + 1, modulus => 2) == (1 + x)^2
@testex  Factor(x^10 - 1, modulus => 2) == ((1 + x)^2)*((1 + x + x^2 + x^3 + x^4)^2)
@testex  Factor(x^2 + 1, gaussian => True) == (-1I + x)*(I + x)
# @testex  Factor(x^2 - 2, extension => Sqrt(2))  FIXME. raises exception
@testex  Factor((x^2 + 4*x + 4)^10000000*(x^2 + 1)) == ((2 + x)^20000000)*(1 + x^2)
@testex  Factor( 2^(x^2 + 2*x + 1), deep => True ) == 2^((1 + x)^2)

@ex ClearAll(a,b,c,p,x,y,f)

#### ExpandFunc

@testex  ExpandFunc(Gamma(x+2)) == x*Gamma(x)*(1 + x)
@testex  Simplify(x*Gamma(x)*(1 + x)) == Gamma(x+2)
# FIXME  Canononical order should be  x*(1+x)*Gamma(x).  We get x*Gamma(x)*(1+x)


#### Together, Apart

# Note, Mma and others have this FullForm, but display a 1/(x*y), etc.
@ex     z = ( 1/x + 1/(x+1))
@testex Together(z) == (x ^ -1) * ((1 + x) ^ -1) * (1 + 2 * x)
@testex Apart(Together(z)) == z
@ex     ClearAll(z)
@testex Together(1/x + 1/y + 1/z) == (x^(-1))*(y^(-1))*(z^(-1))*(x*y + x*z + y*z)
@testex Together(1/(x*y) + 1/y^2) == (x^(-1))*(y^(-2))*(x + y)
@testex Together(1/(1 + 1/x) + 1/(1 + 1/y)) == ((1 + x)^(-1))*((1 + y)^(-1))*(x*(1 + y) + (1 + x)*y)
@testex Together(1/Exp(x) + 1/(x*Exp(x))) == (E^(-x))*(x^(-1))*(1 + x)
@testex Together(1/Exp(2*x) + 1/(x*Exp(3*x))) == (E^((-3)*x))*(x^(-1))*(1 + (E^x)*x)

@testex Together(Exp(1/x + 1/y), deep => True) == E^((x^(-1))*(y^(-1))*(x + y))
@testex Together(Exp(1/x + 1/y)) == E^(x^(-1) + y^(-1))
@testex Factor((x^2 - 1)/(x^2 + 4*x + 4)) == (-1 + x)*(1 + x)*((2 + x)^(-2))

#### TrigSimp

@testex TrigSimp(2*Sin(x)^2 + 2* Cos(x)^2) == 2
@testex TrigSimp(f(2*Sin(x)^2 + 2* Cos(x)^2)) == f(2)
@testex TrigSimp( 3*Tanh(x)^7 - 2/Coth(x)^7) == Tanh(x)^7

#### Simplify

@testex Simplify( Cos(x)^2 + Sin(x)^2) == 1
@testex Simplify( (x + x^2)/(x*Sin(y)^2 + x*Cos(y)^2) ) == 1 + x
@testex Cancel(TrigSimp((x + x^2)/(x*Sin(y)^2 + x*Cos(y)^2))) == 1 + x

#### FullSimplify

@testex FullSimplify( -Sqrt(-2*Sqrt(2)+3)+Sqrt(2*Sqrt(2)+3) ) == 2


@ex ClearAll(x,y,z,f,deep,gaussian,modulus)

@testex testUserSyms
