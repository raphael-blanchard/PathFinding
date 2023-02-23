# Libraries

# Associated costs of a movement
# E.g: '.' -> 'T' costs 3, and we would access this value by doing costs['.']['T']
costs::Dict{Char, Dict{Char, Int64}} = Dict(
    '.' => Dict(
        '.' => 1,
        '@' => 0,
        'T' => 3,
        'S' => 3,
        'W' => 3),
    '@' => Dict(
        '.' => 0,
        '@' => 0,
        'T' => 0,
        'S' => 0,
        'W' => 0),
    'T' => Dict(
        '.' => 3,
        '@' => 0,
        'T' => 5,
        'S' => 5,
        'W' => 5),
    'S' => Dict(
        '.' => 3,
        '@' => 0,
        'T' => 5,
        'S' => 5,
        'W' => 5),
    'W' => Dict(
        '.' => 3,
        '@' => 0,
        'T' => 5,
        'S' => 5,
        'W' => 5)
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

struct Vertex
    top::Int64
    left::Int64
    right::Int64
    bottom::Int64
end

# Creates a Vertex from a point (i, j) in the matrix charMat
function transform_vertex(i::Int64, j::Int64, charMat::Matrix{Char})
    # Top border case
    if (i==1)
        # Top left edge
        if (j==1) 
            return Vertex(0, 0, costs[charMat[i, j]][charMat[i, j+1]], costs[charMat[i, j]][charMat[i+1, j]])
        # Top right edge
        elseif j==size(charMat,2)
            return Vertex(0, costs[charMat[i, j]][charMat[i, j-1]], 0, costs[charMat[i, j]][charMat[i+1, j]])
        # Rest of the top border
        else
            return Vertex(0, costs[charMat[i, j]][charMat[i, j-1]], costs[charMat[i, j]][charMat[i, j+1]], costs[charMat[i, j]][charMat[i+1, j]])
        end
    # Bottom border case
    elseif (i==size(charMat,1))
        # Bottom left edge
        if (j==1) 
            return Vertex(costs[charMat[i, j]][charMat[i-1, j]], 0, costs[charMat[i, j]][charMat[i, j+1]], 0)
        # Bottom right edge
        elseif j==size(charMat,2)
            return Vertex(costs[charMat[i, j]][charMat[i-1, j]], costs[charMat[i, j]][charMat[i, j-1]], 0, 0)
        # Rest of the bottom border
        else
            return Vertex(costs[charMat[i, j]][charMat[i-1, j]], costs[charMat[i, j]][charMat[i, j-1]], costs[charMat[i, j]][charMat[i, j+1]], 0)
        end
    # Left border except top and bottom left edges (treated before)
    elseif (j==1)
        return Vertex(costs[charMat[i, j]][charMat[i-1, j]], 0, costs[charMat[i, j]][charMat[i, j+1]], costs[charMat[i, j]][charMat[i+1, j]])
    # Right border except top and bottom right edges (treated before)
    elseif (j==size(charMat,2))
        return Vertex(costs[charMat[i, j]][charMat[i-1, j]], costs[charMat[i, j]][charMat[i, j-1]], 0, costs[charMat[i, j]][charMat[i+1, j]])
    # Other cases
    else
        return Vertex(costs[charMat[i, j]][charMat[i-1, j]], costs[charMat[i, j]][charMat[i, j-1]], costs[charMat[i, j]][charMat[i, j+1]], costs[charMat[i, j]][charMat[i+1, j]])
    end
end

# Transforming a map to a matrix of Vertices
function map_to_vertices(charMat::Matrix{Char})
    vertices = Matrix{Vertex}(undef, size(charMat, 1), size(charMat, 2))
    for i in 1:size(charMat, 1)
        for j in 1:size(charMat, 2)
            vertices[i, j] = transform_vertex(i, j, charMat)
        end
    end
    return vertices
end

function min_dist_vert(distances::Matrix{Int64}, uncovered_nodes::Matrix{Bool})
    min_dist::Int64 = typemax(Int64)
    min_x, min_y = 0, 0
    for i in 1:size(distances, 1)
        for j in 1:size(distances, 2)
            if distances[i, j] < min_dist && uncovered_nodes[i, j] == false
                min_dist = distances[i, j]
                min_x, min_y = i, j
            end
        end
    end
    return min_x, min_y
end

# Function that updates the distance values of the neighbouring node at index (i, j)
function update_distances(distances::Matrix{Int64}, uncovered_nodes::Matrix{Bool}, graph::Matrix{Vertex}, i::Int64, j::Int64)
    # top neighbour
    if graph[i, j].top > 0 && uncovered_nodes[i-1, j] == false && distances[i-1, j] > distances[i, j] + graph[i, j].top
        distances[i-1, j] = distances[i, j] + graph[i, j].top
    end
    # left neighbour
    if graph[i, j].left > 0 && uncovered_nodes[i, j-1] == false && distances[i, j-1] > distances[i, j] + graph[i, j].left
        distances[i, j-1] = distances[i, j] + graph[i, j].left
    end
    # right neighbour
    if graph[i, j].right > 0 && uncovered_nodes[i, j+1] == false && distances[i, j+1] > distances[i, j] + graph[i, j].right
        distances[i, j+1] = distances[i, j] + graph[i, j].right
    end
    # bottom neighbour
    if graph[i, j].bottom > 0 && uncovered_nodes[i+1, j] == false && distances[i+1, j] > distances[i, j] + graph[i, j].bottom
        distances[i+1, j] = distances[i, j] + graph[i, j].bottom
    end
    return distances
end

function updated_dijkstra(graph::Matrix{Vertex}, start_x::Int64, start_y::Int64, finish_x::Int64, finish_y::Int64)
    # None of the nodes have been visited at the beginning
    uncovered_nodes::Matrix{Bool} = [false for i in 1:size(graph,1), j in 1:size(graph,2)]
    # Infinite distance between the start and other nodes for now
    distances::Matrix{Int64} = [typemax(Int64) for i in 1:size(graph,1), j in 1:size(graph,2)]
    distances[start_x, start_y] = 0

    # arbitrary value
    min_x, min_y = 1, 1
    # Until the path to the finish hasn't been found or if there are no more visitable nodes, we iterate
    while uncovered_nodes[finish_x, finish_y] == false || (min_x==0 && min_y==0)
        # Getting the index of the unvisited and closest node to the starting point
        min_x, min_y = min_dist_vert(distances, uncovered_nodes)

        # Update the distances of the pixels around the pixel at index (min_x, min_y) 
        distances = update_distances(distances, uncovered_nodes, graph, min_x, min_y)
        # marking the node we just worked around as visited
        uncovered_nodes[min_x, min_y] = true
    end

    println("Distance from vertex (",start_x, ", ", start_y, ") to vertex (", finish_x, ", ", finish_y, "): ", distances[finish_x, finish_y])
end

# Testing
function main()
    # .T@
    # @.@
    # TT.
    # SHortest path is [1,1] -> [1,2] -> [2,2] -> [3,2] -> [3,3]
    # Cost of 12

    test_graph::Matrix{Vertex} = [
        Vertex(0, 0, 3, 0) Vertex(0, 3, 0, 3) Vertex(0, 0, 0, 0);
        Vertex(0, 0, 0, 0) Vertex(3, 0, 0, 3) Vertex(0, 0, 0, 0);
        Vertex(0, 0, 5, 0) Vertex(3, 5, 3, 0) Vertex(0, 3, 0, 0)
    ]
    # Find the shortest path to go from top left (1,1) pixel to bottom right pixel (3,3)
    updated_dijkstra(test_graph, 1, 1, 3, 3)


    # Test using an actual .map file
    # Transform the .map file into a matrix of Char
    mapChar::Matrix{Char} = map_to_matrix("arena.map")
    # Transform a Char matrix into a matrix of vertices, corresponding to the graph of the map
    mapVertices::Matrix{Vertex} = map_to_vertices(mapChar)

    updated_dijkstra(mapVertices, 1, 1, 49, 49)

end