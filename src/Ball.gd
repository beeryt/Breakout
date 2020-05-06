tool
extends Area2D

export var size := Vector2(12,12) setget set_size
export var color := Color(1,1,0) setget set_color

var _collision : CollisionShape2D

signal ball_destroyed

func _ready():
	_collision = $CollisionShape2D
	update()


func _draw():
	var rect := Rect2(Vector2(), size)
	draw_rect(rect, color)


func update():
	.update()
	if not _collision: return
	var rect := _collision.shape as RectangleShape2D
	rect.extents = size / 2
	_collision.position = size / 2


func set_size(value):
	size = value
	property_list_changed_notify()
	update()


func set_color(value):
	color = value
	property_list_changed_notify()
	update()


func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("ball_destroyed")
	queue_free()
