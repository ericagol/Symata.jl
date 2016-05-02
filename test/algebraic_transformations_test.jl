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
@ex      p = Expand((x-1)*(x-2)*(x-3)*(x^2 + x + 1))
@testex  p == -6 + 5 * x + -1 * (x ^ 2) + 6 * (x ^ 3) + -5 * (x ^ 4) + x ^ 5
@testex  Factor(p) == (-3 + x) * (-2 + x) * (-1 + x) * (1 + x + x ^ 2)

@ex ClearAll(a,b,c,p,x,y,f)

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


## Simplify

@testex Simplify( Cos(x)^2 + Sin(x)^2) == 1
@testex Simplify( (x + x^2)/(x*Sin(y)^2 + x*Cos(y)^2) ) == 1 + x
@testex Cancel(TrigSimp((x + x^2)/(x*Sin(y)^2 + x*Cos(y)^2))) == 1 + x

## FullSimplify

@testex FullSimplify( -Sqrt(-2*Sqrt(2)+3)+Sqrt(2*Sqrt(2)+3) ) == 2



@ex ClearAll(x,y,z,deep)

@testex testUserSyms
