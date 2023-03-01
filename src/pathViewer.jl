using Images
include("utils.jl")
A = rand(3, 4, 5)
# A[rgb channels, row, column]
A[:,1,1] = [0 0 0]
A[:,2,1] = [0.0058 0.7168 0.9949]
A[:, 1, 2] = [0.1008 0.5409 0.112]
# A[:,] = [1 1 1]

map_colors::Dict{Char, Matrix{Float32}} = Dict(
    '.' => [1 1 1],
    '@' => [0 0 0],
    'W' => [0.0058 0.7168 0.9949],
    'T' => [0.1008 0.5409 0.112],
    'S' => [0.7607 0.6980 0.50196]
)

function map_to_matrix(filename)
    open("../Data/$filename") do f
        # Case if the text file isn't a map
        if readline(f) != "type octile" return "Not a map" end

        height_line = readline(f)
        # getting the height as Int64
        height = parse(Int64, height_line[8:end])

        width_line = readline(f)
        width = parse(Int64, width_line[7:end])

        println((height, width))
        
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
        
        # @show MatrixOfChars
        return MatrixOfChars
    end
end

function map_to_img(map::Matrix{Char})
    imgMat = Array{Float64, 3}(undef, 3, size(map,1), size(map,2))
    for i in 1:size(map,1)
        for j in 1:size(map,2)
            imgMat[:, i, j] = map_colors[map[i,j]]
        end
    end
    return imgMat
end

function draw_path(imgMat::Array{Float64, 3}, path::Vector{Coordinate}, start_x::Int64, start_y::Int64, finish_x::Int64, finish_y::Int64)
    for coord in path
        imgMat[:, coord.x, coord.y] = [0.2 1.0 0.2]
    end
end

test = map_to_matrix("divideandconquer.map")
img_test = map_to_img(test)
path = main()
draw_path(img_test, path, 1,1,1,1)

save("divideandconquer.png", colorview(RGB, img_test))
