# Test printing of expressions

@testex testUserSyms

@testex ToString( (a+b)*x ) == "(a + b) * x"

@ex ClearAll(a,b,x)
@testex testUserSyms
