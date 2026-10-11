extends Area2D

@export var exp_value: int = 1
@export var attract_speed: float = 260.0
@export var attract_radius: float = 90.0

var _target: Node2D

func _ready() -> void:
	_target = get_tree().get_first_node_in_group("player")
	body_entered.connect(_on_body_entered)

func _draw() -> void:
	var points := PackedVector2Array([Vector2(0, -7), Vector2(7, 0), Vector2(0, 7), Vector2(-7, 0)])
	draw_colored_polygon(points, Color(0.62, 0.88, 0.62))

func _physics_process(delta: float) -> void:
	if is_instance_valid(_target) and global_position.distance_to(_target.global_position) < attract_radius:
		global_position = global_position.move_toward(_target.global_position, attract_speed * delta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("gain_exp"):
		body.gain_exp(exp_value)
		queue_free()
