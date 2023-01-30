readdir()
readdir("Data")
mkdir("Data/chapter04/newsongs")
touch("Data/chapter04/newsongs/dayDreamer.txt")

file = open("Data/chapter04/newsongs/dayDreamer.txt")
readlines(file)
close(file)

fname = "Data/chapter04/newsongs/dayDreamer.txt"
open(fname) do file
    readlines(file)
end 

fname = "Data/chapter04/newsongs/dayDreamer.txt"
file = open(fname, "w")
write(file, "This is a new line...\n")
close(file)

rm("Data/chapter04/newsongs/dayDreamer.txt")
rm("Data/chapter04/newsongs/")



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


singer, lyrics = readFile("Data/chapter04/SongLyrics", "adele.txt")
txtCleaned = cleanText(lyrics, r"[\[.,!1234\]]")
wordDict = addWordsToDict(txtCleaned)

df = DataFrame(singer = String[], word = String[], count = Int64[])
addToDF!(df; artist=singer, wordVec=wordDict)
df

file = "adele.txt"
folder = "Data/chapter04/SongLyrics"
songLyrics = DataFrame(singer = String[], word = String[], count = Int64[])
stop_signs = r"[\[.,!?()\]:1234567890]"

readFileToDF!(songLyrics; file=file, folder=folder, remove=stop_signs)
songLyrics

folder = "Data/chapter04/SongLyrics"
files = readdir(folder);
songLyrics = DataFrame(singer = String[], word = String[], count = Int64[])

for file in files 
    println(file)
    readFileToDF!(songLyrics; file=file, folder=folder)
end

songLyrics

using CSV
CSV.write("Data/chapter04/songLyrics.csv", songLyrics)
CSV.write("Data/chapter04/songLyricsDelim.csv", songLyrics; delim=';')


using XLSX

XLSX.writetable("Data/chapter04/songLyrics.xlsx", songLyrics)

function saveToSheets(fileToSave)
    isfile("Data/chapter04/$fileToSave") && throw("This file exists!")

    XLSX.openxlsx("Data/chapter04/$fileToSave", mode="w") do xfile
        for file in readdir("Data/chapter04/SongLyrics")
            println(file)
            singer, lyrics = readFile("Data/chapter04/SongLyrics", file)
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

# Reading from csv files 
using CSV, DataFrames

songLyrics = CSV.read("Data/chapter04/songLyrics.csv", DataFrame)

lyricsDelim = CSV.read("Data/chapter04/songLyricsDelim.csv", DataFrame; delim=';')

# Reading from Excel files
using DataFrames, XLSX

xfile = XLSX.readxlsx("Data/chapter04/songLyrics.xlsx")
sheet1 = xfile["Sheet1"]

datatable = XLSX.gettable(sheet1)
datamtx = XLSX.getdata(sheet1)
datarange = sheet1["A1:C142502"]

DataFrame(datatable)
DataFrame(datamtx[2:end, :], datamtx[1,:])
DataFrame(datarange[2:end, :], datarange[1,:])

XLSX.readtable("Data/chapter04/songLyrics.xlsx", "Sheet1") |> DataFrame

datamtx = Matrix{Any}(undef, 0, 3)
fname = "Data/chapter04/songLyrics.xlsx"
XLSX.openxlsx(fname, enable_cache=false) do xfile     
    sheet = xfile["Sheet1"]    
    for r in XLSX.eachrow(sheet)        
        XLSX.row_number(r) % 10_000 == 0 && println("Row: $(XLSX.row_number(r))")
        row = Any[r[i] for i in 1:3]
        row = reshape(row, 1, 3)        
        global datamtx = vcat(datamtx, row)
    end
end

DataFrame(datamtx[2:end, :], datamtx[1,:])