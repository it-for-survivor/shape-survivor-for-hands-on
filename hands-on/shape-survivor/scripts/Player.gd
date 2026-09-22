extends CharacterBody2D

@export var speed: float = 220.0
@export var radius: float = 16.0

func _ready() -> void:
	# 見た目の半径(radius)と当たり判定の半径がズレないよう、コードから同期する
	($CollisionShape2D.shape as CircleShape2D).radius = radius

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE)

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed
	move_and_slide()
