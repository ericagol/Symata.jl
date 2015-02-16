## Symbolic manipulation code

This is a partial, experimental, implementation of a language for
symbolic computation.  It is largely based on pattern matching and an
evaluation sequence modeled on Mathematica, although this by no means
a fixed decision.

The focus now is not on implementing specific mathematical
computation, but rather on testing implmentations of core features and
subsystems that are effcient or can be made efficient. Some important
features are pattern matching and the evaluation sequence and data
structures that support it.

#### Here are some results.

This quickly evaluates an expression and tracks
whether it needs to be re-evaluated.

```julia
sjulia> m = Expand((a+b)^BI(1000));   # expand with BigInt exponent
elapsed time: 0.008785756 seconds

sjulia> m[2]             # get a single value without re-evaluating
elapsed time: 3.7545e-5 seconds (992 bytes allocated)
1000*(a^999)*b

sjulia> a = 1;

sjulia> m[2]           # slower because we re-evaluate everything
elapsed time: 0.075710831
1000*b

sjulia> ClearAll(a)

sjulia> m[2]     # re-evaluate, it is still relatively slow.
elapsed time: 0.040376351 seconds (3723352 bytes allocated)
1000*(a^999)*b

sjulia> m[2]    # no evaluation, expression has been marked as fixed again.
elapsed time: 3.7984e-5 seconds (992 bytes allocated)
tryrule count: downvalue 0, upvalue 0
1000*(a^999)*b

sjulia> m[3]   # we can iterate over m without re-evaluating
elapsed time: 8.2968e-5 seconds (1544 bytes allocated)
499500*(a^998)*(b^2)
```

Quickly generate a large list of numbers and access a value.
```julia
sjulia> a = Range(10^5);
elapsed time: 0.001219758 seconds (2394728 bytes allocated)

sjulia> a[-1]
elapsed time: 3.5242e-5 seconds (976 bytes allocated)
100000

sjulia> a[-1] = d
elapsed time: 3.7307e-5 seconds (816 bytes allocated)
d

sjulia> Apply(Plus,a)
elapsed time: 0.005774109 seconds
4999950000 + d
```

### Installing

You can load and test SJulia like this

```julia
include("src/SJulia.jl")
include("src/run_tests.jl")
```

I added a mode to the Julia repl to support this code (but it is not necessary)
in this branch of a fork of Julia

https://github.com/jlapeyre/julia/tree/jl/symrepl

In fact, the only file changed in this branch is base/REPL.jl.  To use
this mode. Download the branch and build it and install it somewhere
as, say, sjulia. You enter and exit the SJulia mode with '.' Working
from this mode is similar to working from Mathematica or Maxima or
Maple. For the most part, the SJulia mode just wraps input in the macro
`ex`. So you can get the same thing by typing

```julia
julia> @ex some SJulia expression
julia> @ex(some expression that may look like two expressions)
```

### Finding Help and Examples

Symbols that are associated with some functionality can be listed with
`BuiltIns()` at the sjulia prompt, or `@ex BuiltIns()` at the julia
prompt.

Documentation for for many BuiltIn symbols is reproduced at the end of
this document.

This documentation can be printed from within SJulia
by entering `?, SymName` at the `sjulia` prompt. Note the comma, which
is neccessary because limitations in the provisional parsing method.
`Help(Symname)` prints the same documentation. This allows you to type
`@ex Help(SymName)` from Julia.

To print a list of all help topics, type `?,` or `Help()`.

If examples are printed with the documentation string, they can be
evaluated, that is run, by entering `Example(SymName)` at the `sjulia`
prompt. The input strings from the examples are pushed to the history
so that they can be recalled and edited and re-evaluated.

There are many examples in the test directory.

### A few examples

Here are some examples of the SJulia mode.

```julia
sjulia> ClearAll(fib)
sjulia> fib(1) := 1
sjulia> fib(2) := 1
sjulia> fib(n_) := fib(n-1) + fib(n-2)
sjulia> fib(10)
55
sjulia> addone(x_) := (a = 1,  x + a)  # compound expression
sjulia> addone(y)
1 + y
sjulia> g(x_) := Module([a,b],(a=1,b=3,a+b+x))  # lexically scoped local vars
sjulia> gt5(x_) := x > 5     # conditions on patterns
sjulia> g(x_FloatingPoint:?(gt5)) = 1   # only matches floating point numbers > 5
sjulia> h(x_^2) := x    # Structural matching
sjulia> h((a+b)^2)
a + b
```

Using the SJulia mode or the `@ex` macro is essentially using a language distinct
from Julia. In particular, the evaluation sequence, and binding of symbols to
storage is separate from Julia. But there is also some work done on allowing
use of SJulia direclty from Julia. For instance, these

```julia
julia> ex = :x + 1
1 + x
julia> m = Expand((:a+:b)*(:x+1)^2)
a + b + 2*a*x + 2*b*x + a*(x^2) + b*(x^2)
````

make Julia bindings of SJulia expressions to the symbols ex and m.

Here are a few commands (at the sjulia repl, or as a argument to the @ex macro).
There are many more commands available, mostly to support experimenting with
design of SJulia.

* `SetJ(x,val)` set a Julia variable
* `Clear(), ClearAll()` clear a symbol's value, or all associated rules, too.
* `DownValues(x)` rules associated with x
* `Attributes(x)` attributes of symbol x
* `Dump(x)`
* `Cos(x)`
* `Length(x)`
* `TraceOn()`
* `TraceOff()`
* `Replace(expr,rule)`
* `ReplaceAll(expr,rule)`
* `a = b` assignment
* `a := b` delayed assignment
* `f(x_) := x` delayed rule assignment

There are also two older experiments in this distribution. Each one
has test files that run and serve as examples. The instructions for
loading the code and running the tests, are in the subdirs.

#### Evaluation

There are lines at the top of the file `src/mxpr.jl` to control evaluation. You can
choose infinite or single evaluation. The test suite relies on infinite evaluation being
enabled. Hashing and caching of expressions can also be chosen here, but it is not very
useful at the moment.

#### Pattern matching.

Patterns are used in several places. Eg, you can make a replacement rule. Eg

```julia
sjulia> cossinrule = Cos(x_)^2 + Sin(x_)^2 => 1;

sjulia> Replace( Cos(a+b)^2 + Sin(a+c)^2, cossinrule)
(a+b)^2 + Sin(a+c)^2

sjulia> Replace( Cos(a+b)^2 + Sin(a+b)^2, cossinrule)
1
```

A replacement rule is associated with the symbol `f` like this

```julia
sjulia> f(x_) := x^2

sjulia> f(a+b)
(a+b)^2
```

When `f` is encountered as the head of an expression, a list of such rules is
tried. The first that succeeds makes the transformation and that round of evaluation
is done. You should also be able to  associate automatic rules with `f` like this
`g(f(x_)) ^= x^2`. But, this is not done yet.

You can see the evaluation sequence in `infseval` and `meval` in the code.

#### Parsing

I use the Julia parser and reinterpret the results. Maybe there is an elegant enough
way to get everything you need this way. But, probably copying and altering the
parser would be better even though it adds more complication. Eg. Now, I can use curly
braces for literal construction of lists, but get a deprecation warning. So I use
square brackets. Once you change the parser, you can ask whether you want full Mma
syntax. OTOH, staying close to Julia (and everyone else's) syntax is also reasonable.
OTOOH, Julia tries to make it easy to come from matlab. So making it easy to
come from Mma might be good (if this ultimately will look like Mma).

#### Data and dispatch

Big question: how to use best Julia features, (multiple dispatch, and
others) with this language ? There are of course numerous other
questions.  Eg, how to handle integer overflow.

Another thing, Mma offers no way to write code except in Mma. It
should be possible to write user or quasi-user level code easily in
Julia.

Symbols are currently done this way (this is a bit outdated)

```julia
type SSJSym{T}  <: AbstractSJSym
    val::Array{T,1}
    attr::Dict{Symbol,Bool}    # attributes associated with the symbol
    downvalues::Array{Any,1}  # These are transformation rules for the symbol
    age::UInt64             # Time stamp, last time assignment or other changes were made
end
```

Of course the attributes should probably be a bit field, or stored somewhere
else. The downvalues field is a list of definitions like `f(x_) := x`. I am not
yet using the symbol subtype (parameter) for dispatch.

Expressions are done like this

```julia
type Mxpr{T} <: AbstractMxpr
    head::SJSym
    args::MxprArgs
    fixed::Bool    # Does Mxpr evaluate to itself in current environment ?
    canon::Bool    # Is Mxpr in canonical form ?
    syms::FreeSyms # List of free symbols, whose timestamps we check
    age::UInt64    # Timestamp of this Mxpr
    key::UInt64    # Hash code
    typ::DataType  # Not used
end
```

At the moment, the field `head` and the parameter T are the same. Evaluation of
expressions is dispatched by functions with type annotations for each head, such
as `Mxpr{:Power}`.

### Documented Symbols and Commands

##### Abs

Abs(z) represents the absolute value of z.



##### All

All is a symbol used in options.



##### Allocated

Allocated(expr) evaluates expr and returns a list of the memory allocated
and the result of the evaluation.

See also TimeOff, TimeOn, Timing, TrDownOff, TrDownOn, TrUpOff, and TrUpOn.


##### Apply

Apply(f,expr) replaces the Head of expr with f. This also works for some
Julia objects. Eg. Apply(Plus, :( [1:10] )) returns 55.



##### AtomQ

AtomQ(expr), in principle, returns true if expr has no parts accesible with Part.
However, currently, Julia Arrays can be accessed with Part, and return true under AtomQ.

See also EvenQ and OddQ.


##### Attributes

Attributes(s) returns attributes associated with symbol s. Builtin symbols have
the attribute Protected, and may have others.



##### BF

BF(n) converts the number, or string n to a BigFloat. SJulia currently neither
detects overflow, nor automatically promotes types from fixed to arbitrary precision.

See also BI.


##### BI

BI(n) converts the number n to a BigInt. SJulia currently neither
detects integer overflow, nor automatically promote integers to BigInts.

See also BF.


##### BuiltIns

BuiltIns() returns a List of all "builtin" symbols. These are in fact all symbols that
have the Protected attribute.



##### ByteCount

ByteCount(expr) gives number of bytes in expr. Not everything is counted
correctly at the moment.



##### Clear

Clear(x,y,z) removes the values associated with x,y,z. It does not remove
their DownValues.

See also ClearAll.


##### ClearAll

ClearAll(x,y,z) removes all values and DownValues associated with x,y,z. The
symbols are removed from the symbol table and will not appear in the list returned
by UserSyms().

See also Clear.


##### Comparison

Comparison(expr1,c1,expr2,c2,expr3,...) performs or represents a
chain of comparisons. Comparison expressions are usually input and
displayed using infix notation.


Examples

```
sjulia> Clear(a,b,c)

sjulia> a == a
true

sjulia> a == b
false

sjulia> a < b <= c
a < b <= c

sjulia> (a=1,b=2,c=2)
2

sjulia> a < b <= c
true
```


##### CompoundExpression

CompoundExpression(expr1,expr2,...) or (expr1,expr2,...) evaluates each expression in turn and
returns the result of only the final evaluation.



##### Depth

Depth(expr) gives the maximum number of indicies required to specify
any part of expr, plus 1.



##### DirtyQ

DirtyQ(m) returns true if the timestamp of any symbol that m depends on
is more recent than the timestamp of m. This is for diagnostics.

See also Age, Fixed, HAge, Syms, and Unfix.


##### Do

Do(expr,[imax]) evaluates expr imax times.
Do(expr,[i,imax]) evaluates expr imax times with i localized taking values from 1 through
  imax in increments of 1.
Do(expr,[i,imin,imax]) evaluates expr with i taking values from imin to imax with increment 1.
  imin and imax may be symbolic.
Do(expr,[i,imin,imax,di]) evaluates expr with i taking values from imin to imax with increment di.
  imin, imax, and di may be symbolic.
Do(expr,[i,[i1,i2,...]) evaluates expr with i taking values from a list.



##### DownValues

DownValues(s) returns a List of DownValues associated with symbol s. These are values
that are typically set with the declarative "function definition".

See also Set, SetDelayed, UpSet, and UpValues.

Examples

```
sjulia> ClearAll(f)

sjulia> f(x_) := x^2

sjulia> DownValues(f)
[HoldPattern(f(x_))->(x^2)]
```

##### Dump

Dump(expr) prints an internal representation of expr. This is similar to
Julia `dump'.

See also DumpHold.


##### DumpHold

DumpHold(expr) prints an internal representation of expr. This is similar to
Julia `dump'. In constrast to `Dump', expr is not evaluated before it's internal
representation is printed.

See also Dump.


##### E

E is the base of the natural logarithm



##### EvenQ

EvenQ(expr) returns true if expr is an even integer.

See also AtomQ and OddQ.


##### Example

Example(s) runs (evaluates) the first example for the symbol s, which is typically
a BuiltIn symbol. The input, output, and comments are displayed. The input strings
for the example are pushed onto the terminal history so they can be retrieved and 
edited and re-evaluated. Example(s,n) runs the nth example for symbol s. When viewing
documentation strings via ? SomeHead, the examples are printed along with the
documentation string, but are not evaluated.



##### ExpToTrig

ExpToTrig(expr) replaces exponentials with trigonometric functions in expr.
But, the transformation from Cosh to Cos is not implemented.



##### Expand

Expand(expr) expands products in expr. This is only partially implemented,
mostly to test the efficiency of evaluation and evaluation control.



##### FactorInteger

FactorInteger(n) gives a list of prime factors of n and their multiplicities.



##### Fixed

Fixed(expr) returns the status of the fixed point bit, which tells whether expr
is expected to evaluate to itself in the current environment. This is partially
implemented.

See also Age, DirtyQ, HAge, Syms, and Unfix.


##### For

For(start,test,incr,body) is a for loop. Eg. For(i=1,i<=3, i = i + 1 , Println(i))



##### FullForm

FullForm(expr) prints expr and all sub-expressions as
Head(arg1,arg2,...). Normal output may use infix notation instead.


Examples

```
sjulia> Clear(a,b)

sjulia> a+b
a+b

sjulia> FullForm(a+b)
Plus(a,b)
```


##### HAge

HAge(s) returns the timestamp for the expression or symbol s.
Using this timestamp to avoid unnecessary evaluation is a partially
implemented feature.

See also Age, DirtyQ, Fixed, Syms, and Unfix.


##### Head

Head(expr) returns the head of expr, which may be an SJulia expression or object of any
Julia type. The head of a Julia expression is Expr, eg.
Head( :( :( a = 1) )) returns Expr. Note we have to quote twice, because one level of
a quoted Julia expression is evaluated so that we can embed Julia code.



##### Help

Help(sym) prints documentation for the symbol sym. Eg: Help(Expand).
Help(All -> true) prints all of the documentation.



##### I

I is the imaginary unit



##### If

If(test,tbranch,fbranch) evaluates test and if the result is true, evaluates tbranch, otherwise fbranch



##### JVar

JVar(x) returns the Julia value of the Symbol that x evaluates to. For example,
if a = 1 in Julia and b = a in SJulia, then JVar(b) evaluates to 1.

See also Jxpr.


##### Jxpr

Jxpr allows embedding Julia expressions.
A Jxpr is entered like this :( expr ) . expr is interpreted as a Julia expression and
it is wrapped expression with head Jxpr, which is then evaluated when
Jxpr is evaluated. You never see the head Jxpr. For example
 m = :( [1:10] )  creates a Julia array and binds it to the SJulia symbol m

See also JVar.

Examples

```
This creates a Julia Array{Int,1} and "binds" it to the SJulia symbol m.
sjulia> m = :( [1:3] )
3-element Array{Int64,1}:
 1
 2
 3
```


##### Keys

Keys(d) returns a list of the keys in Dict d



##### LeafCount

LeafCount(expr) gives the number of indivisible (Part can't be taken) elements in expr.
This amounts to counting all the Heads and all of the arguments that are not of type Mxpr.



##### Length

Length(expr) prints the length of SJulia expressions and Julia objects. For
SJulia expressions, the length is the number or arguments. For scalar Julia
types, the length is zero. For Array's and Dict's the length is the same as
Julia `length'.



##### Log

Log(x) gives the natural logarithm of x.



##### MatchQ

MatchQ(expr,pattern) returns true if expr matches pattern.


Examples

```
sjulia> MatchQ( 1, _Integer)
true

sjulia> ClearAll(gg,xx,b)

sjulia> MatchQ( gg(xx) , _gg)
true

sjulia> MatchQ( b^2, _^2)
true
```


##### Module

Module creates a lexical scope block for variables. Warning, this is broken
in the sense that nested calls to a Module are not supported.


Examples

```
sjulia> ClearAll(f,a)

sjulia> f(x_) := Module([a],(a=1, a+x))

sjulia> f(3)
4

sjulia> a
a
```


##### OddQ

OddQ(expr) returns true if expr is an odd integer.

See also AtomQ and EvenQ.


##### Pack

Pack(mx) packs the args of the SJulia expression mx into a typed Julia array.
The type of the array is the same as the first element in mx.

See also Unpack.

Examples

```
This returns a Julia array of element type Int [1,2,3].
sjulia> ClearAll(f)

sjulia> Pack(f(1,2,3))
3-element Array{Int64,1}: [1,2,3]
```


##### Part

Part(expr,n) or expr[n], returns the nth element of expression expr.
Part(expr,n1,n2,...) or expr[n1,n2,...] returns a nested part.
The same can be acheived less efficiently with expr[n1][n2]...
expr[n] = val sets the nth part of expr to val. n and val are evaluated
normally. expr is evaluated once.
expr[n] also returns the nth element of instances of several
Julia types such as Array and Dict.



##### Permutations

Permutations(expr) give a list of all permuations of elements in expr.



##### Pi

Pi is the trigonometric constant π.



##### Println

Println(expr1,expr2,...) prints the expressions and a newline.



##### Range

Range(n) returns the List of integers from 1 through n.
Range(n1,n2) returns the List of numbers from n1 through n2.
Range(n1,n2,di) returns the List of numbers from n1 through n2 in steps of di
di may be negative. Floats and some symbolic arguments are supported.
You can get also get SJulia lists like using Unpack(:([1.0:10^5])).
This uses emebedded Julia to create a typed Array and then unpacks it to a List.



##### Replace

Replace(expr,rule) replaces parts in expr according to Rule rule.

See also ReplaceAll.

Examples

```
sjulia> Clear(a,b,c)

# This expression does not match the pattern.
sjulia> Replace( Cos(a+b)^2 + Sin(a+c)^2, Cos(x_)^2 + Sin(x_)^2 => 1)
Cos(a + b)^2 + Sin(a + c)^2

# This expression does match the pattern.
sjulia> Replace( Cos(a+b)^2 + Sin(a+b)^2, Cos(x_)^2 + Sin(x_)^2 => 1)
1
```


##### ReplaceAll

ReplaceAll(expr,rule) replaces parts at all levels in expr according to Rule rule.

See also Replace.


##### Reverse

Reverse(expr) reverses the order of the arguments in expr.    



##### Set

Set(a,b), a = b
Sets the value of a to b. b is evaluated only once, when `a=b' is evaluated.
obj[i,j,...] = val sets a part of obj to val. obj can be an SJulia expression
or a Julia object, such as an Array or Dict.

See also DownValues, SetDelayed, UpSet, and UpValues.

Examples

```
sjulia> Clear(a,b,c)

sjulia> b = a
a

sjulia> a = 1
1

sjulia> c = a
1

sjulia> a = 2
2

sjulia> b
2

sjulia> c
1
```


##### SetDelayed

SetDelayed(a,b), a := b
Whenever a is evaluated, b is evaluated and the result is assigned to a.
So a is not set to the value of b at the time a := b is evaluated, but
rather to the current value of b every time a is evaluated.

See also DownValues, Set, UpSet, and UpValues.


##### SetJ

SetJ(x,val) sets the Julia symbol x to val. Variables and functions in SJulia
are separate from those in Julia, ie, their table of bindings to symbols are separate.



##### StringLength

StringLength(s) returns the length of the string s.



##### Symbol

Symbol(str) converts the string str to a symbol. For example if a is 1,
then Symbol("a") returns 1.



##### Syms

Syms(m) returns a List of the symbols that the expression m 'depends' on. The
list is wrapped in HoldForm in order to prevent evaluation of the symbols.

See also Age, DirtyQ, Fixed, HAge, and Unfix.


##### Table

Table(expr,[i,imax]) returns a list of expr evaluated imax times with
i set successively to 1 through imax. Other Table features are not implemented.



##### TimeOff

TimeOff() disables printing CPU time consumed and memory allocated
after each evaluation of command line input.

See also Allocated, TimeOn, Timing, TrDownOff, TrDownOn, TrUpOff, and TrUpOn.


##### TimeOn

TimeOn() enables printing CPU time consumed and memory allocated
after each evaluation of command line input.

See also Allocated, TimeOff, Timing, TrDownOff, TrDownOn, TrUpOff, and TrUpOn.


##### Timing

Timing(expr) evaluates expr and returns a list of the elapsed CPU time
and the result.

See also Allocated, TimeOff, TimeOn, TrDownOff, TrDownOn, TrUpOff, and TrUpOn.


##### TrDownOff

TrDownOff() disables tracing attempted application of DownRule.

See also Allocated, TimeOff, TimeOn, Timing, TrDownOn, TrUpOff, and TrUpOn.


##### TrDownOn

TrDownOn() enables tracing attempted application of DownRule.

See also Allocated, TimeOff, TimeOn, Timing, TrDownOff, TrUpOff, and TrUpOn.


##### TrUpOff

TrUpOff() disables tracing attempted application of UpRule.

See also Allocated, TimeOff, TimeOn, Timing, TrDownOff, TrDownOn, and TrUpOn.


##### TrUpOn

TrUpOn() enables tracing attempted application of UpRule.

See also Allocated, TimeOff, TimeOn, Timing, TrDownOff, TrDownOn, and TrUpOff.


##### TraceOff

TraceOff() turns off the tracing of SJulia evaluation.

See also TraceOn.


##### TraceOn

TraceOn() turns on the tracing of SJulia evaluation.

See also TraceOff.


##### Unfix

Unfix(expr) unsets the fixed flag on expr, causing it to be evaluated.
This is a workaround for bugs that cause an expression to be marked fixed
before it is completely evaluated.

See also Age, DirtyQ, Fixed, HAge, and Syms.


##### Unpack

Unpack(a) unpacks a Julia typed array into an SJulia List expression.
Only 1-d is supported. If a is a Julia Dict, then a list of lists of
key,value pairs is returned.

See also Pack.

Examples

```
This creates a List of three random Float64's.
sjulia> Unpack( :(rand(3)) )
[0.5548766917324894,0.034964001133465095,0.9122052258982192]
```


##### Unprotect

Unprotect(z1,z2,...) removes the Protected attribute from the symbols z1, z2, ...



##### UpSet

UpSet(a(g(x_)),b), or a(g(x_)) ^= b  associates the transformation rule with g.

See also DownValues, Set, SetDelayed, and UpValues.


##### UpValues

UpValues(s) returns a List of UpValues associated with symbol s. These are values
that are typically set with UpSet.

See also DownValues, Set, SetDelayed, and UpSet.


##### UserSyms

UserSyms() returns a List of non-Protected symbols, which is approximately
all user defined symbols.



##### While

While(test,body) evaluates test then body in a loop until test does not return true.


<!--  LocalWords:  julia src sjulia repl ClearAll SetJ DownValues jl
 -->
<!--  LocalWords:  TraceOn TraceOff expr ReplaceAll subdirs symrepl
 -->
<!--  LocalWords:  newrepl wrappermacro premxprcode Mathematica Eg
 -->
<!--  LocalWords:  matcher replaceall Mxpr oldmxpr SJSym SJulia meval
 -->
<!--  LocalWords:  canonicalizer Orderless cossinrule  Mma
 -->
<!--  LocalWords:  Fateman IIRC OTOOH else's matlab AbstractSJSym
 -->
<!--  LocalWords:  Bool symname sjsym downvalues subtype AbstractMxpr
 -->
<!--  LocalWords:  RuleDelayed addone lexically FloatingPoint
 -->
<!--  LocalWords:  BuiltIns
 -->
