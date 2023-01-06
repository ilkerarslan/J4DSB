readdir()
readdir("CH04")
mkdir("Data")
touch("Data/dayDreamer.txt")

file = open("Data/dayDreamer.txt")
readlines(file)
close(file)

fname = "Data/dayDreamer.txt"
open(fname) do file
    readlines(file)
end 

fname = "Data/dayDreamer.txt"
file = open(fname, "w")
write(file, "This is a new line...\n")
close(file)


## SongLyrics
using DataFrames

function readFile(dirname, fname)
    file = open("$dirname/$fname")
    lyrics = readlines(file)
    close(file)
    artist = replace(fname, ".txt" => "")
    return artist, lyrics    
end

function cleanText(text, remove)
    txt = join(text, " ")
    txt = replace.(txt, remove => " ") |> lowercase
    txt = split(txt, " ")
    txt = [el for el in txt if el != ""]
    return txt 
end

function addWordsToDict(text)
    update_word_count!(d, w) = w ∈ keys(d) ? d[w] += 1 : d[w] = 1
    dict = Dict{String, Integer}()

    for word in text
        update_word_count!(dict, word)
    end

    word_counts = sort(collect(dict), by = x -> x[2], rev=true)
    return word_counts
end


function addToDF!(df; artist, wordVec)
    for n in eachindex(wordVec)
        row = vcat(artist, wordVec[n][1], wordVec[n][2])
        push!(df, row)
    end    
end

function readFileToDF!(df; file, folder, remove=stop_signs)
    singer, lyrics = readFile(folder, file)
    lyrics = cleanText(lyrics, remove)
    
    wd = addWordsToDict(lyrics)
    addToDF!(df; artist=singer, wordVec=wd)
end

file = "adele.txt"
folder = "Data/SongLyrics"
songLyrics = DataFrame(singer = String[], word = String[], count = Int64[])
stop_signs = r"[\[.,!?()\]:1234567890]"

readFileToDF!(songLyrics; file=file, folder=folder)
songLyrics

folder = "Data/SongLyrics"
files = readdir(folder);
songLyrics = DataFrame(singer = String[], word = String[], count = Int64[])

for file in files 
    println(file)
    readFileToDF!(songLyrics; file=file, folder=folder)
end

songLyrics

using CSV
CSV.write("Data/songLyrics.csv", songLyrics)
CSV.write("Data/songLyricsDelim.csv", songLyrics; delim=';')


using XLSX

XLSX.writetable("Data/songLyrics.xlsx", songLyrics)

function saveToSheets(fileToSave)
    isfile("Data/$fileToSave") && throw("This file exists!")

    XLSX.openxlsx("Data/$fileToSave", mode="w") do xfile
        for file in readdir("Data/SongLyrics")
            println(file)
            singer, lyrics = readFile("Data/SongLyrics", file)
            lyrics = cleanText(lyrics, stop_signs)            
            wd = addWordsToDict(lyrics)
            df = DataFrame(singer = String[], word = String[], count = Int64[])
            addToDF!(df; artist=singer, wordVec=wd)
            XLSX.addsheet!(xfile, singer)
            XLSX.writetable!(xfile[singer], df)
        end
    end
end

saveToSheets("songLyrics2.xlsx")

delim = '|'

# Reading from csv files 
using CSV, DataFrames

songLyrics = CSV.read("Data/songLyrics.csv", DataFrame)

lyricsDelim = CSV.read("Data/songLyricsDelim.csv", DataFrame; delim=';')

# Reading from Excel files
using DataFrames, XLSX

xfile = XLSX.readxlsx("Data/songLyrics.xlsx")
sheet1 = xfile["Sheet1"]

datatable = XLSX.gettable(sheet1)
datamtx = XLSX.getdata(sheet1)
datarange = sheet1["A1:C142502"]

DataFrame(datatable)
DataFrame(datamtx[2:end, :], datamtx[1,:])
DataFrame(datarange[2:end, :], datarange[1,:])

XLSX.readtable("Data/songLyrics.xlsx", "Sheet1") |> DataFrame

datamtx = Matrix{Any}(undef, 0, 3)

XLSX.openxlsx("Data/songLyrics.xlsx", enable_cache=false) do xfile     
    sheet = xfile["Sheet1"]    
    for r in XLSX.eachrow(sheet)        
        XLSX.row_number(r) % 10_000 == 0 && println("Row: $(XLSX.row_number(r))")
        row = Any[r[i] for i in 1:3]
        row = reshape(row, 1, 3)        
        global datamtx = vcat(datamtx, row)
    end
end

DataFrame(datamtx[2:end, :], datamtx[1,:])

### Reading from STAT Files 
using StatFiles, ReadStat, DataFrames

# SPSS
song_spss = StatFiles.load("Data/StatFiles/songLyrics.sav") |> DataFrame

spss = read_sav("Data/StatFiles/songLyrics.sav")
spss_df = DataFrame(sl.data, sl.headers)

# Stata
StatFiles.load("Data/StatFiles/songLyrics.dta") |> DataFrame

stata = read_dta("Data/StatFiles/SongLyrics.dta")
stata_df = DataFrame(stata.data, stata.headers)


# SAS
StatFiles.load("Data/StatFiles/songLyrics.sas7bdat") |> DataFrame

sas = read_sas7bdat("Data/StatFiles/songLyrics.sas7bdat")
sas_df = DataFrame(sas.data, sas.headers)

### HDF5

using HDF5, DataFrames, CSV

df = CSV.read("Data/songLyrics.csv", DataFrame);

fname = "Data/songLyrics.h5"  # Or .hdf5
hdf = h5open(fname, "cw")
create_group(hdf, "lyrics")

for col in names(df)
    dset = convert(Array, df[!, col])
    hdf["lyrics"][col] = dset
end

hdf

attrs(hdf["lyrics"])["Description"] = "Song lyrics of 49 singers."
hdf

close(hdf)

hdf

h5 = h5open(fname, "r")
group = h5["lyrics"]

attrs(group)
group["count"] |> read

hdf_df = DataFrame(singer = read(group["singer"]), word = read(group["word"]), count = read(group["count"]))

hdf_df == df

### Reading From JSON Files

karatekidJSON = """
{
    "name": "Daniel", 
    "surname": "LaRusso", 
    "studentId": 1001,     
    "scores": [
        {"course": "Math", "score": 80},
        {"course": "Physics", "score": 85},
        {"course": "Computer Science", "score": 90},
        {"course": "Chemistry",  "score": 95},
        {"course": "Gym", "score": 100}
    ]
}
"""

typeof(karatekidJSON)

using JSON, DataFrames

karatekidDict = JSON.parse(karatekidJSON)

karatekidDF = DataFrame(karatekidDict)

scoresCol = karatekidDF[!, :scores]

course = [scoresCol[i]["course"] for i in eachindex(scoresCol)]
score = [scoresCol[i]["score"] for i in eachindex(scoresCol)]

karatekidDF[!, :course] = course
karatekidDF[!, :score] = score
select!(karatekidDF, Not(:scores))

karatekidDF

select!(karatekidDF, [:studentId, :name, :surname, :course, :score])
karatekidDF

function df_to_json(df::DataFrame)
    jsonVector = []

    for i in 1:size(df, 1)
        jsonDict = Dict{String, Any}()
        for col in names(df) 
            jsonDict[col] = isnothing(df[!, col][i]) ? 
                                      nothing : 
                                      df[!, col][i]
        end
        push!(jsonVector, jsonDict)
    end
    
    return JSON.json(jsonVector)
end

jsonData = df_to_json(karatekidDF)
write("Data/karatekid.json", jsonData)


songLyricsDF = CSV.read("Data/songLyrics.csv", DataFrame)
songLyricsJSON = df_to_json(songLyricsDF)

write("Data/songLyrics.json", songLyricsJSON)
songLyricsData = JSON.parsefile("Data/songLyrics.json") |> DataFrame


### XML

using EzXML
doc = XMLDocument()
typeof(doc)
doc.node
typeof(doc.node)
print(doc)

root = ElementNode("lotr")
setroot!(doc, root)
print(doc)

movie1 = ElementNode("movie")
addelement!(movie1, "order", "1")
addelement!(movie1, "name", "The Fellowship of the Ring")
addelement!(movie1, "year", "2001")

rate = ElementNode("rating")
rate["source"] = "IMDB"
rate.content = "8.8"
link!(movie1, rate)

EzXML.prettyprint(movie1)

link!(root, movie1)
prettyprint(doc)

movie2 = ElementNode("movie")
addelement!(movie2, "order", "2")
addelement!(movie2, "name", "The Two Towers")
addelement!(movie2, "year", "2002")
rate = ElementNode("rating")
rate["source"] = "IMDB"
rate.content = "8.8"
link!(movie2, rate)
link!(root, movie2)

movie3 = ElementNode("movie")
addelement!(movie3, "order", "3")
addelement!(movie3, "name", "The Return of The King")
addelement!(movie3, "year", "2003")
rate = ElementNode("rating")
rate["source"] = "IMDB"
rate.content = "9.0"
link!(movie3, rate)
link!(root, movie3)
prettyprint(doc)

write("Data/lotr.xml", doc)


using EzXML, DataFrames
xmldoc = EzXML.readxml("Data/lotr.xml")
xmlroot = xmldoc.root

orderNodes = findall("//movie/order", xmlroot)
nameNodes = findall("//movie/name", xmlroot)
yearNodes = findall("//movie/year", xmlroot)
ratingNodes = findall("//movie/rating", xmlroot)

orders = [el.content for el in orderNodes]
names = [el.content for el in nameNodes]
years = [el.content for el in yearNodes]
ratingSources = [el["source"] for el in ratingNodes]
ratings = [el.content for el in ratingNodes]

orders = parse.(Int, orders)
years = parse.(Int, years)
ratings = parse.(Float16, ratings)

lotr = DataFrame(order=Int[], 
                 name=String[], 
                 year=Int[], 
                 ratingSource=String[], 
                 rating=Float16[])

for i ∈ eachindex(orders)
    row = Dict("order" => orders[i], 
               "name" => names[i], 
               "year" => years[i], 
               "ratingSource" => ratingSources[i],
               "rating" => ratings[i])
    
    rowDF = DataFrame(row)
    select!(rowDF, [:order, :name, :year, :ratingSource, :rating])    
    lotr = vcat(lotr, rowDF)
end


using EzXML, CSV, DataFrames
songLyricsDF = CSV.read("Data/songLyrics.csv", DataFrame)

doc = XMLDocument()
root = ElementNode("songLyrics")
setroot!(doc, root)

function add_row_to_xml(singer, word, count)
    wordcount = ElementNode("wordcount")
    addelement!(wordcount, "singer", singer)
    addelement!(wordcount, "word", word)
    addelement!(wordcount, "count", string(count))
    link!(root, wordcount)
end

for i in 1:size(songLyricsDF,1)
    singer = songLyricsDF[i, :singer]
    word = songLyricsDF[i, :word]
    count = songLyricsDF[i, :count]

    add_row_to_xml(singer, word, count)
end

prettyprint(doc)

write("Data/songLyrics.xml", doc)

using EzXML, DataFrames
xmldoc = EzXML.readxml("Data/songLyrics.xml")
xmlroot = xmldoc.root
singerNodes = findall("//wordcount/singer", xmlroot)
wordNodes = findall("//wordcount/word", xmlroot)
countNodes = findall("//wordcount/count", xmlroot)

singers = [el.content for el in singerNodes]
words = [el.content for el in wordNodes]
counts = [el.content for el in countNodes]
counts = parse.(Int, counts)

songLyrics = DataFrame(singer = String[], 
                       word = String[],
                       count = Int[])

for i ∈ eachindex(singers)
    row = Dict("singer" => singers[i],
               "word" => words[i],
               "count" => counts[i])

    rowDF = DataFrame(row)
    select!(rowDF, [:singer, :word, :count])
    songLyrics = vcat(songLyrics, rowDF)
end

songLyrics

# Relational Data Base Connection

using ODBC

ODBC.drivers()

conn = ODBC.Connection("Driver=SQL Server;SERVER=10.125.1.26;DATABASE=dbfactoring;UID=bisuser;PWD=p@ssword1")

