tool
extends KinematicBody2D

export var size := Vector2(12,12) setget set_size
export var color := Color(1,1,0) setget set_color

var collision : CollisionShape2D

func _ready():
	collision = $CollisionShape2D
	update()

var speed = 100
func _physics_process(delta):
	var velocity := Vector2()

	if Input.is_action_pressed("ui_right"):
		velocity.x += speed * delta
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed * delta

	move_and_collide(velocity)


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
