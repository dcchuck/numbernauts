extends Node2D

# Scene references
const PLAYER_SCENE = preload("res://scenes/Player.tscn")

# Entity references
var player: Node2D

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
	"""Convert grid coordinates to world pixel position"""
	return Vector2(grid_pos.x * TILE_SIZE, grid_pos.y * TILE_SIZE)

func world_to_grid(world_pos: Vector2) -> Vector2i:
	"""Convert world pixel position to grid coordinates"""
	return Vector2i(int(world_pos.x / TILE_SIZE), int(world_pos.y / TILE_SIZE))

func is_valid_grid_position(grid_pos: Vector2i) -> bool:
	"""Check if grid position is within bounds"""
	return grid_pos.x >= 0 and grid_pos.x < GRID_SIZE and grid_pos.y >= 0 and grid_pos.y < GRID_SIZE
