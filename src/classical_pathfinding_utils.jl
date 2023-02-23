# Implementation of pathfinding algorithms for classical approaches

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


function main()
    test1::Matrix{Int64} = [
        0 2 4 0;
        1 0 1 7;
        0 0 0 4;
        0 0 1 0;
    ]

    dijkstra(test1, 1, 4)
end