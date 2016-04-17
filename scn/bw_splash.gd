
extends Node2D


func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed('exit') and get_node('Timer').get_time_left() < 3.0:
		_next()

func _next():
	Input.warp_mouse_pos(Vector2(0,0))
	get_parent().load_scene('res://scn/title.tscn')


func _on_Timer_timeout():
	_next()
