extends KinematicBody2D

const UP_DIRECTION = Vector2.UP
const GRAVITY = 1000
const SLOPE_STOP = 64
var air_jumps = 3
var jump_strength = 500
var velocity = Vector2.ZERO
var speed = 400


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	_handle_move_input()
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, UP_DIRECTION, SLOPE_STOP)

func _handle_move_input():
	var h_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	velocity.x = speed * h_direction
	
	if h_direction != 0:
		$Sprite.scale.x = h_direction
