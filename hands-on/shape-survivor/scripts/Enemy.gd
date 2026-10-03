extends CharacterBody2D

@export var speed: float = 90.0

var _target: Node2D

func _ready() -> void:
	add_to_group("enemy")
	_target = get_tree().get_first_node_in_group("player")

func _draw() -> void:
	var points := PackedVector2Array([Vector2(0, -14), Vector2(12, 10), Vector2(-12, 10)])
	draw_colored_polygon(points, Color(1.0, 0.62, 0.72))

func _physics_process(_delta: float) -> void:
	if is_instance_valid(_target):
		velocity = (_target.global_position - global_position).normalized() * speed
		move_and_slide()
