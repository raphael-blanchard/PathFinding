# PathFinding
Implementation and optimization of pathfinding algorithms in Julia for standardized maps available [here](https://movingai.com/benchmarks/grids.html).

## Installation
[<img src="https://img.shields.io/badge/Julia-1.8.5-purple">](https://julialang.org/downloads/)
[<img src="https://img.shields.io/badge/DataStructures-v0.18.13-red">](https://github.com/JuliaCollections/DataStructures.jl)
[<img src="https://img.shields.io/badge/PyPlot-v2.11.0-blue">](https://github.com/JuliaPy/PyPlot.jl)
[<img src="https://img.shields.io/badge/Images-v0.25.2-brightgreen">](https://github.com/JuliaImages/Images.jl)

```bash
git clone https://github.com/raphael-blanchard/PathFinding.git
```
Change your current directory to the parent folder of the project by doing
```bash
cd PathFinding
```
(If you downloaded the project as a zip, the parent folder will be called PathFinding-main)

## Getting Started
When in the Julia REPL, download the necessary packages by running the following command in the Pkg mode:

```julia
add DataStructures, PyPlot, Images
```
## Usage
Including this file will take care of anything that needs to be precompiled to make the algorithms work.
```julia
include("./src/simulation.jl")
```
You can now use A* and/or Dijkstra to find the shortest path between two points in a given map by doing:

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
A* on the left, Dijkstra on the right.
The orange pixels correspond to the visited points of the map.

fname = "arena.map"; D = (2, 4); A = (48, 45)
<p float="left">
  <img src="https://user-images.githubusercontent.com/86181145/224813595-d63ece4a-3950-4e8f-84fe-28151eb33717.png" width="8%" height="8%">
  <img src="https://user-images.githubusercontent.com/86181145/224813609-81ff7e1c-fb09-466c-8540-33ecd3e21065.png" width="8%" height="8%">
</p>

fname = "divideandconquer.map"; D = (49, 64); A = (450, 450)
<p float="left">
  <img src="https://user-images.githubusercontent.com/86181145/224407166-7d70f280-b687-4e1f-8e57-15514c7d7221.png" width="49%" height="49%">
  <img src="https://user-images.githubusercontent.com/86181145/224407052-3891dbb5-869f-4c00-8923-b8a29de6014a.png" width="49%" height="49%">
</p>

fname = "Expedition.map"; D = (80, 150); A = (853, 926)
<p float="left">
  <img src="https://user-images.githubusercontent.com/86181145/224814376-6a40fe64-0b4d-4e10-8057-2fe4e969a401.png" width="49%" height="49%">
  <img src="https://user-images.githubusercontent.com/86181145/224814420-84444fcc-f868-4d17-ba50-3c32b5d8cdab.png" width="49%" height="49%">
</p>




