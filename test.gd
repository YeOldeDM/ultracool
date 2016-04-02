
extends Node

var sounds = []

onready var sound = get_node('sound')

var old_pos

func _ready():
	sounds.append(sound)
	sound.play('vap')
	old_pos = get_viewport().get_mouse_pos()
	set_process(true)
	
func _process(delta):
	var m_pos = get_viewport().get_mouse_pos()
	var diff = m_pos - old_pos
	#diff = diff.normalized()
	var lv = get_node('player').get_linear_velocity()
	diff = (abs(diff.x)+abs(diff.y)+abs(lv.x)+abs(lv.y))/4
	diff = clamp(diff,0.01,1.0)
	#print(diff)
	OS.set_time_scale(diff)
	for s in sounds:
		if s.is_voice_active(0):
			s.voice_set_pitch_scale(0,diff)
			
	old_pos = m_pos
	

