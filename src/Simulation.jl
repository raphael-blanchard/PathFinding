# File used to test

# Libraries
using Images
# Files used
include("dijkstra.jl")
include("astar.jl")

# Dictionnary that associate an RGB value to each char present in a map
map_colors::Dict{Char, Matrix{Float32}} = Dict(
    '.' => [1 1 1],
    '@' => [0 0 0],
    'W' => [0.0058 0.7168 0.9949],
    'T' => [0.1008 0.5409 0.112],
    'S' => [0.333333  0.360784  0.270588]
)

# function that transform the matrix of the map into an image (Matrix of RGB)
function map_to_img(map::Matrix{Char})
    imgMat = Array{Float64, 3}(undef, 3, size(map,1), size(map,2))
    for i in 1:size(map,1)
        for j in 1:size(map,2)
            imgMat[:, i, j] = map_colors[map[i,j]]
        end
    end
    return imgMat
end

# function that draws a given path on 
function draw_path(imgMat::Array{Float64, 3}, path::Vector{Coordinate}, start_x::Int64, start_y::Int64, finish_x::Int64, finish_y::Int64)
    for coord in path
        # path
        imgMat[:, coord.x, coord.y] = [1 0 0]
    end
    # starting point
    imgMat[:, start_x, start_y] = [0 0.812 0.012]
end

function main()
    filename::String = "theglaive"
    filename2::String = "theglaiveAstar"
    
    start_x::Int64, start_y::Int64, finish_x::Int64, finish_y::Int64 = 173, 321, 434, 50
    # Transform the .map file into a matrix of Char
    mapChar::Matrix{Char} = map_to_matrix("$filename.map")
    # Transform a Char matrix into a matrix of vertices, corresponding to the graph of the map
    mapVertices::Matrix{Vertex} = map_to_vertices(mapChar)
    parents = astar(mapVertices, start_x, start_y, finish_x, finish_y)
    path::Vector{Coordinate} = path_creation(parents, start_x, start_y, finish_x, finish_y)

    img_test = map_to_img(mapChar)
    draw_path(img_test, path, start_x, start_y, finish_x, finish_y)

    save("../dat/Results/$filename2.png", colorview(RGB, img_test))
    # print_path(path)
end
