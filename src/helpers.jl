# File containing the map parser and the costs to get to a point
include("dijkstra.jl")
include("astar.jl")


cost::Dict{Char, Int64} = Dict(
    '.' => 1,
    'G' => 1,
    '@' => 0,
    'T' => 0,
    'O' => 0,
    'S' => 5,
    'W' => 8
)

# function that takes as input a .map file and returns the corresponding Char matrix
function map_to_matrix(filename)
    open("./dat/Maps/$filename") do f
        # Case if the text file isn't a map
        if readline(f) != "type octile" return "Not a map" end

        height_line = readline(f)
        # getting the height as Int64
        height = parse(Int64, height_line[8:end])

        width_line = readline(f)
        width = parse(Int64, width_line[7:end])

        # println((height, width))
        
        # map line
        whatever = readline(f)

        MatrixOfChars = Matrix{Char}(undef, height, width)
        # transform the map into a matrix of chars
        i = 1
        while ! eof(f)       
           curr_line = readline(f)
           MatrixOfChars[i, :] = collect(curr_line)
           i+=1
        end
        return MatrixOfChars
    end
end

# dict needed to transform a terrain map to a normal map
alpha_to_classic::Dict{Char, Char} = Dict(
    'B' => 'W',
    'C' => 'W',
    'D' => 'S',
    'E' => 'T',
    'K' => '@',
    'P' => '.',
    'F' => 'S',
    'N' => 'S',
    'M' => 'S',
    'I' => 'S',
    'G' => 'T',
    'O' => 'T',
    'A' => '.'
)

# function that will transform an Alphabet map to our maps
function alphamap_to_classic(map::Matrix{Char})
    return [alpha_to_classic[map[i, j]] for i in 1:size(map,1), j in 1:size(map,2)]
end



