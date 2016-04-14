
extends Node2D

var current_scene

var score = 0
var best_score = 0

func load_scene(path):
	var new_scene = load(path).instance()
	if current_scene:
		current_scene.queue_free()
	new_scene.set_pos(get_pos())
	add_child(new_scene)
	current_scene = new_scene

func _ready():
	load_scene('res://scn/bw_splash.tscn')

func _set_best_score(score):
	var file = File.new()
	file.open('res://stats.js',file.WRITE)
	var bs = {'best':	score}
	file.store_line(bs.to_json())
	file.close()

func _get_best_score():
	var file = File.new()
	file.open('res://stats.js',file.READ)
	var bs = {}
	while not file.eof_reached():
		bs.parse_json(file.get_line())
	file.close()
	return bs['best']
	