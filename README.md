# PathFinding
Implementation and optimization of pathfinding algorithms in Julia for standardized maps available [here](https://movingai.com/benchmarks/grids.html).


## Getting Started
Download the necessary packages by running the following command in the Julia REPL Pkg mode:

```julia
add DataStructures, PyPlot, Images
```
## Usage
Including this file will take care of anything that needs to be precompiled to make the algorithms work.
```julia
include("./src/simulation.jl")
```
Execute the algorithms by doing:

```julia
algoDijkstra(fname, D, A)
algoAstar(fname, D, A)
```
where:
- fname, the file of the map you want to execute the algorithms on; variable of type String (e.g. "divideandconquer.map").
- D and A, respectively the starting and ending points; variables of type Tuple{Int64, Int64} (e.g (12, 14)).

## Benchmarks
Here are 2 different benchmarks on 2 different machines on 3 maps:
### (1) - Ryzen 5600X (Windows 10)
|         filename       |    D    |    A    |  map size | avg. execution time | nb. allocations | allocated (in MiB) | distance | visited states |
| ---------------------- | ------- | ------- | --------- | ------------------  | --------------- | ------------------ | -------- | -------------- |         
|        "arena.map"     | (12,12) | (12,12) |   49x49   | Content Cell        |                 |                    | 1561     | 13994248       |
| "divideandconquer.map" | (12,12) | (12,12) |  512x512  | Content Cell        |                 |                    | 1561     | 13994248       |
|    "Exepedition.map"   | (12,12) | (12,12) | 1024x1024 | Content Cell        |                 |                    | 1561     | 13994248       |

### (2) - MBP 2019
|         filename       |    D    |    A    |  map size | avg. execution time | nb. allocations | allocated (in MiB) | distance | visited states |
| ---------------------- | ------- | ------- | --------- | ------------------  | --------------- | ------------------ | -------- | -------------- |         
|        "arena.map"     | (12,12) | (12,12) |   49x49   | Content Cell        |                 |                    | 1561     | 13994248       |
| "divideandconquer.map" | (12,12) | (12,12) |  512x512  | Content Cell        |                 |                    | 1561     | 13994248       |
|    "Exepedition.map"   | (12,12) | (12,12) | 1024x1024 | Content Cell        |                 |                    | 1561     | 13994248       |

## Examples
Path found with Dijkstra (left) and A* using the Manhattan distance (right):
<p float="left">
  <img src="https://user-images.githubusercontent.com/86181145/222896405-7adad3cb-19c5-406c-90b2-ac16be1110dd.png" width="49%" height="49%">
  <img src="https://user-images.githubusercontent.com/86181145/222896324-29b188d6-a9ea-4a2d-9bc8-e1fbb39604e9.png" width="49%" height="49%">
</p>
