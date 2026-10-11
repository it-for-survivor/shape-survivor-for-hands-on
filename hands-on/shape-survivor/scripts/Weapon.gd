extends Node2D

@export var fire_interval: float = 0.6:
	set(value):
		fire_interval = value
		if _timer:
			_timer.wait_time = value
@export var bullet_scene: PackedScene

@onready var _owner_node: Node2D = get_parent() as Node2D

var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.wait_time = fire_interval
	_timer.autostart = true
	_timer.timeout.connect(_on_timeout)
	add_child(_timer)

func _on_timeout() -> void:
	var target := _find_nearest_enemy()
	if target == null or not bullet_scene:
		return
	var bullet := bullet_scene.instantiate()
	bullet.global_position = _owner_node.global_position
	bullet.direction = (target.global_position - _owner_node.global_position).normalized()
	get_tree().current_scene.add_child(bullet)

func _find_nearest_enemy() -> Node2D:
	var enemies := get_tree().get_nodes_in_group("enemy")
	var nearest: Node2D = null
	var nearest_dist := INF
	for e in enemies:
		var d := _owner_node.global_position.distance_squared_to(e.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = e
	return nearest
