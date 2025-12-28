extends Node2D

@onready var label: Label = $Label
@onready var collision_area: Area2D = $CollisionArea

var number_value: int = 0
var is_correct: bool = false

signal collected(planet: Node2D)

func _ready() -> void:
	collision_area.body_entered.connect(_on_body_entered)
	collision_area.area_entered.connect(_on_area_entered)

func initialize(value: int, correct: bool, grid_pos: Vector2i) -> void:
	"""Set up the planet with number value and position"""
	number_value = value
	is_correct = correct
	$Label.text = str(value)

	# Position at grid location (centered)
	const TILE_SIZE = 64
	position = Vector2(grid_pos.x * TILE_SIZE + TILE_SIZE / 2, grid_pos.y * TILE_SIZE + TILE_SIZE / 2)

	# Visual feedback for correct numbers (optional)
	if is_correct:
		modulate = Color(0.2, 0.8, 0.3)  # Green tint

func _on_body_entered(body: Node2D) -> void:
	# Detect player collision (if using CharacterBody2D)
	check_collection()

func _on_area_entered(area: Area2D) -> void:
	# Alternative detection method
	check_collection()

func check_collection() -> void:
	"""Trigger collection and remove planet"""
	collected.emit(self)
	queue_free()
