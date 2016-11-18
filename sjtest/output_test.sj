# Test printing of expressions
 savestate = CompactOutput(True)

T ToString((-27/64)^(2/3)) == "(9/16)*(-1)^(2/3)"

T ToString( (a+b)*x ) == "(a + b)*x"
T ToString( -2 * a) == "-2a"
T ToString( -2a) == "-2a"
T ToString( -1 * a) == "-a"
T ToString(a - b) == "a - b"
T ToString(a + -3 * b) == "a - 3b"

T ToString((I+1)* a) == "(1 + I)*a"

T ToExpression(ToString(Expand((a-b)^5))) == Expand((a-b)^5)

T ToString( -I ) == "-I"
T ToString(-1 * I) == "-I"
T ToString(-2 * I) == "-2I"
T ToString("1/5 * I") == "1/5 * I"
T ToString( (-1)^n ) == "(-1)^n"
T ToString( -1^n ) == "-1^n"
# FIXME
T If(BigIntInput(), True, ToString( - 1.0 * I ) == "-0.0 + -1.0I")
#T ToString( - 1.0 * I ) == "-0.0 + -1.0I"
T ToString(-I * a) == "-I*a"

T ToString(Infinity) == "Infinity"
T ToString(-Infinity) == "-Infinity"
T ToString(1/0) == "ComplexInfinity"
T ToString(0/0) == "Indeterminate"

### HoldForm

f(x_) := HoldForm(x^2)
T ToString(Sum(f(i), [i,1,10])) == "1^2 + 2^2 + 3^2 + 4^2 + 5^2 + 6^2 + 7^2 + 8^2 + 9^2 + 10^2"
T Map(ReleaseHold, Sum(f(i), [i,1,10])) == 385

### Compound head

T ToString((f+g)(x)) == "(f + g)(x)"

CompactOutput(savestate)

ClearAll(a,b,x,savestate,f,x,ex,n)
