extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 1.5
@export var spawn_radius: float = 480.0

var _player: Node2D
var _timer: Timer

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")
	_timer = Timer.new()
	_timer.wait_time = spawn_interval
	_timer.autostart = true
	_timer.timeout.connect(_on_timeout)
	add_child(_timer)

func _on_timeout() -> void:
	if not is_instance_valid(_player) or not enemy_scene:
		return
	var angle := randf() * TAU
	var offset := Vector2.RIGHT.rotated(angle) * spawn_radius
	var enemy := enemy_scene.instantiate()
	enemy.global_position = _player.global_position + offset
	get_tree().current_scene.add_child(enemy)
