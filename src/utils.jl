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

# returns index of vertex not yet explored and with the smallest distance cost
function min_dist(dist::Vector{Int64}, uncovered_nodes::Vector{Bool})
    
    min_dist::Int64 = typemax(Int64)
    min_index::Int64 = 0

    for i in 1:length(dist)
        if dist[i] < min_dist && uncovered_nodes[i] == false
            min_dist = dist[i]
            min_index = i
        end
    end
    return min_index
end

function dijkstra(graph::Matrix{Int64}, start::Int64, finish::Int64)
    # Keeps track of which node has been covered or not
    uncovered_nodes::Vector{Bool} = [false for i in 1:size(graph, 1)]
    # Keeps track of the distance from the starting point to the i-th vertex
    dist::Vector{Int64} = [typemax(Int64) for i in 1:size(graph,1)]
    dist[start] = 0
    # println(uncovered_nodes)

    # keep track of the shortest path to the end vertex
    # path_to_end::Vector{Int64} = [1]
    # path_count = 1

    for i in 1:length(dist)
        closest_vertex = min_dist(dist, uncovered_nodes)

        # Iterating through all vertices to update the distances to get from the starting vertex to the others
        for j in 1:length(dist)
            # 3 conditions to check
            # - if there is a path between the 2 vertices we're checking
            # - if the vertex we're looking at has been already visited(if yes it'd mean we already have the shortest path)
            # - 
            if graph[closest_vertex, j] > 0 && uncovered_nodes[j] == false && dist[j] > dist[closest_vertex] + graph[closest_vertex, j]
                dist[j] = dist[closest_vertex] + graph[closest_vertex, j]
                # if j == finish
                #     push!(path_to_end, closest_vertex)
                # end
            end
        end
        # Since we visited the vertex at the index closest_vertex
        uncovered_nodes[closest_vertex] = true
    end
    # for (i, j) in enumerate(dist)
    #     println("Distance from vertex ",start, " to vertex ", i, ": ", j)
    # end
    println("Distance from vertex ",start, " to vertex ", finish, ": ", dist[finish])
    # println(path_to_end)

end

# Testing
function main()

    graph1::Matrix{Int64} = [
        0 2 4 0 0 0;
        0 0 1 7 0 0;
        0 0 0 0 3 0;
        0 0 0 0 0 1;
        0 0 0 2 0 5;
        0 0 0 0 0 0
    ]

    # Test map, start = [1, 1] / finish = [6, 3]
    # ......
    # @.....
    # @@....
    # .@....
    # .@TTTT
    # .@....

    test_graph::Matrix{Char} = map_to_matrix("Berlin_0_256.map")

    test_vert::Matrix{Vertex} = map_to_vertices(test_graph)

    @show test_graph

    @show (test_vert)

    # @show test_graph
    # println(graph2)
    # dijkstra(test_graph, 1, 6)

    # test::Vertex = Vertex(1, 2, 3, 4)
end