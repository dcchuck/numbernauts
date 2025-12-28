extends Node2D

# Grid properties
var grid_position: Vector2i = Vector2i(0, 0)
const TILE_SIZE: int = 64
var can_move: bool = true

# Movement animation
var is_moving: bool = false
var move_speed: float = 8.0  # Grid spaces per second

# Reference to main game
var main_node: Node2D

# Add Area2D for detecting collectibles
var detection_area: Area2D

signal moved(new_position: Vector2i)
signal number_collected(value: int)

func _ready() -> void:
	# Create collision detection area
	detection_area = Area2D.new()
	add_child(detection_area)

	var collision_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 24
	collision_shape.shape = circle
	detection_area.add_child(collision_shape)

	# Position at grid location
	position = grid_to_world(grid_position)

func initialize(start_pos: Vector2i, main_ref: Node2D) -> void:
	"""Set starting position and main reference"""
	grid_position = start_pos
	main_node = main_ref
	position = grid_to_world(grid_position)

func _input(event: InputEvent) -> void:
	if not can_move:
		return

	var direction: Vector2i = Vector2i.ZERO

	if event.is_action_pressed("ui_right"):
		direction = Vector2i.RIGHT
	elif event.is_action_pressed("ui_left"):
		direction = Vector2i.LEFT
	elif event.is_action_pressed("ui_up"):
		direction = Vector2i.UP
	elif event.is_action_pressed("ui_down"):
		direction = Vector2i.DOWN

	if direction != Vector2i.ZERO:
		attempt_move(direction)

func attempt_move(direction: Vector2i) -> void:
	if is_moving:
		return  # Don't allow movement while animating

	var new_position = grid_position + direction

	# Check bounds using main's validation
	if main_node and main_node.is_valid_grid_position(new_position):
		grid_position = new_position
		is_moving = true
		can_move = false

		# Animate to new position
		var target_pos = grid_to_world(grid_position)
		var tween = create_tween()
		tween.tween_property(self, "position", target_pos, 1.0 / move_speed)
		tween.finished.connect(_on_move_finished)

func _on_move_finished() -> void:
	is_moving = false
	can_move = true
	moved.emit(grid_position)
	print("Player moved to: ", grid_position)

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	"""Convert grid coordinates to world position"""
	return Vector2(grid_pos.x * TILE_SIZE + TILE_SIZE / 2, grid_pos.y * TILE_SIZE + TILE_SIZE / 2)
