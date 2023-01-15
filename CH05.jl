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

show(describe(data), allrows=true)
data |> describe |> df -> show(df, allrows=true)

data = data[!, Not(:minOverdueDays)];

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

# Outliers

describe(data.undueCheckCount)

using Plots, StatsPlots
histogram(data.undueCheckCount, bins=:scott, legend=false)
boxplot(data.undueCheckCount, legend=false, xaxis=[])

using Statistics
q1, q3 = quantile(data.undueCheckCount, [0.25, 0.75])
iqr = q3 - q1
max_thresh = q3 + 1.5 * iqr

data[!, :undueCheckCount] = data[!, :undueCheckCount] .|> v -> (v > max_thresh ? max_thresh : v)


# Standardize and Scale Data
data |> describe |> df -> show(df, allrows=true)

histogram(data.totalLoanExposure, bins=:scott, legend=false)

logvalues = log.(data.totalLoanExposure .+ 1)
histogram(logvalues, bins=:scott, legend=false)

avg = mean(logvalues)
sd = std(logvalues)

stnorm = (logvalues .- avg) ./ sd;
histogram(stnorm, bins=:scott, legend=false)

describe(stnorm)

stnorm = stnorm .|> x -> x < -3 ? -3 : (x > 3 ? 3 : x) 

histogram(data.paidCheckAmount)

minmaxscaler(x) = (x .- minimum(x)) ./ (maximum(x) - minimum(x))
scaled = minmaxscaler(data.paidCheckAmount)
describe(scaled)

describe(data) |> df -> show(df, allrows=true)

function stdnormalizer(x)
    avg = x |> skipmissing |> mean
    sd = x |> skipmissing |> std
    return (x .- avg) ./ sd
end

for i ∈ 4:71
    data[!, i] = stdnormalizer(data[!, i])
end

describe(data, :detailed, ) |> df -> show(df, allrows=true)

# Find correlations
using Statistics

function corrcoef(x,y)    
    indices = .!(ismissing.(x) .| ismissing.(y))
    x = x[indices]
    y = y[indices]
    mx = mean(x)
    my = mean(y)

    sdx = std(x)
    sdy = std(y)

    n = length(x)

    covxy = (x .- mx) .* (y .- my) |> sum 
    covxy = covxy / (n-1)

    return covxy /(sdx * sdy)
end

a = data.totalCashLoanLimit
b = data.totalLoanLimit
corrcoef(a,b)

variables = names(data)[5:71]
corrdf = DataFrame(var1=String[], var2=String[], corrcoef=Float64[])

for i in 1:length(variables)-1
    for j in (i+1):length(variables)
        var1 = variables[i]
        var2 = variables[j]
        coef = corrcoef(data[:, var1], data[:, var2])
        push!(corrdf, (var1=var1, var2=var2, corrcoef=coef))
    end
end

size(corrdf)
corrdf[!, :absCorrCoef] = abs.(corrdf[!, :corrcoef]);
sort!(corrdf, :absCorrCoef, rev=true)

extravars = subset(corrdf, :absCorrCoef => x -> x .> 0.9)
extravars.var2 |> unique

cols2remove = unique(extravars.var2)
data = data[!, Not(cols2remove)]



using DataFrames, Plots

function split_to_bins(column::Symbol, n_bins::Int)
    df = data[:, [column, :default]]
    sort!(df, column)
    df[!, :bin] .= 0
    binlimits = (nrow(df) ÷ n_bins) .* (1:(n_bins-1)) |> collect
    pushfirst!(binlimits, 1)
    
    for i ∈ 1:(n_bins-1)
        df[binlimits[i]:binlimits[i+1], :bin] .= i
    end
    
    df[binlimits[end]:nrow(df), :bin] .= n_bins;
    res = combine(groupby(df, :bin), :default => mean)
    plot(res.bin, res.default_mean, legend=false, title=column)
    scatter!(res.bin, res.default_mean, legend=false)
end

split_to_bins(:maxOverdueDays, 3)
split_to_bins(:lastBounceDate, 4)
