extends TileMap

# Map size (30x40)
const MAP_WIDTH = 30
const MAP_HEIGHT = 40
var fill_percentage = 0.96
const SEED_VALUE = 3605435

# Tile indices (assuming 0 = wall and 1 = path)
const WALL_TILE = 1
const PATH_TILE = 0

# Map array
var map_grid : Array = []
var frontier : Array = []
var visited : Array = []

# Start position for the random walk
var start_x : int = 15
var start_y : int = 20

func _ready():
	rand_seed(SEED_VALUE)
	# Initialize map with walls
	initialize_map()
	# Generate the pathways using a random walk
	generate_random_walk_with_target_fill()
	# Optional: Ensure connectivity (flood fill, etc.)
	remove_1x1_holes()
	# Draw the generated map to the TileMap
	print(map_grid)
	draw_map()
	
	update_bitmask_region()

# Initialize map with walls
func initialize_map():
	map_grid = []
	for y in range(MAP_HEIGHT):
		var row = []
		for x in range(MAP_WIDTH):
			row.append(WALL_TILE)  # Initially, all tiles are walls
		map_grid.append(row)

# Generate random walk while filling only the desired percentage of the map
func generate_random_walk_with_target_fill():
	var x = randi() % MAP_WIDTH - 1
	var y = randi() % MAP_HEIGHT - 1
	map_grid[y][x] = PATH_TILE

	var steps = 0
	while steps < (MAP_HEIGHT * MAP_WIDTH * fill_percentage) :  # We want to fill up to the target fill count
		var direction = Vector2(randi() % 3 - 1, randi() % 3 - 1)
		x += direction.x
		y += direction.y
		x = clamp(x, 0, MAP_WIDTH - 1)
		y = clamp(y, 0, MAP_HEIGHT - 1)
		
		if map_grid[y][x] != PATH_TILE:  # Only carve if the tile is still a wall
			map_grid[y][x] = PATH_TILE
			steps += 1

# Ensure the map is fully connected
func ensure_connectivity():
	# Implement a flood fill or DFS to check for connectivity
	var visited = Array()
	for y in range(MAP_HEIGHT):
		visited.append([])
		for x in range(MAP_WIDTH):
			visited[y].append(false)
	
	# Start flood fill from a random starting position (where path is)
	var start_pos = Vector2(start_x, start_y)
	flood_fill(start_pos, visited)

	# If any tile is not visited, convert it into a path
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			if visited[y][x] == false:
				map_grid[y][x] = PATH_TILE  # Make the tile a path if not visited

# Remove 1x1 isolated holes (wall tiles surrounded by paths)
func remove_1x1_holes():
	for y in range(1, MAP_HEIGHT - 1):  # Skip the border tiles
		for x in range(1, MAP_WIDTH - 1):  # Skip the border tiles
			# Check if this tile is a wall and is surrounded by paths
			if map_grid[y][x] == WALL_TILE:
				if map_grid[y-1][x] == PATH_TILE and map_grid[y+1][x] == PATH_TILE and map_grid[y][x-1] == PATH_TILE and map_grid[y][x+1] == PATH_TILE:
					map_grid[y][x] = PATH_TILE  # Convert it to a path tile

# Prim's Algorithm for ensuring connectivity (spanning tree)
func ensure_connectivity_using_prims():
	# Initialize frontier with neighboring tiles of the first path
	frontier.clear()
	visited.clear()
	for y in range(MAP_HEIGHT):
		visited.append([])
		for x in range(MAP_WIDTH):
			visited[y].append(false)
	
	# Start with a random path tile
	var start_x = randi() % (MAP_WIDTH - 10)
	var start_y = randi() % (MAP_HEIGHT - 10)
	visited[start_y][start_x] = true
	frontier.push_back(Vector2(start_x, start_y))
	map_grid[start_y][start_x] = PATH_TILE

	# Run Prim's algorithm to ensure connectivity
	while frontier.size() > 0:
		var current_pos = frontier.pop_back()
		var cx = current_pos.x
		var cy = current_pos.y
		
		# Check the 4 neighboring tiles (up, down, left, right)
		var neighbors = [
			Vector2(cx - 1, cy),  # Left
			Vector2(cx + 1, cy),  # Right
			Vector2(cx, cy - 1),  # Up
			Vector2(cx, cy + 1)   # Down
		]

		for neighbor in neighbors:
			var nx = neighbor.x
			var ny = neighbor.y
			if nx >= 0 and nx < MAP_WIDTH and ny >= 0 and ny < MAP_HEIGHT and !visited[ny][nx]:
				visited[ny][nx] = true
				frontier.push_back(neighbor)
				map_grid[ny][nx] = PATH_TILE

# Flood fill (DFS) to mark connected tiles
func flood_fill(position : Vector2, visited : Array):
	var stack = [position]
	while stack.size() > 0:
		var current = stack.pop_back()
		var cx = current.x
		var cy = current.y
		
		# Skip if already visited or it's not a path
		if visited[cy][cx] or map_grid[cy][cx] != PATH_TILE:
			continue
		
		visited[cy][cx] = true
		
		# Add neighboring tiles to the stack (up, down, left, right)
		var neighbors = [
			Vector2(cx - 1, cy),  # Left
			Vector2(cx + 1, cy),  # Right
			Vector2(cx, cy - 1),  # Up
			Vector2(cx, cy + 1)   # Down
		]
		
		for neighbor in neighbors:
			if neighbor.x >= 0 and neighbor.x < MAP_WIDTH and neighbor.y >= 0 and neighbor.y < MAP_HEIGHT:
				stack.append(neighbor)

# Draw the map to the TileMap
func draw_map():
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			set_cell(x, y, map_grid[y][x])  # Set each tile on the TileMap based on map_grid

