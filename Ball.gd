tool
extends Area2D

export var size := Vector2(12,12) setget set_size
export var color := Color(1,1,0) setget set_color

var collision : CollisionShape2D

func _ready():
	collision = $CollisionShape2D
	update()


func _draw():
	var rect := Rect2(Vector2(), size)
	draw_rect(rect, color)


func update():
	print("update")
	.update()
	if not collision: return
	var rect := collision.shape as RectangleShape2D
	rect.extents = size / 2
	collision.position = size / 2
	print(size/2)


func set_size(value):
	size = value
	property_list_changed_notify()
	update()


func set_color(value):
	color = value
	property_list_changed_notify()
	update()


func _on_Ball_body_shape_entered(body_id, body, body_shape, area_shape):
	pass
