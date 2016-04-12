
extends Node2D

var timescale = true
var sounds = []
var soundtrack = 'sord'
onready var music = get_node('music')
onready var env = get_node('env')
onready var xhair = get_node('xhair')
onready var nav = get_node('map/nav')
onready var player_start = get_node('map/player_start').get_pos()
onready var mooks = get_node('mooks').get_children()

onready var hopswap_label = get_node('overlay/HUD/hopswap')

var player
var hop_target

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
	player.set_pos(player_start)
	set_process(true)

		
func _process(delta):
	var mouse_pos = get_viewport().get_mouse_pos()
	mpos = mouse_pos
	var diff = mpos - old_mpos
	var lv = get_node('player').get_linear_velocity()
	diff = (abs(diff.x)+abs(diff.y)+abs(lv.x)+abs(lv.y))/4
	diff = clamp(diff,0.01,1.0)
	if player.dead:
		diff = 1.0
	OS.set_time_scale(diff)
	
	for s in sounds:
		s.set('params/pitch_scale',diff)
			
	
	old_mpos = mpos
	xhair.set_pos(mpos)
	var col = xhair.get_node('col').get_overlapping_bodies()
	if !col.empty():
		for c in col:
			if c.has_method('kill') && !c.dead && c != player:
				if c.has_fov and player.can_hop:
					hop_target = c
					c.draw_path=true
					show_hopswap_label()
					return
				hop_target = null
	else:
		hop_target = null

	if hop_target:
		show_hopswap_label()
	else:
		hide_hopswap_label()

	if DRAW_PATHS:
		update()

func find_mooks():
	mooks = get_node('mooks').get_children()

func find_path_to_player(from):
	var from_pos = from.get_pos()
	var to_pos = player.get_pos()
	return nav.get_simple_path(from_pos,to_pos)

func show_hopswap_label():
	if !hopswap_label.is_visible():
		hopswap_label.show()

func hide_hopswap_label():
	if hopswap_label.is_visible():
		hopswap_label.hide()

func hop_swap():
	var player_pos = player.get_pos()
	var hop_pos = hop_target.get_pos()
	hop_target.set_pos(player_pos)
	player.set_pos(hop_pos)

	
func _draw():
	for m in mooks:
		if m.draw_path:
			for p in range(1,m.path.size()):
				draw_line(m.path[p-1],m.path[p],Color(0,0,0.8,0.5))


func _on_xhair_body_enter( body ):
	if body.has_method('kill') && !body.dead && body != player:
		hop_target = body

