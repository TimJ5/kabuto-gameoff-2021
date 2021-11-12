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

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var trans = _get_transition(delta)
		if trans != null:
			set_state(trans)

func _state_logic(delta):
	pass
	
func _get_transition(delta):
	return null
	
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