using SJulia
using Base.Test

import Base.Test: @test

@ex TimeOff()   # don't print hundreds of diagnostic lines

@ex (testUserSyms;
     userSymList;
     userSymList = Map(ToString, UserSyms());
     testUserSyms := If(  userSymList == Map(ToString,UserSyms()) , True,  (Println("**********", UserSyms()); False), (Println("**********", UserSyms()); False)))

#@ex x

@testex testUserSyms
@testex testUserSyms

include("algebraic_transformations_test.jl")
include("sympy_test.jl")
include("up_downvalues_test.jl")
include("math_functions_test.jl")
include("lists_test.jl")
include("trig_test.jl")
include("comparison_test.jl")
include("attributes_test.jl")
include("patterns_test.jl")
include("module_test.jl")
include("io_test.jl")
include("orderless_test.jl")
include("somemath_test.jl")
include("flowcontrol_test.jl")
include("expressions_test.jl")
include("arithmetic_test.jl")
include("spec_fun_test.jl")
include("evaluation_test.jl")
include("simple_expression_test.jl")
include("mxpr_test.jl")


#include("code_in_SJulia_test.jl")  # test slow loading code.
