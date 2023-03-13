# Libraries
using DataStructures


# Transforming a map to a matrix of Int64, corresponding to the cost to arrive there
function map_to_int(charMat::Matrix{Char})
    return [cost[charMat[i, j]] for i in 1:size(charMat, 1), j in 1:size(charMat, 2)]
end

# Function that updates the distance values of the neighbouring node at index (i, j)
function update_distances_dijkstra(distances::Matrix{Int64}, uncovered_nodes::Matrix{Bool}, graph::Matrix{Int64}, i::Int64, j::Int64, finish_x::Int64, finish_y::Int64, parents::Matrix{Tuple{Int64, Int64}}, pq::PriorityQueue{Tuple{Int64, Int64}, Int64}, node_count::Int64, visited_nodes::Matrix{Bool})
    count = 0

    # left neighbour
    if j-1 >= 1 && graph[i, j-1] > 0 && uncovered_nodes[i, j-1] == false && distances[i, j-1] > distances[i, j] + graph[i, j-1]
        parents[i, j-1] = (i, j)
        distances[i, j-1] = distances[i, j] + graph[i, j-1]

        push!(pq, (i, j-1) => distances[i, j-1])
        # pq[(i, j-1)] = distances[i, j-1] + heuristic(i, j-1, finish_x, finish_y)
        if visited_nodes[i, j-1] == false
            visited_nodes[i, j-1] = true
            # Counting only the first time a node has been visited 
            count += 1
        end
    end

    # top neighbour
    if i-1 >= 1 && graph[i-1, j] > 0 && uncovered_nodes[i-1, j] == false && distances[i-1, j] > distances[i, j] + graph[i-1, j]
        # Set the parent of point (i-1, j) to (i, j)
        parents[i-1, j] = (i, j)
        # Update distance
        distances[i-1, j] = distances[i, j] + graph[i-1, j]
    
        push!(pq, (i-1, j) => distances[i-1, j])
        # pq[(i-1, j)] = distances[i-1, j] + heuristic(i-1, j, finish_x, finish_y)
        if visited_nodes[i-1, j] == false
            visited_nodes[i-1, j] = true
            count += 1
        end
    end

    # right neighbour
    if j+1 <= size(graph,2) && graph[i, j+1] > 0 && uncovered_nodes[i, j+1] == false && distances[i, j+1] > distances[i, j] + graph[i, j+1]
        parents[i, j+1] = (i, j)
        distances[i, j+1] = distances[i, j] + graph[i, j+1]

        push!(pq, (i, j+1) => distances[i, j+1])
        # pq[(i, j+1)] = distances[i, j+1] + heuristic(i, j+1, finish_x, finish_y)
        if visited_nodes[i, j+1] == false
            visited_nodes[i, j+1] = true
            count += 1
        end
    end

    # bottom neighbour
    if i+1 <= size(graph,1) && graph[i+1, j] > 0 && uncovered_nodes[i+1, j] == false && distances[i+1, j] > distances[i, j] + graph[i+1, j]
        parents[i+1, j] = (i, j)
        distances[i+1, j] = distances[i, j] + graph[i+1, j]

        push!(pq, (i+1, j) => distances[i+1, j])
        # pq[(i+1, j)] = distances[i+1, j] + heuristic(i+1, j, finish_x, finish_y)
        if visited_nodes[i+1, j] == false
            visited_nodes[i+1, j] = true
            count += 1
        end
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


function initMat(graph::Matrix{Int64}, start_x::Int64, start_y::Int64)
    distances::Matrix{Int64} = fill(99999999, size(graph,1), size(graph,2))
    distances[start_x, start_y] = 0
    return distances
end

function dijkstra(graph::Matrix{Int64}, start_x::Int64, start_y::Int64, finish_x::Int64, finish_y::Int64)
    # Number of visited states
    node_count::Int64 = 1

    # Visited nodes
    visited_nodes::Matrix{Bool} = [false for i in 1:size(graph, 1), j in 1:size(graph,2)]
    
    # Infinite distance between the start and other nodes for now
    distances = initMat(graph, start_x, start_y)

    # None of the nodes have been visited at the beginning
    uncovered_nodes::Matrix{Bool} = [false for i in 1:size(graph,1), j in 1:size(graph,2)]

    # parents matrix
    parents = Matrix{Tuple{Int64, Int64}}(undef, size(graph,1), size(graph,2))
    parents[start_x, start_y] = (-1,-1)

    # arbitrary value
    min_x, min_y = 1, 1
    
    pq::PriorityQueue{Tuple{Int64, Int64}, Int64} = PriorityQueue()
    enqueue!(pq, (start_x, start_y), 0)
    # Until the path to the finish hasn't been found or if there are no more visitable nodes, we iterate
    while uncovered_nodes[finish_x, finish_y] == false || min_x == -1 || min_y == -1
        # Getting the index of the unvisited and closest node to the starting point
        min_x, min_y = dequeue!(pq)

        # Update the distances of the pixels around the pixel at index (min_x, min_y) 
        node_count = update_distances_dijkstra(distances, uncovered_nodes, graph, min_x, min_y, finish_x, finish_y, parents, pq, node_count, visited_nodes)
        # node_count = update_distances_astar(distances, uncovered_nodes, graph, min_x, min_y, finish_x, finish_y, parents, pq, node_count)

        # marking the node we just worked around as visited
        uncovered_nodes[min_x, min_y] = true
    end
    println("Distance from point (",start_x, ", ", start_y, ") to point (", finish_x, ", ", finish_y, "): ", distances[finish_x, finish_y])
    
    # println("Path from (",start_x, ", ", start_y, ") to (", finish_x, ", ", finish_y, "):")
    # # printing path from start to end
    # print_parents(parents, finish_x, finish_y)  

    println("Number of visited nodes: ", node_count)
    
    return parents, visited_nodes
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

