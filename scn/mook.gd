
extends RigidBody2D

var speed = 14

onready var world = get_node('../../')
onready var gib = preload('res://scn/gib.tscn')
onready var sprite = get_node('sprite')

onready var kill = get_node('kill')
onready var shoot = get_node('shoot')

var dead = false
var path = []
var draw_path = true

func _ready():
	world.sounds.append(kill)
	world.sounds.append(shoot)
	set_process(true)

func _process(delta):
	if dead and !kill.is_voice_active(0):
		_die()
	else:
		if path.size() > 1:
			run_to(delta,path[1])

func run_to(delta,pos):
	var V = pos-get_pos()
	V = V.normalized()*(speed)
	set_linear_velocity(V)

func kill():
	kill.play('kill')
	dead = true
	get_node('sprite').set_modulate(Color(0.5,0,0,1))
	get_node('animator').stop(false)
	var lv = get_linear_velocity()*0.1
	set_linear_velocity(lv)

func _die():
	var lv = get_linear_velocity()*0.4
	set_linear_velocity(lv)
	for i in range(6):
		var G = gib.instance()
		get_parent().add_child(G)
		G.set_pos(get_pos())
		G.sprite.set_color(sprite.get_modulate())
		G.set_linear_velocity(Vector2(rand_range(-2,2),rand_range(-2,2))*rand_range(2,6))
	world.sounds.remove(world.sounds.find(kill))
	world.sounds.remove(world.sounds.find(shoot))
	world.mooks.remove(world.mooks.find(self))
	queue_free()

func get_path():
	path = world.find_path_to_player(self)

func _on_Timer_timeout():
	if world.player:
		get_path()
		
