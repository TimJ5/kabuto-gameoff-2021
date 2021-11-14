extends KinematicBody2D

const UP_DIRECTION = Vector2.UP
const GRAVITY = 1000
const SLOPE_STOP = 64

var max_air_jumps = 3
var air_jumps = max_air_jumps
var jump_strength = 500
var velocity = Vector2.ZERO
var speed = 400

onready var left_wall_ray = $WallRaycasts/LeftWall
onready var right_wall_ray = $WallRaycasts/RightWall

func _apply_gravity(delta):
	velocity.y += GRAVITY * delta
	print(velocity.y)
	
func _apply_movement():
	velocity = move_and_slide(velocity, UP_DIRECTION, SLOPE_STOP)

func _handle_move_input():
	var h_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	velocity.x = speed * h_direction
	
	if h_direction != 0:
		$Sprite.scale.x = h_direction
func _check_wall():
	pass
