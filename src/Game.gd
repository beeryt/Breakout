tool
extends Node2D

export var play_area := Vector2(922,512)

var brick_prefab := preload("Brick.tscn")
var ball_prefab := preload("Ball.tscn")
var paddle_prefab := preload("Paddle.tscn")

var wall_poly = PoolVector2Array([
	Vector2(0,51),
	Vector2(1024,51),
	Vector2(1024,602),
	Vector2(973,602),
	Vector2(973,102),
	Vector2(51,102),
	Vector2(51,602),
	Vector2(0,602)
])

var colors = [
	Color("#c84848"),
	Color("#c66c3a"),
	Color("#b47a30"),
	Color("#a2a22a"),
	Color("#48a048"),
	Color("#4248c8")
]

func _draw():
	draw_colored_polygon(wall_poly, Color("#8e8e8e"))


func _ready():
	randomize()
	var paddle = paddle_prefab.instance()
	paddle.position.x = $BrickOrigin.position.x + 461 - paddle.size.x / 2
	paddle.position.y = 587
	add_child(paddle)

	spawn_ball()

	var y = 0
	for color in colors:
		for x in range(18):
			var brick = brick_prefab.instance()
			brick.position = Vector2(brick.size.x * x, brick.size.y * y)
			brick.color = color
			$BrickOrigin.add_child(brick)
		y += 1

	var shape := CollisionPolygon2D.new()
	shape.polygon = wall_poly
	$Walls.add_child(shape)


func spawn_ball():
	var ball = ball_prefab.instance()
	var yoffset = 2 * len(colors) * brick_prefab.instance().size.y
	ball.position = $BrickOrigin.position + Vector2(ball.size.x, yoffset)
	ball.position.x += (922-ball.size.x) * randf()
	ball.angle = deg2rad(360*randf())
	ball.connect("ball_destroyed", self, "spawn_ball")
	add_child(ball)
