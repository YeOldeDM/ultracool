
extends RigidBody2D

var spawner

var speed = 14

var shoot_time = 3.0
var shoot_timer = 0
var can_shoot = true
var my_bullet=null

onready var world = get_node('../../')
onready var gib = preload('res://scn/gib.tscn')
onready var bullet = preload('res://scn/bullet.tscn')
onready var sprite = get_node('sprite')

onready var kill = get_node('kill')
onready var shoot = get_node('shoot')

var has_fov = false

var dead = false
var path = []
var draw_path = false

func _ready():
	world.sounds.append(kill)
	world.sounds.append(shoot)
	set_fixed_process(true)

func _fixed_process(delta):
	if dead and !kill.is_voice_active(0):
		_die()
	elif !world.player.dead:
		if path.size() > 1:
			run_to(delta,path[1])
		if can_shoot:
			if has_fov and !dead:
				shoot_timer = 0
				can_shoot = false
				fire()
		else:
			shoot_timer += delta
			if shoot_timer >= shoot_time:
				shoot_timer = 0
				can_shoot = true

	var space_state = get_world_2d().get_direct_space_state()
	var exception_list = [self,world.player]
	for B in world.get_node('bullets').get_children():
		exception_list.append(B)
	var result = space_state.intersect_ray(get_global_pos(),world.player.get_pos(),exception_list)
	if result.empty():
		has_fov = true
	else:
		has_fov = false
	
func run_to(delta,pos):
	var V = pos-get_pos()
	V = V.normalized()*(speed)
	set_linear_velocity(V)

func kill():
	kill.play('kill')
	dead = true
	if my_bullet:
		my_bullet.owner = null
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
	spawner.start_spawn()
	queue_free()
	world.find_mooks()
	world.score()

func get_path():
	path = world.find_path_to_player(self)

func _on_Timer_timeout():
	if world.player:
		get_path()

func fire():
	var B = bullet.instance()
	B.owner = self
	my_bullet = B
	B.set_pos(get_pos())
	world.get_node('bullets').add_child(B)
	B.fire(self,world.player.get_pos())
