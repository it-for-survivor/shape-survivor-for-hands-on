extends Area2D

@export var speed: float = 420.0
@export var lifetime: float = 1.5

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _draw() -> void:
	draw_rect(Rect2(-4, -4, 8, 8), Color(1.0, 0.92, 0.55))

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# 弾はプレイヤーの位置で生成されるため、発射直後にプレイヤー自身と重なって
	# 判定してしまう。敵以外に当たっても消えないようにする。
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(1)
		call_deferred("queue_free")
