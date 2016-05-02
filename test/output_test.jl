# Test printing of expressions

@testex testUserSyms
@ex savestate = CompactOutput(True)

@testex ToString( (a+b)*x ) == "(a + b)*x"
@testex ToString( -2 * a) == "-2*a"
@testex ToString( -1 * a) == "-a"
@testex ToString(-1 * I) == "-I"
@testex ToString(-2 * I) == "-2I"


@ex CompactOutput(savestate)
@ex ClearAll(a,b,x,savestate)
@testex testUserSyms
