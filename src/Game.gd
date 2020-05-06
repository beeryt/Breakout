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

var brick_types = [
	{ "color": Color("#c84848"), "score": 7 },
	{ "color": Color("#c66c3a"), "score": 7 },
	{ "color": Color("#b47a30"), "score": 4 },
	{ "color": Color("#a2a22a"), "score": 4 },
	{ "color": Color("#48a048"), "score": 1},
	{ "color": Color("#4248c8"), "score": 1 },
]

var score := 0
var turns := 5

func _draw():
	draw_colored_polygon(wall_poly, Color("#8e8e8e"))


func _ready():
	randomize()
	var paddle = paddle_prefab.instance()
	paddle.position.x = $BrickOrigin.position.x + 461 - paddle.size.x / 2
	paddle.position.y = 587
	add_child(paddle)

	$ReferenceRect/Turns.text = str(turns)
	$ReferenceRect/Score.text = str(score)
	
	spawn_ball()

	var y = 0
	for brick_type in brick_types:
		for x in range(18):
			var brick = brick_prefab.instance()
			brick.position = Vector2(brick.size.x * x, brick.size.y * y)
			brick.color = brick_type.color
			brick.score = brick_type.score
			brick.connect("brick_destroyed", self, "add_score")
			$BrickOrigin.add_child(brick)
		y += 1

	var shape := CollisionPolygon2D.new()
	shape.polygon = wall_poly
	$Walls.add_child(shape)


func add_score(value):
	score += value
	$ReferenceRect/Score.text = str(score)


func spawn_ball():
	var ball = ball_prefab.instance()
	var yoffset = 2 * len(brick_types) * brick_prefab.instance().size.y
	ball.position = $BrickOrigin.position + Vector2(ball.size.x, yoffset)
	ball.position.x += (922-ball.size.x) * randf()
	ball.angle = deg2rad(360*randf())
	ball.connect("ball_destroyed", self, "ball_destroyed")
	add_child(ball)


func ball_destroyed():
	turns -= 1
	$ReferenceRect/Turns.text = str(turns)
	if turns > 0:
		spawn_ball()
