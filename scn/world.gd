
extends Node2D

var timescale = true
var time_scale
var sounds = []
var soundtrack = 'sond'
onready var game = get_node('/root/Game')
onready var music = get_node('music')
onready var env = get_node('env')
onready var xhair = get_node('xhair')
onready var nav = get_node('map/nav')
onready var player_start = get_node('map/player_start').get_pos()
onready var mooks = get_node('mooks').get_children()
onready var spawners = get_node('map/spawners').get_children()

onready var menu = get_node('menu')

onready var hopswap_label = get_node('overlay/HUD/hopswap')
onready var respawn_label = get_node('overlay/HUD/respawn')

var player
var hop_target

var mpos
var old_mpos

var ts = 1.0

var DRAW_PATHS = false

func _ready():
	sounds.append(music)
#	var st = music.get_sample_library().get_sample(soundtrack)
#	st.set_loop_begin(0)
#	st.set_loop_end(st.get_length())
#	st.set_loop_format(0)
	music.play(soundtrack)
	menu.hide()
	get_tree().set_pause(false)
	var center = Vector2(256,256)
	Input.warp_mouse_pos(center)
	mpos = get_viewport().get_mouse_pos()
	old_mpos = get_viewport().get_mouse_pos()
	player.set_pos(player_start)
	set_process(true)
	set_process_input(true)

func _input(event):
	var PAUSE = Input.is_action_pressed('pause')
	if PAUSE:
		get_tree().set_pause(true)
		menu.show()
		
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
	
	time_scale = diff
	SoundManager.process_sound(music,diff)

	
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

func score():
	game.score += 1
	get_node('overlay/score').set_text(str(game.score))
	get_node('overlay/score').get_node('animator').play('blink')

func reset_score():
	game.score = 0

func add_mook(mook):
	mooks.append(mook)
	get_node('mooks').add_child(mook)
	for node in mook.get_children():
		if node extends SamplePlayer2D:
			sounds.append(node)

func remove_mook(mook):
	if mook.my_bullet != null:
		mook.my_bullet.owner = null
		mook.my_bullet = null
	for node in mook.get_children():
		if node in sounds:
			sounds.remove(sounds.find(node))
	mooks.remove(mooks.find(mook))
	mook.queue_free()

func get_mooks():
	return get_node('mooks').get_children()
#	for M in ref:
#		mooks.append(weakref(M))

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
	#allow actors to shoot themselves after hop-swapping
	if player.my_bullet:
		PS2D.body_remove_collision_exception(player.my_bullet.get_rid(),player.get_rid())
	if hop_target.my_bullet:
		PS2D.body_remove_collision_exception(hop_target.my_bullet.get_rid(),hop_target.get_rid())
	hop_target.set_pos(player_pos)
	player.set_pos(hop_pos)

func show_respawn_label():
	if !respawn_label.is_visible():
		respawn_label.show()
func hide_respawn_label():
	if respawn_label.is_visible():
		respawn_label.hide()
	
func _draw():
	for m in mooks:
		if m.draw_path:
			for p in range(1,m.path.size()):
				draw_line(m.path[p-1],m.path[p],Color(0,0,0.8,0.5))


func _on_xhair_body_enter( body ):
	if body.has_method('kill') && !body.dead && body != player:
		hop_target = body



func _on_music_reset_timeout():
	music.play(soundtrack)


func _on_back_pressed():
	get_tree().set_pause(false)
	menu.hide()
	


func _on_quit_pressed():
	get_tree().set_pause(false)
	game.load_scene('res://scn/title.tscn')
