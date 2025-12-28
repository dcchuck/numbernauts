extends Node2D

# Scene references
const PLAYER_SCENE = preload("res://scenes/Player.tscn")
const NUMBER_PLANET_SCENE = preload("res://scenes/NumberPlanet.tscn")

# Entity references
var player: Node2D
var planets: Array[Node2D] = []

# Grid configuration
const GRID_SIZE: int = 8
const TILE_SIZE: int = 64

# Game state
enum GameState { PLAYING, WIN, LOSE }
var current_state: GameState = GameState.PLAYING

# Challenge configuration
var target_multiple: int = 3
var correct_numbers: Array[int] = []
var collected_count: int = 0

func _ready() -> void:
	print("Numbernauts initialized")
	print("Grid: %d x %d" % [GRID_SIZE, GRID_SIZE])
	print("Tile size: %d pixels" % TILE_SIZE)
	setup_game()

func setup_game() -> void:
	current_state = GameState.PLAYING
	collected_count = 0
	correct_numbers.clear()

	# Spawn player
	spawn_player()

	# Generate collectible numbers
	generate_numbers()

func spawn_player() -> void:
	if player:
		player.queue_free()

	player = PLAYER_SCENE.instantiate()
	add_child(player)
	player.initialize(Vector2i(0, 0), self)
	player.moved.connect(_on_player_moved)

func _on_player_moved(new_position: Vector2i) -> void:
	print("Main received player move to: ", new_position)
	# TODO: Check for collectibles, move enemy

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	"""Convert grid coordinates to world pixel position (centered)"""
	return Vector2(grid_pos.x * TILE_SIZE + TILE_SIZE / 2, grid_pos.y * TILE_SIZE + TILE_SIZE / 2)

func world_to_grid(world_pos: Vector2) -> Vector2i:
	"""Convert world pixel position to grid coordinates"""
	return Vector2i(int(world_pos.x / TILE_SIZE), int(world_pos.y / TILE_SIZE))

func is_valid_grid_position(grid_pos: Vector2i) -> bool:
	"""Check if grid position is within bounds"""
	return grid_pos.x >= 0 and grid_pos.x < GRID_SIZE and grid_pos.y >= 0 and grid_pos.y < GRID_SIZE

func generate_numbers() -> void:
	"""Generate random numbers on grid, mark correct ones"""
	# Clear existing planets
	for planet in planets:
		planet.queue_free()
	planets.clear()

	# Calculate correct answers (multiples of target_multiple)
	correct_numbers.clear()
	for i in range(1, 51):
		if i % target_multiple == 0:
			correct_numbers.append(i)

	# Generate random positions for numbers
	var used_positions: Array[Vector2i] = []
	used_positions.append(Vector2i(0, 0))  # Player start position

	# Place 15-20 random numbers
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for i in range(15):
		# Get random position
		var grid_pos: Vector2i
		var attempts = 0
		while attempts < 100:
			grid_pos = Vector2i(rng.randi_range(0, GRID_SIZE - 1), rng.randi_range(0, GRID_SIZE - 1))
			if not used_positions.has(grid_pos):
				break
			attempts += 1

		if attempts >= 100:
			continue  # Skip if can't find position

		used_positions.append(grid_pos)

		# Get random number value
		var value = rng.randi_range(1, 50)
		var is_correct = (value % target_multiple == 0)

		# Spawn planet
		var planet = NUMBER_PLANET_SCENE.instantiate()
		add_child(planet)
		planet.initialize(value, is_correct, grid_pos)
		planet.collected.connect(_on_planet_collected)
		planets.append(planet)

func _on_planet_collected(planet: Node2D) -> void:
	var value = planet.number_value
	var is_correct = planet.is_correct

	print("Collected number: ", value, " (correct: ", is_correct, ")")

	if is_correct:
		collected_count += 1
		print("Correct! Collected: %d / %d" % [collected_count, correct_numbers.size()])
		# TODO: Check win condition
	else:
		print("Wrong number! Game Over")
		current_state = GameState.LOSE
		# TODO: Trigger game over
