VERSION >= v"0.4.0-dev+6521" && __precompile__()

module Symata

using Compat  # only used in code copied from REPL_symata.jl
import Compat.String

import Base: /, *, +, -, ^, setindex!, getindex, replace
export @ex, @testex, symval, symname, @aex, meval, doeval, infseval

# For IJulia
export isymata, insymata

# For development
export sympy, pytypeof, mxpr, canonexpr!

include("sjcompat.jl")
include("early_kernelstate.jl")
include("mxpr_util.jl")
include("mxpr_type.jl")
include("exceptions.jl")
include("level_specification.jl")
include("sjiterator.jl")
include("sortpattern.jl")
include("julia_level_math.jl")
include("AST_translation_tables.jl")
include("julia_level.jl")
include("arithmetic.jl")
include("apprules_core.jl")
include("symataconstants.jl")
include("namedparts.jl")
include("AST_translation.jl")
include("alteval.jl")
include("doc.jl")
include("misc_doc.jl")
include("symbols.jl")
include("apprules.jl")
include("kernelstate.jl")
include("evaluation.jl")
include("comparison_logic.jl")
include("test.jl")
include("wrapout.jl")
include("IO.jl")
include("predicates.jl")
include("symata_julia_interface.jl")
include("measurements.jl")
include("flowcontrol.jl")
include("output.jl")
include("latex.jl")
include("pattern.jl")
include("parts.jl")
include("lists.jl")
include("expressions.jl")
include("expanda.jl")
include("flatten.jl")
include("sortorderless.jl")
include("module.jl")
include("strings.jl")
include("wrappers.jl")
include("sympy.jl")
include("math_functions.jl")
include("sympy_application.jl")
include("matrix.jl")
include("protected_symbols.jl")
include("REPL_symata.jl")
include("client_symata.jl")
include("isymata.jl")
include("plot.jl")

function __init__()
    have_ijulia = isdefined(Main, :IJulia)
    init_sympy()
    if ! isdefined(Base.Test, :testset_forloop)
        eval(Main, :(macro testset(expr) end ))   # Compatibility for versions more recent than around 0.5 from May 2016
    end
    Main.eval( :( using Symata ))
    sjimportall(:System, :Main)
    set_current_context(:Main)
    if (! have_ijulia) && isinteractive()
        if isdefined(Base, :active_repl)
            RunSymataREPL(Base.active_repl)
        else
            Symata_start()
            exit()
        end
    else
        nothing
    end
end

end # module Symata

nothing
