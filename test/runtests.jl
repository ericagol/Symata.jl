using Symata
using Base.Test

import Base.Test: @test

@Symata.sym TimeOff()   # don't print hundreds of diagnostic lines

# For debugging
#@Symata.ex VersionInfo()

function runtests()
    eval(parse("@sym Tests()"))
end

include("juliainterface_test.jl")
@test (runtests() ; true)
