tool
extends KinematicBody2D

export var size := Vector2(12,12) setget set_size
export var color := Color(1,1,0) setget set_color

var angle := 0.0 setget set_angle
var speed := 2.0 setget set_speed

var _velocity = Vector2()
var _collision : CollisionShape2D

signal ball_destroyed

func _ready():
	_collision = $CollisionShape2D
	update()


func _physics_process(_delta):
	var collision := move_and_collide(_velocity)
	if collision:
		var d = _velocity
		var n = collision.normal
		_velocity = d - 2 * (d.dot(n)) * n
		var brick := collision.collider
		if brick.has_method("destroy"): brick.destroy()


func _draw():
	var rect := Rect2(Vector2(), size)
	draw_rect(rect, color)


func update():
	.update()
	_velocity = Vector2(0, speed).rotated(angle)
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


func set_speed(value):
	speed = value
	property_list_changed_notify()
	update()


func set_angle(value):
	angle = value
	property_list_changed_notify()
	update()


func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("ball_destroyed")
	queue_free()
