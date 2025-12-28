extends Node2D

@onready var collision_area: Area2D = $Area2D

# Patrol configuration
var waypoints: Array[Vector2i] = []
var current_waypoint_index: int = 0
var grid_position: Vector2i = Vector2i(2, 2)
const TILE_SIZE: int = 64

signal player_caught

func _ready() -> void:
	collision_area.body_entered.connect(_on_body_entered)
	collision_area.area_entered.connect(_on_area_entered)

func initialize(start_pos: Vector2i, patrol_waypoints: Array[Vector2i]) -> void:
	"""Set up enemy starting position and patrol route"""
	grid_position = start_pos
	waypoints = patrol_waypoints
	current_waypoint_index = 0
	position = grid_to_world(grid_position)
	print("Enemy initialized at: ", grid_position)
	print("Patrol waypoints: ", waypoints)

func move_toward_waypoint() -> void:
	"""Move one step toward the current waypoint"""
	if waypoints.is_empty():
		return

	var target = waypoints[current_waypoint_index]
	var direction = Vector2i.ZERO

	# Calculate direction to target (one axis at a time)
	if grid_position.x < target.x:
		direction = Vector2i.RIGHT
	elif grid_position.x > target.x:
		direction = Vector2i.LEFT
	elif grid_position.y < target.y:
		direction = Vector2i.DOWN
	elif grid_position.y > target.y:
		direction = Vector2i.UP

	# Move if we have a direction
	if direction != Vector2i.ZERO:
		grid_position += direction
		position = grid_to_world(grid_position)
		print("Enemy moved to: ", grid_position)

	# Check if reached waypoint
	if grid_position == target:
		advance_waypoint()

func advance_waypoint() -> void:
	"""Move to next waypoint in patrol route"""
	current_waypoint_index = (current_waypoint_index + 1) % waypoints.size()
	print("Enemy reached waypoint, next target: ", waypoints[current_waypoint_index])

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	"""Convert grid coordinates to world position"""
	return Vector2(grid_pos.x * TILE_SIZE + TILE_SIZE / 2, grid_pos.y * TILE_SIZE + TILE_SIZE / 2)

func _on_body_entered(body: Node2D) -> void:
	check_player_collision()

func _on_area_entered(area: Area2D) -> void:
	check_player_collision()

func check_player_collision() -> void:
	"""Check if player collided with enemy"""
	print("Enemy collision detected!")
	player_caught.emit()
