extends KinematicBody2D

const UP_DIRECTION = Vector2.UP
const GRAVITY = 1000
const SLOPE_STOP = 64

var max_air_jumps = 3
var air_jumps = max_air_jumps
var jump_strength = 500
var velocity = Vector2.ZERO
var speed = 400
var direction = 1
var wall_direction = 1
var wall_jump = Vector2(1600, -jump_strength)

onready var left_wall_ray = $WallRaycasts/LeftWall
onready var right_wall_ray = $WallRaycasts/RightWall

func _apply_gravity(delta):
	velocity.y += GRAVITY * delta
	
func _apply_movement():
	velocity = move_and_slide(velocity, UP_DIRECTION, SLOPE_STOP)

func _update_move_direction():
	direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))

func _handle_move_input():
	velocity.x = speed * direction
	
	if direction != 0:
		$Sprite.scale.x = direction

func _check_wall(wall_raycasts):
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _update_wall_direction():
	var is_near_wall_left = _check_wall(left_wall_ray)
	var is_near_wall_right = _check_wall(right_wall_ray)
	
	if is_near_wall_left && is_near_wall_right:
		wall_direction = direction
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)
	
func apply_wall_jump():
	wall_jump.x *= -wall_direction
	velocity = wall_jump
