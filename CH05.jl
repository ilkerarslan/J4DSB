# import data files 
using CSV, DataFrames
input = CSV.read("Data/chapter05/ch05_input_data.csv", DataFrame)
output = CSV.read("Data/chapter05/ch05_output_data.csv", DataFrame)

names(input) |> show
names(output) |> show

using PrettyTables
coldict = Dict(names(input) .=> eltype.(eachcol(input)));
pretty_table(coldict, crop=:none)

eltype(input[!, "firstCreditUsageDate"])

datecols = names(input, r"Date");
Dict(datecols .=> eltype.(eachcol(input[!,datecols])))

using Dates
dfmt = dateformat"dd-mm-yy";
input = CSV.read("Data/chapter05/ch05_input_data.csv", 
                 dateformat=dfmt, 
                 DataFrame);
Dict(datecols .=> eltype.(eachcol(input[!,datecols])))

input[!, datecols]

for col in datecols
    input[!, col] = input[!,col] .+ Year(2000)
end

input[!, datecols]

output = CSV.read("Data/chapter05/ch05_output_data.csv", 
                  dateformat=dfmt, 
                  DataFrame)

output[!,"recordDate"] = output[!, "recordDate"] .+ Year(2000);

dfmt2 = dateformat"yyyymmdd"
int2date(x) = Date(string(x), dfmt2)

output.defaultDate = [int2date(el) for el in output.defaultDate];
output

# Remove duplicates
unique!(input, [:custID, :appDate])
unique!(output, [:defaultDate, :customer_ID])

# Combine Input an Output Data

default = Int[]

for row in eachrow(input)    
    id, date = row.custID, row.appDate
    defdates = output[output.customer_ID .== id, :defaultDate]
    result = date .< defdates .< date + Year(1)
    sum(result) > 0 ? push!(default, 1) :  push!(default, 0)
end

sum(default) 
sum(default) / length(default)

data = deepcopy(input);
data.default = default;
data[!, end-2:end]

# Convert nonnumerical data to numerical

coltypes = DataFrame(column=names(data), 
                     type=eltype.(eachcol(data)))

datecond = coltypes.type .∈ Ref([Date, Union{Missing, Date}])
datecols = coltypes[datecond, :]

strcond = (coltypes.type .<: AbstractString) .| (coltypes.type .<: Union{Missing, AbstractString})
strcols = coltypes[strcond, :]

diff = data.appDate .- data.latestCreditLineDate
diff = [ismissing(el) ? missing : Dates.value(el) for el in diff]

cols = datecols.column[datecols.column .!= "appDate"]

for col in cols 
    println(col)
    diff = (data.appDate .- data[!, col])
    data[!, col] = [ismissing(el) ? missing : Dates.value(el) for el in diff]
end

data[!, r"Date"]

# String columns
strcols

# one-hot-encoding
onehot = zeros(Int8, size(data,1))
onehot[data[:, "custSegment"] .== "Micro"] .= 1; 
data[!, "Micro"] = onehot;
onehot[1:10]'
data.custSegment[1:10]
sum(onehot) == count(data.custSegment .== "Micro")

function column2onehot!(df, colname)
    categories = unique(df[:,colname])
    for category in categories
        onehot = zeros(Int8, size(df,1))
        onehot[df[:, colname] .== category] .= 1
        df[:, category] = onehot
    end
    select!(df, Not(colname))
end

column2onehot!(data, "custSegment")
data[:, [:Micro, :Medium, :Commercial, :Corporate]]
data[:, :custSegment]  # should throw an error.


# Label encoding
column = data.creditRating;

keys = unique(column);
keys = keys[.!(ismissing.(keys))] |> sort

values = collect(1:length(keys));
labels = Dict(string.(keys) .=> values)

newcolumn = replace(column, labels...)
newcolumn = [ismissing(el) ? el : Int(el) for el in newcolumn]

data[:, "creditRating_lblenc"] = newcolumn
select!(data, Not("creditRating"))  


# Summarize Data

# Numerical columns
data
describe(data)

coltypes = eltype.(eachcol(data))
numtypes = (coltypes .<: Real)  .| (coltypes .<: Union{Missing, Real})
data[!, numtypes] |> describe

# Frequency table for categorical variables. 
combine(groupby(data, :exceptionCategory), nrow => :Freq)

# Negative values in date variables
data[:, r"Date"] |> x -> describe(x, :min, :median, :max)
cols2replace = [:latestCreditLineDate, :firstCreditUsageDate, :lastCreditUsageDate]

neg2missing(x) = ismissing(x) ? missing : (x < 0 ? missing : x)

for col in cols2replace
    data[!, col] = data[!, col] .|> neg2missing
end 

data[:, cols2replace] |> x -> describe(x, :min, :median, :max)

# Missing Values
data[completecases(data), :]

missingvals = (describe(data)[:, [:variable, :nmissing]])
missingvals = subset(missingvals, :nmissing => x -> x .> 0) 
transform!(missingvals, :nmissing => (x -> x ./ nrow(data) .* 100) => :ratiomissing)

lim = 90;
cols2remove = missingvals[missingvals.ratiomissing .> lim, :variable]
select!(data, Not(cols2remove))

condition = data[:, :unusedCheckCount] .|> !ismissing;
data = data[condition, :]

dropmissing!(data, :unusedCheckCount)

missingvals = (describe(data)[:, [:variable, :nmissing]])
missingvals = subset(missingvals, :nmissing => x -> x .> 0) 
transform!(missingvals, :nmissing => (x -> x ./ nrow(data) .* 100) => :ratiomissing)

data |> describe |> df -> subset(df, :nmissing => x -> x .> 0) |> df -> select(df, [:variable, :nmissing])

using Statistics
medianImpute(v) = [ismissing(el) ? median(skipmissing(v)) : el for el in v] 

data.lastCreditUsageDate = medianImpute(data.lastCreditUsageDate)