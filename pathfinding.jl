# Libraries


# costs = 
# . -> 1
# 
function map_to_matrix(filename)
    # To read the txt file
    open("./Data/$filename") do f
        # Not a map
        if readline(f) != "type octile" return "Not a map" end

        height_line = readline(f)
        # getting the height as Int64
        height = parse(Int64, height_line[8:end])

        width_line = readline(f)
        width = parse(Int64, width_line[7:end])

        println((height, width))
        # map line
        whatever = readline(f)

        println(test)
        MatrixOfChars = Matrix{Char}(undef, height, width)

        # read till end of file
        i = 1
        while ! eof(f) 
           # read a new / next line for every iteration          
           curr_line = readline(f)
           MatrixOfChars[i, :] = collect(curr_line)
           i+=1
        end

        @show MatrixOfChars

    end
end