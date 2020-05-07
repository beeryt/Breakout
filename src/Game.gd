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

const brick_types = [
	{ "color": Color("#c84848"), "score": 7 },
	{ "color": Color("#c66c3a"), "score": 7 },
	{ "color": Color("#b47a30"), "score": 4 },
	{ "color": Color("#a2a22a"), "score": 4 },
	{ "color": Color("#48a048"), "score": 1},
	{ "color": Color("#4248c8"), "score": 1 },
]

export var score := 0 setget set_score
export var turns := 5 setget set_turns
var hit_counter := 0
var has_hit_first_row := false
var has_hit_second_row := false
var has_hit_back_wall := false

var balls := []
var ball_speed_multiplier := 1.0
var paddle = null

func _draw():
	draw_colored_polygon(wall_poly, Color("#8e8e8e"))


func _ready():
	randomize()
	paddle = paddle_prefab.instance()
	paddle.position.x = $BrickOrigin.position.x + 461 - paddle.size.x / 2
	paddle.position.y = 587
	add_child(paddle)
	
	set_turns(5)
	set_score(0)
	
	spawn_ball()

	var y = 0
	for brick_type in brick_types:
		for x in range(18):
			var brick = brick_prefab.instance()
			brick.position = Vector2(brick.size.x * x, brick.size.y * y)
			brick.color = brick_type.color
			brick.score = brick_type.score
			brick.connect("brick_destroyed", self, "brick_destroyed", [brick])
			$BrickOrigin.add_child(brick)
		y += 1

	var shape := CollisionPolygon2D.new()
	shape.polygon = wall_poly
	$Walls.add_child(shape)


func set_turns(value):
	if value > 9 or value < 0:
		printerr("value is out of range: ", value)
	else:
		turns = value
		$TurnCounter.frame = turns % 10


func set_score(value):
	if value > 999 or value < 0:
		printerr("value is out of range: ", value)
	else:
		score = value
		$Score_100.frame = (score / 100) % 10
		$Score_010.frame = (score / 10) % 10
		$Score_001.frame = score % 10


func brick_destroyed(value, brick):
	set_score(score + value)
	
	hit_counter += 1
	if hit_counter == 4 or hit_counter == 12:
		increase_speed(1.5)
	
	if not has_hit_first_row and brick.color == brick_types[0].color:
		increase_speed(1.33)
		has_hit_first_row = true
	
	if not has_hit_second_row and brick.color == brick_types[1].color:
		increase_speed(1.33)
		has_hit_second_row = true


func increase_speed(factor, list=self.balls):
	ball_speed_multiplier *= factor
	for ball in list:
		ball.speed *= factor


func spawn_ball():
	var ball = ball_prefab.instance()
	var yoffset = 2 * len(brick_types) * brick_prefab.instance().size.y
	ball.position = $BrickOrigin.position + Vector2(ball.size.x, yoffset)
	ball.position.x += (922-ball.size.x) * randf()
	ball.angle = deg2rad(360*randf())
	ball.speed *= ball_speed_multiplier
	ball.connect("ball_destroyed", self, "ball_destroyed", [ball])
	ball.connect("ball_collided", self, "ball_collided", [ball])
	balls.append(ball)
	add_child(ball)


func ball_destroyed(ball):
	balls.erase(ball)
	set_turns(turns - 1)
	if turns > 0:
		spawn_ball()


func ball_collided(collision: KinematicCollision2D, ball):
	# halve size of paddle first time back wall is hit
	if not has_hit_back_wall and collision.position.y < $BrickOrigin.position.y:
		if collision.normal == Vector2(0,1):
			has_hit_back_wall = true
			paddle.size.x /= 2.0
			print("halved!")
