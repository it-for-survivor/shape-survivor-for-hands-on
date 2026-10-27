extends CharacterBody2D

@export var speed: float = 90.0
@export var max_health: int = 2
@export var exp_gem_scene: PackedScene

var _target: Node2D
var health: int
var _is_dying: bool = false

func _ready() -> void:
	add_to_group("enemy")
	health = max_health
	_target = get_tree().get_first_node_in_group("player")
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		_die()

func _die() -> void:
	# 同一フレーム内に複数のダメージ源(弾+接触など)が重なると_die()が
	# 二重に呼ばれ、ジェムが二重にドロップしてしまうことがあるため、
	# 一度死亡処理を始めたら以降の呼び出しは無視するガードを入れる。
	if _is_dying:
		return
	_is_dying = true
	# body_enteredなど物理ステップ中のコールバックから呼ばれることがあるため、
	# ジェムの追加もqueue_free()もまとめて安全なタイミングまで遅延させる。
	call_deferred("_die_deferred")

func _die_deferred() -> void:
	if exp_gem_scene:
		var gem := exp_gem_scene.instantiate()
		gem.global_position = global_position
		get_tree().current_scene.add_child(gem)
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(1)
		# body_enteredは物理ステップ中に呼ばれるため、即queue_free()すると
		# "Can't change this state while flushing queries" エラーになる。
		# call_deferred()で安全なタイミングまで削除を遅らせる。
		_die()

func _draw() -> void:
	var points := PackedVector2Array([Vector2(0, -14), Vector2(12, 10), Vector2(-12, 10)])
	draw_colored_polygon(points, Color(1.0, 0.62, 0.72))

func _physics_process(_delta: float) -> void:
	if is_instance_valid(_target):
		velocity = (_target.global_position - global_position).normalized() * speed
		move_and_slide()
