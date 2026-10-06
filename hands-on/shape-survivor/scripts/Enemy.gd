extends CharacterBody2D

@export var speed: float = 90.0

var _target: Node2D

func _ready() -> void:
	add_to_group("enemy")
	_target = get_tree().get_first_node_in_group("player")
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(1)
		# body_enteredは物理ステップ中に呼ばれるため、即queue_free()すると
		# "Can't change this state while flushing queries" エラーになる。
		# call_deferred()で安全なタイミングまで削除を遅らせる。
		call_deferred("queue_free")

func _draw() -> void:
	var points := PackedVector2Array([Vector2(0, -14), Vector2(12, 10), Vector2(-12, 10)])
	draw_colored_polygon(points, Color(1.0, 0.62, 0.72))

func _physics_process(_delta: float) -> void:
	if is_instance_valid(_target):
		velocity = (_target.global_position - global_position).normalized() * speed
		move_and_slide()
