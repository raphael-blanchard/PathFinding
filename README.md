# PathFinding
Implementation and optimization of pathfinding algorithms in Julia for standardized maps available [here](https://movingai.com/benchmarks/grids.html)

## Examples
Path found with Dijkstra (left) and A* using the Manhattan distance (right):
<p float="left">
  <img src="https://user-images.githubusercontent.com/86181145/222896405-7adad3cb-19c5-406c-90b2-ac16be1110dd.png" width="49%" height="49%">
  <img src="https://user-images.githubusercontent.com/86181145/222896324-29b188d6-a9ea-4a2d-9bc8-e1fbb39604e9.png" width="49%" height="49%">
</p>

## 
Update:
As we are working on finding a path on a map, using the general way of using dijkstra with matrices wouldn't be efficient.
For example, a 3x3 map contains 9 pixels and each pixels can either go left, right, top or bottom, so there are only 4 possibles vertices to each node.
A classical approach would require a 9x9 matrix for the costs, with a lot of of unecessary zeros (pixel (1,1) could never reach (3,3) in one move) 

