extends CharacterBody2D

signal died

@export var speed: float = 220.0
@export var radius: float = 16.0
@export var max_health: int = 5

var health: int
var exp: int = 0
var level: int = 1
var exp_to_next_level: int = 5

func _ready() -> void:
	add_to_group("player")
	health = max_health
	($CollisionShape2D.shape as CircleShape2D).radius = radius

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		health = 0
		died.emit()

func gain_exp(amount: int) -> void:
	exp += amount
	if exp >= exp_to_next_level:
		_level_up()

func _level_up() -> void:
	level += 1
	exp -= exp_to_next_level
	exp_to_next_level = int(exp_to_next_level * 1.3)
	print("level up! now level ", level)

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed
	move_and_slide()
	position = position.clamp(Vector2.ZERO, Game.WORLD_SIZE)
