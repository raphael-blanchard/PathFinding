# File used to test

# Libraries
using Images
# Files used
include("helpers.jl")

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

# function that draws a given path on the image
function draw_path(imgMat::Array{Float64, 3}, path::Vector{Tuple{Int64, Int64}}, start_x::Int64, start_y::Int64, finish_x::Int64, finish_y::Int64)
    for (x, y) in path
        # path
        imgMat[:, x, y] = [1 0 0]
    end
    # starting point
    imgMat[:, start_x, start_y] = [0 0.812 0.012]
end

# function that marks visited nodes on an image
function draw_visited(imgMat::Array{Float64, 3}, visited_nodes::Vector{Tuple{Int64, Int64}})
    for (x, y) in visited_nodes
        # path
        imgMat[:, x, y] = [1.0  0.788235  0.129412]
    end
end

function main()
    filename::String = "divideandconquer"
    filename2::String = "divideandconquerAstar"

    start_x::Int64, start_y::Int64, finish_x::Int64, finish_y::Int64 = 49, 64, 450, 450
    # Transform the .map file into a matrix of Char
    mapChar::Matrix{Char} = map_to_matrix("$filename.map")
    # Transform a Char matrix into a matrix of vertices, corresponding to the graph of the map
    mapInt::Matrix{Int64} = map_to_int(mapChar)
    parents, visited_nodes = astar(mapInt, start_x, start_y, finish_x, finish_y)
    path::Vector{Tuple{Int64, Int64}} = path_creation(parents, start_x, start_y, finish_x, finish_y)

    img_test = map_to_img(mapChar)
    draw_visited(img_test, visited_nodes)
    draw_path(img_test, path, start_x, start_y, finish_x, finish_y)

    # save("../dat/Results/$filename2.png", colorview(RGB, img_test))
    # print_path(path)
    println("Done!")
end
