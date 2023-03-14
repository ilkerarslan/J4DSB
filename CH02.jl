p = 3.14
typeof(p)
p = "some text"
typeof(p)
x, y, z = 10, 15, 20;
x = 10; y = 15; z = 20;
x, y = y, z;
α = 6;
β = 7;
α * β

subtypes(Any)
supertype(Number)
subtypes(Number)
subtypes(Complex)

supertypes(Int32)

Complex <: Number
Int64 <: Complex
Int32 <: Number

abstract type Shape end

struct Rectangle 
    width::Float64
    height::Float64     
end

rectangle1 = Rectangle(4.0,7.0)
rectangle1.width, rectangle1.height

mutable struct NewRectangle 
    width::Float64
    height::Float64     
end

rectangle2 = NewRectangle(10, 30)
rectangle2.width = 20

mutable struct Prism <: Shape
    width::Float64 
    length::Float64
    const height::Float64
end

prism1 = Prism(3.0, 4.0, 5.0)
prism1.width = 3.5
prism1.length = 4.5
prism1.height = 6.0

intstr = Union{Integer, String}
x = 123; y = "123"; z = 3.0;
x::intstr
y::intstr
z::intstr

Integer <: Union{Integer, String, Float64}

struct RectanglePar{T}
    width::T
    height::T 
end

r1 = RectanglePar{Int}(3, 8)
r2 = RectanglePar{Float64}(2.78, 3.14)
r3 = RectanglePar("three", "four")

struct RectangleNum{T <: Real}
    width::T 
    height::T 
end


struct  Rational{T <: Integer} <: Real
    num::T
    den::T
end

struct NewShape{T <:String, P <: Number}
    name::T
    color::T 
    Xcoord::P
    Ycoord::P
end

44 + 15    #A
+(44, 15)    #A
4^3    #A
^(4,3)    #A
15 / 5
/(15, 5)
15 \ 5
sqrt(16)    #B
√16    #B
cbrt(64)    #C
∛64    #C
36 % 10    #D
%(36, 10)    #D
rem(36, 10)    #D
36 ÷ 10
div(36,10)

x = 12; y = 24;
3x + 5y
5(2x + 3y)

a = [1, 2, 3];
b = a;
c = deepcopy(a);
b == a, c == a
b === a, c === a

(9 ≥ 7) && (7 ≥ 4)
9 ≥ 7 ≥ 4
3 ≤ 3 < 9 ≠ 14

0.4 + 0.2
0.6 == 0.4 + 0.2

isapprox(0.6, 0.4+0.2)
0.6 ≈ 0.4 + 0.2
isapprox(0.6, 0.4 + 0.2, atol=0.0005)

a = true; b = false;
!a, !b
a && a, a && b, a || b, b || b  

grade_albert = 100;
grade_marie = 99;
grade_richard = 98;
grade_carl  =95;

["albert", "marie", "richard", "carl"]
[100,       99,     98,         97]

("albert", 100, "marie", 99, "richard", 98, "carl", 97)
("albert" => 100, "marie" => 99, "richard" => 98, "carl" => 97)

tpl1 = (3, "Julia", 2022, 4.12)
typeof(tpl1)

tpl2 = tuple(3, "Julia", 2022, 4.12;)
tpl1 === tpl2

t = (6);
typeof(t)
t = (6,);
typeof(t)

tpl1[1]
tpl1[2]
tpl1[2:3]

tpl = (name="Julia", year=2012, version=1.8);
tpl[1]
tpl.version

mathConsts = (π, ℯ, MathConstants.golden)
p, e, g = mathConsts;

p
e
g


in(2022, tpl1), in("Python", tpl1)
2022 ∈ tpl1
2022 ∉ tpl1

grades = Dict()
grades["albert"] = 100
grades["marie"] = 99
grades["richard"] = 98
grades["carl"] = 95
grades

grades = Dict([("albert", 100),
               ("marie", 99),
               ("richard", 98),
               ("carl", 97)])


grades = Dict("albert" => 100,    
              "marie" => 99,    
              "richard" => 98,  
              "carl" => 97)    

grades[1]    # Error
grades["marie"]

keys(grades)
values(grades)

"albert" ∈ keys(grades)
100 ∈ values(grades)
haskey(grades, "isaac")

get(grades, "albert", "not found")
get(grades, "bertrand", "not found")
get!(grades, "bertrand", 85)

1:10
rng = 1:10
collect(1:10)
sizeof(rng)
sizeof(collect(rng))
rng2 = 1:2:20
rng3 = 20:-2:1
-3:0.1:3;
collect('a':2:'g')

range(start=0, step=2, stop=20)
range(2, length=10)
range(5, stop=20)
range(-3, 3, length=101)
range(1, 30, step=3)
range(stop=20, step=2, length=10)

arr = [3, "Julia", 2022, 4.12]
arrfloat = [2.2, 2.4, 2.6]
arrint = [7, 11, 13]
arrdouble = Float64[3.14, 2.78, 6.5]

arr[1]
arr[end]
arr[1:3]

newarr = arr[:]
arr ≡ newarr

3 ∈ arr
issubset([3, "Julia"], arr)
[3, "Julia"] ⊆ arr

eltype(arr)
length(arr)
push!(arr, "σ")

arr2 = ["Δ", "Θ"];
append!(arr, arr2)

deleteat!(arr, 3)
deleteat!(arr, [1, 3, 5])
pop!(arr)
popfirst!(arr)
insert!(arr, 2, "λ")


[1, 2, 3, 4]
[1 2 3; 4 5 6; 7 8 9; 10 11 12]
[1 2 3 4]

cvec = [ 1, 2, 3, 4]
rvec = [1 2 3 4]
mat = [1 2 3 4; 5 6 7 8; 9 10 11 12]
mat = [1 2 3 4
       5 6 7 8
       9 10 11 12]
cvec = [1; 2; 3]
[1;2 ;; 3;4 ;; 5;6]
[1, 2, 3; 4, 5, 6]    # Error

ndims(cvec)
ndims(mat)
size(cvec)
size(mat)
size(mat, 1)
size(mat, 2)
length(mat)

mat
mat[1:2, 2:4]
mat[2, :]

cvec1 = [1, 2];
cvec2 = [6, 7];
cvec3 = [11, 12];
vcat(cvec1, cvec2, cvec3)
hcat(cvec1, cvec2, cvec3)

rvec1 = [4 5];
rvec2 = [9 10];
rvec3 = [14 15];
vcat(rvec1, rvec2, rvec3)
hcat(rvec1, rvec2, rvec3)

[cvec1; cvec2; cvec3]
[cvec1 cvec2 cvec3]
[cvec1, cvec2, cvec3]

Matrix{Float64}(undef, 2, 3)
Array{Float64}(undef, 2, 3)
Array{Float64}(undef, (2,3))
Array{String, 3}(undef, 3, 4, 2)

vec = [3, 5, 7, 7, 7, 8, 8, 8, 12, 15];
Set(vec)

x1 = [1 2 2 3 3 4 4 4 5 6 7 7 7];
x2 = [3 5 6 6 6 7];
union(x1, x2)
intersect(x1, x2)