# Libraries
using DataStructures


# Function that updates the distance values of the neighbouring node at index (i, j)
function update_distances(distances::Matrix{Int64}, uncovered_nodes::Matrix{Bool}, graph::Matrix{Vertex}, i::Int64, j::Int64, parents::Matrix{Tuple{Int64, Int64}}, pq, node_count::Int64)
    # top neighbour
    count = 0
    if graph[i, j].top > 0 && uncovered_nodes[i-1, j] == false && distances[i-1, j] > distances[i, j] + graph[i, j].top
        parents[i-1, j] = (i, j)
        distances[i-1, j] = distances[i, j] + graph[i, j].top
        if (haskey(pq, (i-1,j)))
            delete!(pq, (i-1,j))
        end
        enqueue!(pq, (i-1, j), distances[i-1, j])
        count += 1
    end
    # left neighbour
    if graph[i, j].left > 0 && uncovered_nodes[i, j-1] == false && distances[i, j-1] > distances[i, j] + graph[i, j].left
        parents[i, j-1] = (i, j)
        distances[i, j-1] = distances[i, j] + graph[i, j].left
        if (haskey(pq, (i,j-1)))
            delete!(pq, (i,j-1))
        end
        enqueue!(pq, (i, j-1), distances[i, j-1])
        count += 1
    end
    # right neighbour
    if graph[i, j].right > 0 && uncovered_nodes[i, j+1] == false && distances[i, j+1] > distances[i, j] + graph[i, j].right
        parents[i, j+1] = (i, j)
        distances[i, j+1] = distances[i, j] + graph[i, j].right
        if (haskey(pq, (i,j+1)))
            delete!(pq, (i,j+1))
        end
        enqueue!(pq, (i, j+1), distances[i, j+1])
        count += 1
    end
    # bottom neighbour
    if graph[i, j].bottom > 0 && uncovered_nodes[i+1, j] == false && distances[i+1, j] > distances[i, j] + graph[i, j].bottom
        parents[i+1, j] = (i, j)
        distances[i+1, j] = distances[i, j] + graph[i, j].bottom
        if (haskey(pq, (i+1,j)))
            delete!(pq, (i+1,j))
        end
        enqueue!(pq, (i+1, j), distances[i+1, j])
        count += 1
    end
    return node_count + count
end

function print_parents(parents::Matrix{Tuple{Int64, Int64}}, curr_x, curr_y)
    if (curr_x <= size(parents, 1) && curr_x >= 1 && curr_y <= size(parents,2) && curr_y>= 1)
        tmp_x, tmp_y = parents[curr_x, curr_y]
        if (tmp_x, tmp_y) != (-1,-1)
            print_parents(parents, tmp_x, tmp_y)
        end
        println(curr_x, ", ", curr_y)
    end
end

function updated_dijkstra(graph::Matrix{Vertex}, start_x::Int64, start_y::Int64, finish_x::Int64, finish_y::Int64)
    # Number of visited states
    node_count::Int64 = 1

    # Matrix that will hold the shortest path from starting point to the node (i, j)
    shortest_paths::Matrix{Vector{Tuple{Int64, Int64}}} = [[] for i in 1:size(graph, 1), j in 1:size(graph, 2)]
    shortest_paths[start_x, start_y] = [(start_x, start_y)]

    # None of the nodes have been visited at the beginning
    uncovered_nodes::Matrix{Bool} = [false for i in 1:size(graph,1), j in 1:size(graph,2)]
    # Infinite distance between the start and other nodes for now
    distances::Matrix{Int64} = [typemax(Int64) for i in 1:size(graph,1), j in 1:size(graph,2)]
    distances[start_x, start_y] = 0

    # parents matrix
    parents::Matrix{Tuple{Int64, Int64}} = [(-1,-1) for i in 1:size(graph,1), j in 1:size(graph,2)]
    parents[start_x, start_y] = (-1,-1)

    # arbitrary value
    min_x, min_y = 1, 1

    pq = PriorityQueue()
    enqueue!(pq, (start_x, start_y), 0)
    # Until the path to the finish hasn't been found or if there are no more visitable nodes, we iterate
    # while !isempty(pq)
    while uncovered_nodes[finish_x, finish_y] == false || min_x == -1 || min_y == -1
        # Getting the index of the unvisited and closest node to the starting point
        min_x, min_y = dequeue!(pq)

        # Update the distances of the pixels around the pixel at index (min_x, min_y) 
        node_count = update_distances(distances, uncovered_nodes, graph, min_x, min_y, parents, pq, node_count)
        
        # marking the node we just worked around as visited
        uncovered_nodes[min_x, min_y] = true
    end
    println("Distance from vertex (",start_x, ", ", start_y, ") to vertex (", finish_x, ", ", finish_y, "): ", distances[finish_x, finish_y])
    println("Path from (",start_x, ", ", start_y, ") to (", finish_x, ", ", finish_y, "):")
    
    # # printing path from start to end
    # print_parents(parents, finish_x, finish_y)  

    println("Number of visited nodes: ", node_count)
    
    return parents
end

function path_creation(parents::Matrix{Tuple{Int64, Int64}}, start_x::Int64, start_y::Int64, finish_x::Int64, finish_y::Int64)
    path::Vector{Tuple{Int64, Int64}} = [(finish_x, finish_y)]
    tmp_x, tmp_y = parents[finish_x, finish_y]
    while (tmp_x, tmp_y) != (-1, -1)
        push!(path, (tmp_x, tmp_y))
        tmp_x, tmp_y = parents[tmp_x, tmp_y]
    end
    return path
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
    start_x::Int64, start_y::Int64, finish_x::Int64, finish_y::Int64 = 1,1,3,3

    parents = updated_dijkstra(test_graph, start_x, start_y, finish_x, finish_y)
    path = path_creation(parents, start_x, start_y, finish_x, finish_y)
    return path
end