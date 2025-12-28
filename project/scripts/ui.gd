extends Control

@onready var challenge_label: Label = $ChallengeLabel
@onready var score_label: Label = $ScoreLabel
@onready var game_over_container: CenterContainer = $GameOverContainer
@onready var win_container: CenterContainer = $WinContainer
@onready var restart_button: Button = $GameOverContainer/VBoxContainer/RestartButton
@onready var win_restart_button: Button = $WinContainer/VBoxContainer/WinRestartButton

signal restart_requested

func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)
	win_restart_button.pressed.connect(_on_restart_pressed)

func update_challenge(multiple: int) -> void:
	"""Update the challenge text"""
	challenge_label.text = "Collect all multiples of %d!" % multiple

func update_score(collected: int, total: int) -> void:
	"""Update the score display"""
	score_label.text = "Collected: %d / %d" % [collected, total]

func show_game_over() -> void:
	"""Show game over screen"""
	game_over_container.visible = true
	win_container.visible = false

func show_win() -> void:
	"""Show win screen"""
	win_container.visible = true
	game_over_container.visible = false

func hide_end_screens() -> void:
	"""Hide all end game screens"""
	game_over_container.visible = false
	win_container.visible = false

func _on_restart_pressed() -> void:
	restart_requested.emit()
