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

var current_direction: String = "down"

func _ready() -> void:
	# Create collision detection area
	detection_area = Area2D.new()
	add_child(detection_area)

	var collision_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 24
	collision_shape.shape = circle
	detection_area.add_child(collision_shape)

	# Position at grid location (using main's conversion if available)
	if main_node:
		position = main_node.grid_to_world(grid_position)

	# Set initial frame but don't animate (resting state)
	$AnimatedSprite2D.animation = current_direction
	$AnimatedSprite2D.stop()

func initialize(start_pos: Vector2i, main_ref: Node2D) -> void:
	"""Set starting position and main reference"""
	grid_position = start_pos
	main_node = main_ref
	if main_node:
		position = main_node.grid_to_world(grid_position)
		scale = Vector2(main_node.SPRITE_SCALE, main_node.SPRITE_SCALE)

func update_animation(direction: Vector2i) -> void:
	"""Update and play animation based on movement direction"""
	if direction.y > 0:
		current_direction = "down"
	elif direction.y < 0:
		current_direction = "up"
	elif direction.x < 0:
		current_direction = "left"
	elif direction.x > 0:
		current_direction = "right"

	$AnimatedSprite2D.play(current_direction)

func stop_animation() -> void:
	"""Stop animation and hold current frame (resting state)"""
	$AnimatedSprite2D.stop()

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
		# Update animation based on movement direction
		update_animation(direction)

		grid_position = new_position
		is_moving = true
		can_move = false

		# Animate to new position
		var target_pos = main_node.grid_to_world(grid_position)
		var tween = create_tween()
		tween.tween_property(self, "position", target_pos, 1.0 / move_speed)
		tween.finished.connect(_on_move_finished)

func _on_move_finished() -> void:
	is_moving = false
	can_move = true
	stop_animation()  # Return to resting state
	moved.emit(grid_position)
	print("Player moved to: ", grid_position)
