
extends RigidBody2D

onready var world = get_parent()
onready var gib = preload('res://scn/gib.tscn')
onready var bullet = preload('res://scn/bullet.tscn')
onready var sprite = get_node('sprite')
onready var animator = get_node('animator')
onready var shoot = get_node('shoot')

var can_shoot= true
var shoot_timer = 0
var shoot_time = 1.0

var accel = 48
var top_speed = 20

var dead=false

func _ready():
	get_parent().sounds.append(get_node('shoot'))
	get_parent().player = self
	pass

func _integrate_forces(state):
	if !dead:
		var delta = state.get_step()
		var lv = get_linear_velocity()
		var spd = accel*delta
	
		if not can_shoot:
			shoot_timer += delta
			if shoot_timer >= shoot_time:
				can_shoot = true
				#shoot_label.set_text("CAN SHOOT")
		var UP = Input.is_action_pressed('up')
		var DOWN = Input.is_action_pressed('down')
		var LEFT = Input.is_action_pressed('left')
		var RIGHT = Input.is_action_pressed('right')
		var SHOOT = Input.is_action_pressed('shoot')
	
		if UP and !DOWN:
			lv.y -= spd
			if !LEFT and !RIGHT:
				lv.x = 0
		if DOWN and !UP:
			lv.y += spd
			if !LEFT and !RIGHT:
				lv.x = 0
		if LEFT and !RIGHT:
			lv.x -= spd
			if !UP and !DOWN:
				lv.y = 0
		if RIGHT and !LEFT:
			lv.x += spd
			if !UP and !DOWN:
				lv.y = 0
		if !UP and !DOWN:
			if lv.y < 0:
				lv.y += spd
			else:
				lv.y -= spd
	
		if !LEFT and !RIGHT:
			if lv.x < 0:
				lv.x += spd
			else:
				lv.x -= spd
		
		lv.x = clamp(lv.x,-top_speed,top_speed)
		lv.y = clamp(lv.y,-top_speed,top_speed)
		
		set_linear_velocity(lv)

		if SHOOT and can_shoot:
			get_node('shoot').play('shoot')
			#shoot_label.set_text("WILL SHOOT")
			can_shoot = false
			shoot_timer = 0
			var B = bullet.instance()
			B.set_pos(get_pos())
			get_parent().add_child(B)
			B.fire(self,get_parent().get_node('xhair').get_pos())

func kill():
	dead = true
	get_node('sprite').set_modulate(Color(0,0,0.5,1))
	get_node('animator').stop(false)
	var lv = get_linear_velocity()*0.01
	set_linear_velocity(lv)
	_die()

func _die():
	var lv = get_linear_velocity()*0.4
	set_linear_velocity(lv)
	for i in range(6):
		var G = gib.instance()
		get_parent().add_child(G)
		G.set_pos(get_pos())
		G.sprite.set_color(sprite.get_modulate())
		G.set_linear_velocity(Vector2(rand_range(-2,2),rand_range(-2,2))*rand_range(2,6))
	#world.sounds.remove(world.sounds.find(kill))
	world.sounds.remove(world.sounds.find(shoot))
	set_opacity(0.0)
	


