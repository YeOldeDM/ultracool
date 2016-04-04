
extends Node

var timescale = true
var sounds = []
var soundtrack = 'sord'
onready var music = get_node('music')
onready var env = get_node('env')
onready var xhair = get_node('player/camera/xhair')

var mpos
var old_mpos

func _ready():
	sounds.append(music)
	music.play(soundtrack)
	var center = Vector2(256,256)
	Input.warp_mouse_pos(center)
	mpos = get_viewport().get_mouse_pos()
	old_mpos = get_viewport().get_mouse_pos()
	
	set_process(true)
	#set_process_input(true)

		
func _process(delta):
	#var cam_pos = get_node('player/camera').get_global_pos() - Vector2(32,32)
	var mouse_pos = get_viewport().get_mouse_pos()
	print(mouse_pos)
	mpos = mouse_pos - Vector2(32,32)
	var diff = mpos - old_mpos
	var lv = get_node('player').get_linear_velocity()
	diff = (abs(diff.x)+abs(diff.y)+abs(lv.x)+abs(lv.y))/4
	diff = clamp(diff,0.01,1.0)
	
	OS.set_time_scale(diff)
	
	for s in sounds:
		if s.is_voice_active(0):
			s.voice_set_pitch_scale(0,diff)
	
	old_mpos = mpos
	xhair.set_pos(mpos)

	


