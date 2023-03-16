# File used to test

# Libraries
using Images
using PyPlot
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

function reshape_to_plotable_map(imgMat::Array{Float64, 3})
    println(size(imgMat,2), size(imgMat,3))
    img = Array{Float64, 3}(undef, size(imgMat,2), size(imgMat,3), 3)
    for i in 1:size(imgMat,2)
        for j in 1:size(imgMat,3)
            img[i, j, :] = imgMat[:, i, j]
        end
    end
    return img
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
function draw_visited(imgMat::Array{Float64, 3}, visited_nodes::Matrix{Bool})
    for i in 1:size(visited_nodes, 2)
        for j in 1:size(visited_nodes, 2)
            if visited_nodes[i, j] == true
                imgMat[:, i, j] = [1.0  0.788235  0.129412]
            end
        end
    end
end

# function draw_visited(imgMat::Array{Float64, 3}, visited_nodes::Vector{Tuple{Int64, Int64}})
#     for i in length(visited_nodes):-1:1
#         curr_x, curr_y = visited_nodes[i]
#         imgMat[:, curr_x, curr_y] = [1.0  0.788235  0.129412]
#     end
# end

# given image is a plotable map
function show_slowly(imgMat::Array{Float64, 3}, visited_nodes::Vector{Tuple{Int64, Int64}})
    for i in 1:length(visited_nodes)
        curr_x, curr_y = visited_nodes[i]
        imgMat[curr_x, curr_y, :] = [1.0  0.788235  0.129412]
        imshow(imgMat)
        sleep(0.0000001)
    end
end

function algoDijkstra(fname::String, D::Tuple{Int64, Int64}, A::Tuple{Int64, Int64})
    println("\nBeginning of Dijkstra algorithm:")
    d_x::Int64, d_y::Int64 = D
    a_x::Int64, a_y::Int64 = A

    # Transform the .map file into a matrix of Char
    mapChar::Matrix{Char} = map_to_matrix("$fname")

    # Transform the Char matrix into the matrix of costs
    costMap::Matrix{Int64} = map_to_int(mapChar)

    # performing the dijkstra algorithm to find the shortest path
    @time parents, visited_nodes = dijkstra(costMap, d_x, d_y, a_x, a_y)

    # Forming the path taken from the parents matrix
    path::Vector{Tuple{Int64, Int64}} = path_creation(parents, d_x, d_y, a_x, a_y)

    # Transforming the matrix of Chars into a "Matrix" of RGB channels
    mapImg::Array{Float64, 3} = map_to_img(mapChar)

    # drawing on the map the visited points
    draw_visited(mapImg, visited_nodes)
    # drawing on the map the path taken 
    draw_path(mapImg, path, d_x, d_y, a_x, a_y)

    imshow(reshape_to_plotable_map(mapImg))

    # # uncomment the following line if you want to save the image as a png
    # save("./dat/Results/yourfile.png", colorview(RGB, mapImg))

    println("All done for Dijkstra!")
end

function algoAstar(fname::String, D::Tuple{Int64, Int64}, A::Tuple{Int64, Int64})
    println("\nBeginning of Astar algorithm:")
    d_x::Int64, d_y::Int64 = D
    a_x::Int64, a_y::Int64 = A

    # Transform the .map file into a matrix of Char
    mapChar::Matrix{Char} = map_to_matrix("$fname")

    # Transform the Char matrix into the matrix of costs
    costMap::Matrix{Int64} = map_to_int(mapChar)

    # performing the Astar algorithm to find the shortest path
    @time parents, visited_nodes = astar(costMap, d_x, d_y, a_x, a_y)

    # Forming the path taken from the parents matrix
    path::Vector{Tuple{Int64, Int64}} = path_creation(parents, d_x, d_y, a_x, a_y)

    # Transforming the matrix of Chars into a "Matrix" of RGB channels
    mapImg::Array{Float64, 3} = map_to_img(mapChar)

    # drawing on the map the visited points
    draw_visited(mapImg, visited_nodes)
    # drawing on the map the path taken 
    draw_path(mapImg, path, d_x, d_y, a_x, a_y)

    # line to plot the map
    imshow(reshape_to_plotable_map(mapImg))
    # axis("off")

    # # uncomment the following line if you want to save the image as a png
    # save("./dat/Results/yourfile.png", colorview(RGB, mapImg))

    println("All done for Astar!")
end

function main()
    # algoDijkstra("Expedition.map", (80, 150), (853, 926))
    algoAstar("Expedition.map", (80, 150), (853, 926))
end
