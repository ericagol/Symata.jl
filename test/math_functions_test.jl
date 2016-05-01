@ex If( Length(UserSyms()) > 0 ,  Println("\n**********", UserSyms(), "\n"))
@testex Length(UserSyms()) == 0

#### Erf

@testex Erf(0) == 0
@testex Head(Erf(0)) == Int
@testex Erf(DirectedInfinity(I)) == DirectedInfinity(I)

#### Gamma

@testex Chop(Gamma(.5) - 1.772453850905516) == 0
@testex Gamma(1/2) == Pi^(1/2)
@testex Gamma(0) == ComplexInfinity
@testex Chop(Gamma(1,.5) - 0.6065306597126334) == 0
#@testex isapprox(Gamma(.5), 1.772453850905516)  don't know if this is worth the trouble
@testex Gamma(1,2) == E^(-2)
@testex Gamma(a,0) == Gamma(a)

@testex D(Gamma(x),x) == Gamma(x) * (PolyGamma(0,x))

# FIXME.
# Cutting and pasting the output of the Series
# is not equal to the output. The ordering of terms is different.
# No idea why.
@testex Series(Gamma(x), [x, 0, 3])[1] == -EulerGamma


# @testex
# @testex
# @testex
# @testex
# @testex
# @testex
# @testex 

@ex ClearAll(a)
@ex If( Length(UserSyms()) > 0 ,  Println("\n**********", UserSyms(), "\n"))
@testex Length(UserSyms()) == 0
