# Test printing of expressions

@testex testUserSyms

@ex savestate = CompactOutput(True)
@testex ToString( (a+b)*x ) == "(a + b)*x"

@ex CompactOutput(savestate)
@ex ClearAll(a,b,x,savestate)
@testex testUserSyms
