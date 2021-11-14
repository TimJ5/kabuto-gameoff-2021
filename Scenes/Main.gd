extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	$Label.text = "FPS: " + str(Engine.get_frames_per_second()) + "\nAir Jumps: " + str($Player.air_jumps)
