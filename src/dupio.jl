function stprint(io::IO, x)
    lock(io)
    try
        stshow(io, x)
    finally
        unlock(io)
    end
    return nothing
end

function stprint(io::IO, xs...)
    lock(io)
    try
        for x in xs
            stprint(io, x)
        end
    finally
        unlock(io)
    end
    return nothing
end

stprintln(io::IO, xs...) = stprint(io, xs..., '\n')
stprint(xs...)   = stprint(STDOUT::IO, xs...)
stprintln(xs...) = stprintln(STDOUT::IO, xs...)
stprint(io::IO, c::Char) = (write(io, c); nothing)
stprint(io::IO, s::AbstractString) = (write(io, s); nothing)


function stprint_to_string(xs...; env=nothing)
    # specialized for performance reasons
    s = IOBuffer(Array{UInt8}(Base.tostr_sizehint(xs[1])), true, true)
    # specialized version of truncate(s,0)
    s.size = 0
    s.ptr = 1
    if env !== nothing
        env_io = IOContext(s, env)
        for x in xs
            stprint(env_io, x)
        end
    else
        for x in xs
            stprint(s, x)
        end
    end
    String(resize!(s.data, s.size))
end

ststring_with_env(env, xs...) = stprint_to_string(xs...; env=env)
ststring(xs...) = stprint_to_string(xs...)
