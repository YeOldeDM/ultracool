
extends Node2D

var timescale = true
var sounds = []
var soundtrack = 'sord'
onready var music = get_node('music')
onready var env = get_node('env')
onready var xhair = get_node('xhair')
onready var nav = get_node('map/nav')
onready var mooks = get_node('mooks').get_children()

var player

var mpos
var old_mpos

var DRAW_PATHS = false

func _ready():
	sounds.append(music)
	var st = music.get_sample_library().get_sample(soundtrack)
	st.set_loop_begin(0)
	st.set_loop_end(st.get_length())
	st.set_loop_format(0)
	music.play(soundtrack)
	var center = Vector2(256,256)
	Input.warp_mouse_pos(center)
	mpos = get_viewport().get_mouse_pos()
	old_mpos = get_viewport().get_mouse_pos()
	
	set_process(true)

		
func _process(delta):
	var mouse_pos = get_viewport().get_mouse_pos()
	mpos = mouse_pos
	var diff = mpos - old_mpos
	var lv = get_node('player').get_linear_velocity()
	diff = (abs(diff.x)+abs(diff.y)+abs(lv.x)+abs(lv.y))/4
	diff = clamp(diff,0.01,1.0)
	
	OS.set_time_scale(diff)
	
	for s in sounds:
		s.set('params/pitch_scale',diff)
			
	
	old_mpos = mpos
	xhair.set_pos(mpos)
	if DRAW_PATHS:
		update()
	
func find_path_to_player(from):
	var from_pos = from.get_pos()
	var to_pos = player.get_pos()
	return nav.get_simple_path(from_pos,to_pos)
	#PATHFINDING TEST -- DELETE ME SOON!
#	var mook = get_node('mook').get_pos()
#	var player = get_node('player').get_pos()
#	path = nav.get_simple_path(mook,player)
#	update()
#func _draw():
#	for p in range(1,path.size()):
#		draw_line(path[p-1],path[p],Color(0,1,0,0.5))
func _draw():
	for m in mooks:
		for p in range(1,m.path.size()):
			draw_line(m.path[p-1],m.path[p],Color(0,1,0,0.5))


