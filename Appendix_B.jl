### Reading from STAT Files 
using StatFiles, ReadStat, DataFrames

# StatFiles Package

# SPSS
StatFiles.load("Data/chapter04/StatFiles/songLyrics.sav") |> DataFrame

# Stata
StatFiles.load("Data/chapter04/StatFiles/songLyrics.dta") |> DataFrame

# SAS
StatFiles.load("Data/chapter04/StatFiles/songLyrics.sas7bdat") |> DataFrame


# ReadStat package

# SPSS
spss = read_sav("Data/chapter04/StatFiles/songLyrics.sav")
spss_df = DataFrame(spss.data, spss.headers)

# Stata
stata = read_dta("Data/chapter04/StatFiles/SongLyrics.dta")
stata_df = DataFrame(stata.data, stata.headers)

# SAS
sas = read_sas7bdat("Data/chapter04/StatFiles/songLyrics.sas7bdat")
sas_df = DataFrame(sas.data, sas.headers)

### HDF5
using HDF5, DataFrames, CSV

df = CSV.read("Data/chapter04/songLyrics.csv", DataFrame);

#Write the data to an hdf5 file
fname = "Data/chapter04/songLyrics.h5"  # Or .hdf5
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

d = Dict{String, Any}()
df = karatekidDF;

for col in names(karatekidDF)
    d[col] = isnothing(df[!, col][1]) ? nothing : df[!, col][1]
end

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
write("Data/chapter04/karatekid.json", jsonData)

songLyricsDF = CSV.read("Data/chapter04/songLyrics.csv", DataFrame)
songLyricsJSON = df_to_json(songLyricsDF)

write("Data/chapter04/songLyrics.json", songLyricsJSON)
songLyricsData = JSON.parsefile("Data/chapter04/songLyrics.json") |> DataFrame


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

write("Data/chapter04/lotr.xml", doc)

using EzXML, CSV, DataFrames
songLyricsDF = CSV.read("Data/chapter04/songLyrics.csv", DataFrame)

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

write("Data/chapter04/songLyrics.xml", doc)

using EzXML, DataFrames
xmldoc = EzXML.readxml("Data/chapter04/songLyrics.xml")
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

using ODBC, DBInterface, DataFrames

ODBC.drivers()

conn = ODBC.Connection("Driver=SQL Server;SERVER=10.125.1.26;DATABASE=dbfactoring;UID=bisuser;PWD=p@ssword1")

