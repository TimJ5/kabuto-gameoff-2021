extends Node
class_name StateMachine

var state = null setget set_state
var prev_state = null
var states = {}

onready var parent = get_parent()

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("attack")
	add_state("wall")
	call_deferred("set_state", states.idle)

func _input(event):
	#Basic Jump
	if [states.idle, states.run, states.jump, states.fall].has(state):
		if event.is_action_pressed("jump") and parent.air_jumps > 0:
			parent.velocity.y -= parent.jump_strength
			parent.air_jumps -= 1
	
	elif state == states.wall:
		if event.is_action_pressed("jump"):
			parent.apply_wall_jump()
			set_state(states.jump)

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var trans = _get_transition(delta)
		if trans != null:
			set_state(trans)

func _state_logic(delta):
	parent._update_move_direction()
	parent._update_wall_direction()
	if state != states.wall:
		parent._handle_move_input()
	parent._apply_gravity(delta)
	parent._apply_movement()

	
func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		
		states.jump:
			if parent.wall_direction != 0:
				return states.wall
			elif parent.is_on_floor():
				parent.air_jumps = parent.max_air_jumps
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		
		states.fall:
			if parent.wall_direction != 0:
				return states.wall
			elif parent.is_on_floor():
				parent.air_jumps = parent.max_air_jumps
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
				
		states.wall:
			if parent.is_on_floor():
				return states.idle
			elif parent.wall_direction == 0:
				return states.fall
	
func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
	
func set_state(new_state):
	prev_state = state
	state = new_state
	
	if prev_state != null:
		_exit_state(prev_state, new_state)
	if new_state != null:
		_enter_state(new_state, prev_state)
		
func add_state(state_name):
	states[state_name] = states.size()

func get_state():
	match state:
		states.idle:
			return "Idle"
		states.run:
			return "Run"
		states.jump:
			return "Jump"
		states.fall:
			return "Fall"
		states.attack:
			return "Attack"
		states.wall:
			return "Wall"
