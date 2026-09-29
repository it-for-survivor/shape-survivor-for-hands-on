extends Node2D

@export var cell_size: float = 100.0
@export var base_color: Color = Color(0.07, 0.07, 0.09)
@export var line_color: Color = Color(0.55, 0.7, 0.85, 0.35)

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	var size := Game.WORLD_SIZE
	draw_rect(Rect2(Vector2.ZERO, size), base_color)

	var x := 0.0
	while x <= size.x:
		draw_line(Vector2(x, 0.0), Vector2(x, size.y), line_color, 2.0)
		x += cell_size

	var y := 0.0
	while y <= size.y:
		draw_line(Vector2(0.0, y), Vector2(size.x, y), line_color, 2.0)
		y += cell_size
