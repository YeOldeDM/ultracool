
extends Node


func _ready():
	set_process_input(true)

func _input(event):
	if event.type != InputEvent.MOUSE_MOTION and get_node('Timer').get_time_left() < 3.0:
		_next()

func _next():
	get_tree().change_scene('res://scn/world.tscn')


func _on_Timer_timeout():
	_next()
