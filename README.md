# PathFinding
Implementation and optimization of pathfinding algorithms in Julia

![divideandconquer](https://user-images.githubusercontent.com/86181145/222389973-4a10acd8-4b69-4486-960f-fcb203cd2aef.png)

Update:
As we are working on finding a path on a map, using the general way of using dijkstra with matrices wouldn't be efficient.
For example, a 3x3 map contains 9 pixels and each pixels can either go left, right, top or bottom, so there are only 4 possibles vertices to each node.
A classical approach would require a 9x9 matrix for the costs, with a lot of of unecessary zeros (pixel (1,1) could never reach (3,3) in one move) 

