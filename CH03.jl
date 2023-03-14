begin
    w = 9
    l = 12
    h = 5
    volume = w * l * h
    area = 2(w*l + w*h + l*h)
    println("Volume = $volume and Area = $area")
end

(w = 10; l = 15; h = 20; 
 v = w*l*h; 
 a = 2(w*h + h*l + w*l);
 println("Volume = $v and Area = $a"))

score = 70
if score > 60 
   println("passed")
end

if score > 60 
    println("Congratulations, you passed!")
else
    println("I am sorry. You failed.")
end

score = 45
if score ≥ 85
    println("Your grade is A")
else
    if score ≥ 70
        println("Your grade is B")
    else
        if score ≥ 60
            println("Your grade is C")
        else
            println("Your score is F")
        end
    end
end

if score ≥ 85
    println("Your grade is A")
elseif score ≥ 70
    println("Your grade is B")
elseif score ≥ 60
    println("Your grade is C")
else 
    println("Your score is F")
end

println("Enter your score: ")
score = readline();
score = parse(Int64, score)

if 85 ≤ score ≤ 100
    println("Your grade is A")
elseif 70 ≤ score < 85
    println("Your grade is B")
elseif 60 ≤ score <70
    println("Your grade is C")
elseif 0 ≤ score < 60 
    println("Your score is F")
else
    println("You haven't entered a valid score")
end

score = 78;
score > 50 ? "passed" : "failed"
score > 85 ? "Grade: A" : score > 60 ? "Grade: B" : "Grade C"

age = 45
(age > 0) && (println("Your age is $age."))
(age < 0) || (println("Enter a positive number"))
age = "twenty"
notInteger = !(typeof(age) <: Integer);
notInteger && println("Please enter a numeric input!")

for i in 1:4
    println("Square of $i is $(i^2)")
end

arr = rand(5:25, 4);
for (index, value) ∈ enumerate(arr)
    println("The $(index). element is $(value)")
end

mat = rand(10:99, (3,2))

for row in 1:size(mat,1)
    for col in 1:size(mat,2)
        println("Row: $row, Col: $col, Value: $(mat[row, col])")
    end
end

for r in 1:size(mat, 1), c in 1:size(mat,2)
    println("Row: $r, Col: $c, Value: $(mat[r,c])")
end

names = ["Albert", "Marie", "Isaac", "Rosalind", "Richard"];
surnames = ["Einstein", "Curie", "Newton", "Franklin", "Feynman"];
birthyears = [1879, 1867, 1643, 1920, 1918];

for (name, surname, byear) in zip(names, surnames, birthyears)
    println((name, surname, byear))
end

d = Dict("a" => 10, "b" => 20, "c" => 30)

for (k, v) in d 
    println("Key: $k, Value: $v")
end

i = 1

while i < 5
    println(i^2)
    i += 1
end

arr = [3, 5, 7, 9, 11, 13, 15];

while !isempty(arr)
    print(pop!(arr), " ")
end

begin
    input = nothing
    arr = []

    while input != 0
        print("Enter a number (0 to exit): ")
        global input = parse(Int, readline())
        append!(arr, input)
    end

    println("Sum of the numbers you entered: ", sum(arr))
end

arr = [3, 5, 7, 9, 42, 999, 11, 13, 15, 999, 44];
for el ∈ arr
    if el == 999
        println("Break condition is met!")
        break
    end
    println(el)
end

i = 1
while i <= length(arr)
    if arr[i] == 999
        println("Break condition is met!")
        break
    end
    println(arr[i])
    global i += 1
end

for el ∈ arr
    if el == 999 continue end
    println(el)
end

numtries = 0
while true
    global numtries +=1
    m, n = rand((1:6)), rand((1:6))
    if (m,n) == (6,6) break end
end
println("It took $numtries tries to get (6,6).")


arr = [5, 8, 12, 17, 24, 42];
sqarr = Int32[];

for el in arr
    append!(sqarr, el^2)
end
sqarr

sqarr = [x^2 for x in arr]

[(x^2, y^3) for x ∈ 1:4, y ∈ 1:3]

[x^2 for x in arr if iseven(x)]

[(i,j) for i=1:4 for j=1:i]

s = 0;
@time for i = 1:1_000_000_000 s += i^2 end

@time sum([i^2 for i = 1:1_000_000_000])

@time sum(i^2 for i ∈ 1:1_000_000_000)


function f(x)
    3x^2 + 4x - 5
end

f(x) = 3x^2 + 4x - 5

g = x -> 3x^2 + 4x -5

numbers = [3 4 7 8 9 12];
newNumbers = map(x -> 3x^2 -2x, numbers)

function mymax(array)
    maxnum = typemin(Int64)
    for num in array 
        if num > maxnum 
            maxnum = num 
        end
    end
    return maxnum 
end

function absDiff(a,b)
    if a > b
        return a - b
    else
        return b - a 
    end
end

function absDiff(a,b)
    return if a > b 
        a - b 
    else
        b - a
    end
end

function greet()
    println("Welcome to Julia Programming")
    println("I hope you enjoy...")
end
greet()

Φ(x,y) = x^y
Φ(3,4)

phi = Φ
phi(3,4)

function ratio(x::Int64, y::Int64)::Rational
    return x//y
end

function find_mean_sd(arr)
    mean = sum(x for x in arr) / length(arr)
    std = √(sum((x-mean)^2 for x in arr)/(length(arr)-1))
    return mean, std
end

array = [4, 5, 6, 8, 12, 34, 65, 98, 76, 36, 35];
μ, σ = find_mean_sd(array)
result = find_mean_sd(array)

pow(x, y=2) = x^y
pow(9)

function printall(x...) println(x) end
printall("Julia")
printall("Julia", "Python", "R")

position_args(x, y=10, z=20) = println("x = $x, y = $y, z = $z")
position_args(1)
position_args(1, 2)
position_args(1, z=3)

keyword_args(x; y=10, z=20) = println("x = $x, y = $y, z = $z")
keyword_args(1, z=3, y=2)
keyword_args(; x, y) = println("x = $x and y = $y")


v = Vector(1:5);
n = 7;
v + n

v + repeat([n], size(v,1))

broadcast(+, v, n)

v .+ n

a = [4 7 2 9 11 15];
b = [3 7 3 9 12 15];
a == b
a .== b

x = [3 5 7 9]
x.^2 .+ 3x .- 5
@. x^2 + 3x - 5

f(x) = 3x^2 + 2x + 5
f.(a)

vec = [7 22 12 13 16 21 18 76]
vec[ vec .> 20]

x = rand(-10:10, 20);
square(x) = x .^ 2;
sum(square(x))

(sum ∘ square)(x)

x |> square |> sum

str = "Writing functions in Julia Programming"
length.(split(str))
str |> split .|> length

sqrt(sum((x .- sum(x)/length(x)).^2))

(x .- sum(x)/length(x)) .^ 2 |> sum |> sqrt

f(x,y) = x^y - x*y + 5x - 3y
4 |> a -> f(3, a)

x = [35, 1, -7, 12, -11, -17];
sort(x)
x'

sort!(x);
x'

function padwithzero(vec, n)
    x = vcat(zeros(n), vec, zeros(n))
    return x 
end

x = [35, 1, -7, 12, -11, -17];
padwithzero(x, 2)'
x'

function padwithzero!(vec, n)
    for i in 1:n insert!(vec, 1, 0) end
    for i in 1:n append!(vec, 0) end
end

padwithzero!(x, 2)
x'

*
methods(*)

f(x::Float64, y::Float64) = x^2 + y^2
f(3.1, 6.5)
f(3, 6)
f(x::Number, y::Number) = x - y
f(7.0, 4)

f(x, y) = "I couldn't find a correct method."
f("abc", 5.0)

h(x::Int64, y) = x * y
h(x, y::Int64) = x / y
h(4, 4.5)
h(4.5, 4)
h(4, 5)

h(x::Int64, y::Int64) = x + y

myfunc(x=3, y=4) = x + y
myfunc()
myfunc(x::Int, y::Int) = x - y
myfunc()


compare_types(x::T, y::T) where {T} = "Arguments have the same type"
compare_types(4, 5)
compare_types("abc", "xyz")
compare_types(3, 5.2)
compare_types(x, y) = "Argument types are different"
compare_types(x::T, y::T) where {T <: Number} = "Same type numbers"
compare_types(3.14, 2.78)

compare_types(x::Number, y::Number) = "Numbers but different types"
compare_types(2.5, 5)

abstract type Shape end

struct Circle <: Shape
    radius::Float64
end

struct Rectangle <: Shape 
    width::Float64 
    height::Float64 
end

area(s::Circle) = π * s.radius^2
area(s::Rectangle) = s.width * s.height

mutable struct Model{R <: Real}
    β₀::R
    β::Vector{R}    
end

function (m::Model)(x)    
    yhat = m.β₀ + sum(x[i]*m.β[i] for i ∈ 1:length(x))
    return yhat 
end

lm = Model(2.0, [3.2, 5.4, 7.5])

x = [2, 4, 6];
lm(x)

function (m::Model)(x, y)
    yhat = m(x)
    se = (y - yhat)^2
    return se 
end

lm(x, 75.5)

abstract type Student end

mutable struct CSStudent
    name::String
    studentId::Int64
    gpa::Float64
    specialization::String
    programming_language::String
end

methods(CSStudent)

cs1 = CSStudent("George", 123456, 3.75, "Data Science", "Julia")

CSStudent(name, id, gpa) = CSStudent(name, id, gpa, "Data Science", "Julia")

cs2 = CSStudent("Mary", 112233, 3.95)

function CSStudent(; name,
                     studentId,
                     gpa=NaN,
                     specialization="Data Science",
                     programming_language="Julia")

    return CSStudent(name, studentId, gpa, specialization, programming_language)
end

cs3 = CSStudent(name="Mario", studentId=654321, 
                specialization="Mobile Development", programming_language="Kotlin")


Base.@kwdef mutable struct CSStudent1
    name::String
    studentId::Int64
    gpa::Float64 = NaN
    specialization::String = "Data Science"
    programming_language::String = "Julia"
end

cs4 = CSStudent1(name="Laurance", studentId=454545)

mutable struct MathStudent <: Student
    name::String 
    studentId::Int64
    gpa::Float64

    MathStudent(name, studentId, gpa) = gpa < 0 ? throw("GPA<0!") : new(name, studentId, gpa)
end

m1 = MathStudent("Karl", 111222, -1.0)

mutable struct EconStudent
    name::String
    studentId::Int64
    gpa::Float64

    function EconStudent(name, studentId, gpa)
        if name == ""
            throw("Name cannot be empty")
        elseif studentId ∈ [NaN, 0] 
            throw("Id cannot be empty")
        elseif !(0 ≤ gpa ≤ 4.0)
            throw("Enter a valid gpa")
        else
            new(name, studentId, gpa)
        end
    end
end

es1 = EconStudent("", 123456, 3.2)
es1 = EconStudent("Daniel", 0, 3.2)
es1 = EconStudent("Daniel", 456789, 5)
es1 = EconStudent("Daniel", 123456, 3.5)

mutable struct PhysStudent <: Student 
    name::String 
    student_id::Int64 
    gpa::Float64

    PhysStudent() = new()
end

ps1 = PhysStudent()