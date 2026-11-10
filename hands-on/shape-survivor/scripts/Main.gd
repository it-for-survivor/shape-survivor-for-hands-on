extends Node2D

@onready var player: Node2D = $Player
@onready var game_over_label: Label = $UI/GameOverLabel
@onready var level_up_panel: Control = $UI/LevelUpPanel
@onready var speed_button: Button = $UI/LevelUpPanel/VBoxContainer/SpeedButton
@onready var fire_rate_button: Button = $UI/LevelUpPanel/VBoxContainer/FireRateButton
@onready var max_health_button: Button = $UI/LevelUpPanel/VBoxContainer/MaxHealthButton


func _ready() -> void:
	player.died.connect(_on_player_died)
	player.leveled_up.connect(_on_player_leveled_up)
	game_over_label.visible = false
	level_up_panel.visible = false
	speed_button.pressed.connect(_on_upgrade_chosen.bind("speed"))
	fire_rate_button.pressed.connect(_on_upgrade_chosen.bind("fire_rate"))
	max_health_button.pressed.connect(_on_upgrade_chosen.bind("max_health"))

func _on_player_died() -> void:
	game_over_label.visible = true
	get_tree().paused = true

func _on_player_leveled_up() -> void:
	level_up_panel.visible = true
	get_tree().paused = true
	# マウスなしで矢印キー+Enter/Spaceだけで選択できるよう、最初の選択肢にフォーカスする
	speed_button.grab_focus()

func _on_upgrade_chosen(upgrade_id: String) -> void:
	player.apply_upgrade(upgrade_id)
	level_up_panel.visible = false
	get_tree().paused = false
