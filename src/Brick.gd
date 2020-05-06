tool
extends StaticBody2D

export var size := Vector2(50,20) setget set_size
export var color := Color(1,1,0) setget set_color

var collision : CollisionShape2D

signal brick_destroyed

func _ready():
	collision = $CollisionShape2D
	update()


func _draw():
	var rect := Rect2(Vector2(), size)
	draw_rect(rect, color)


func update():
	.update()
	if not collision: return
	var rect := collision.shape as RectangleShape2D
	rect.extents = size / 2
	collision.position = size / 2


func set_size(value):
	size = value
	property_list_changed_notify()
	update()


func set_color(value):
	color = value
	property_list_changed_notify()
	update()


func destroy():
	emit_signal("brick_destroyed")
	queue_free()
