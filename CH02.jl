subtypes(Any)
supertype(Number)
subtypes(Number)
subtypes(Complex)

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

10%3
15%8

a = true; b = false;
!a, !b

a && a, a && b, a || b, b || b  

grade_albert = 100;
grade_marie = 99;
grade_richard = 98;
grade_carl  =95;


["albert", "marie", "richard", "carl"]

mathConsts = (π, ℯ, MathConstants.golden)
p, e, g = mathConsts;

p

e

g

tpl1 = (3, "Julia", 2022, 4.12)

in(2022, tpl1), in("Python", tpl1)

d1 = Dict()
d1["albert"] = 100
d1["marie"] = 99
d1["richard"] = 98
d1["carl"] = 95
d1

grades = Dict("albert" => 100,    
              "marie" => 99,    
              "richard" => 98,  
              "carl" => 97)    

keys(grades)
values(grades)

"albert" ∈ keys(grades)
100 ∈ values(grades)
"isaac" ∈ keys(grades)

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

cvec = [ 1, 2, 3, 4]
rvec = [1 2 3 4]
mat = [1 2 3 4; 5 6 7 8; 9 10 11 12]
mat = [1 2 3 4
       5 6 7 8
       9 10 11 12]
cvec = [1; 2; 3]
[1;2 ;; 3;4 ;; 5;6]
[1, 2, 3; 4, 5, 6]

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

Array{String, 3}(undef, 3, 2, 2)

Array{Union{Integer, Missing}, 4}(missing, 5,4,3,2);

abstract type Shape end

mutable struct Rectangle <: Shape 
    width::Float64  
    height::Float64
end

rectangle1 = Rectangle(10, 30)

rectangle1.width = 20
rectangle1

