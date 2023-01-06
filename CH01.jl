using CSV
using DataFrames
using Plots
using Dates
using CSV
plotlyjs()

versiondata = CSV.read("Data/CH01/julia_version_releases.csv", DataFrame)
versiondata.month = Dates.format.(versiondata.Time, "u yyyy")

tick_years = Date.(2012:2022)
datetick = Dates.format.(tick_years, "yyyy")
plot(versiondata.Time, versiondata.Version, 
     seriestype=[:line, :scatter],
     legend=false)
plot!(xticks = (tick_years, datetick), ylim=(0.0,2.0))
annotate!(Date("2012-01-01"), 0.15, ("Feb'12 v0.0", 8), :left)
annotate!(Date("2018-08-01"), 0.95, ("Aug'18 v1.0", 8), :left)
annotate!(Date("2021-12-01"), 1.75, ("Nov'21 v1.7", 8), :right)
title!("Julia Version History")
savefig("Plots/CH01_F01_Arslan.svg")

i3e = CSV.read("Data/CH01/ieeespectrum.csv", DataFrame)
plot(i3e.Year, i3e.Rank, 
     seriestype=[:line, :scatter],
     legend=false,
     xaxis="Year",
     yaxis="Rank",
     title="Julia Ranking in IEEE Spectrum")

savefig("Plots/CH01_F02_Arslan.svg")