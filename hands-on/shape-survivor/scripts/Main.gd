extends Node2D

@onready var player: Node2D = $Player
@onready var game_over_label: Label = $UI/GameOverLabel

func _ready() -> void:
	player.died.connect(_on_player_died)
	game_over_label.visible = false

func _on_player_died() -> void:
	game_over_label.visible = true
	get_tree().paused = true
