
extends Node2D

var current_scene

func load_scene(path):
	var new_scene = load(path).instance()
	if current_scene:
		current_scene.queue_free()
	new_scene.set_pos(get_pos())
	add_child(new_scene)
	current_scene = new_scene

func _ready():
	load_scene('res://scn/bw_splash.tscn')

