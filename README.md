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
Here are benchmarks on 3 maps using 2 different algorithms:
(Images are under the tables)
### (1) - A* with Manhattan Distance
|         filename       |    D    |    A    |  map size | exec. time (in sec) | nb. allocations | allocated (in MiB) | distance | visited states |
| ---------------------- | ------- | ------- | --------- | ------------------  | --------------- | ------------------ | -------- | -------------- |         
|        "arena.map"     | (2, 4)  | (48, 45)|   49x49   | 0.000663   |    65    |    0.119     |  87   | 647       |
| "divideandconquer.map" | (49, 64)|(450, 450)|  512x512 | 0.005812   |    94    |    7.381     | 789   | 19787        |
|    "Expedition.map"   |(80, 150)|(853, 926)| 1024x1024| 0.069881    |    147   |    35.099    | 1561  | 258776       |

### (2) - Dijkstra
|         filename       |    D    |    A    |  map size | exec. time (in sec) | nb. allocations | allocated (in MiB) | distance | visited states |
| ---------------------- | ------- | ------- | --------- | ------------------  | --------------- | ------------------ | -------- | -------------- |         
|        "arena.map"     | (2, 4)  | (48, 45)|   49x49   | 0.000889   |    107    |    0.140     |  87   | 2052       |
| "divideandconquer.map" | (49, 64)|(450, 450)|  512x512 | 0.033913   |    507    |    10.896     | 789   | 134798       |
|    "Expedition.map"   |(80, 150)|(853, 926)| 1024x1024| 0.166135    |    1.41 k |    46.274    | 1561  | 632718       |


## Examples
A* using the Manhattan distance (left) and with Dijkstra (right):
<p float="left">
  <img src="https://user-images.githubusercontent.com/86181145/224407166-7d70f280-b687-4e1f-8e57-15514c7d7221.png" width="49%" height="49%">
  <img src="https://user-images.githubusercontent.com/86181145/224407052-3891dbb5-869f-4c00-8923-b8a29de6014a.png" width="49%" height="49%">
</p>
fname = "divideandconquer.map"; D = (49, 64); A = (450, 450)


