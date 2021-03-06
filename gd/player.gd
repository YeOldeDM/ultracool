
extends RigidBody2D

onready var world = get_parent()
onready var gib = preload('res://scn/gib.tscn')
onready var bullet = preload('res://scn/bullet.tscn')
onready var sprite = get_node('sprite')
onready var my_color = sprite.get_modulate()
onready var animator = get_node('animator')

onready var shoot = get_node('shoot')
onready var kill = get_node('kill')
onready var hop = get_node('hop')

var can_shoot= true
var shoot_timer = 0
var shoot_time = 1.0
var my_bullet=null

var can_hop = true
var hop_timer = 0
var hop_time = 5.0

var accel = 60
var top_speed = 20

var dead=false

func _ready():
	get_parent().sounds.append(get_node('shoot'))
	get_parent().sounds.append(get_node('kill'))
	get_parent().sounds.append(get_node('hop'))
	get_parent().player = self
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	var HOP = Input.is_action_pressed('hop_swap')
	var RESTART = Input.is_action_pressed('restart')
	if world.hop_target in world.mooks:
		if world.hop_target:
			if world.hop_target.has_fov:
				if HOP and can_hop:
					can_hop = false
					hop_timer = 0
					world.hop_swap()
					hop.play('hop')
	if RESTART and dead:
		#only respawn if no bullets are on the screen
		#(bypasses a bug in bullet ownership)
		if world.get_node('bullets').get_children().empty():
			respawn()
	for sound in [shoot,kill,hop]:
		SoundManager.process_sound(sound,world.time_scale)


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
		if not can_hop:
			hop_timer += delta
			if hop_timer >= hop_time:
				can_hop = true
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
		if UP or DOWN or LEFT or RIGHT:
			var ts = OS.get_time_scale()
			lv *= 1+(1-ts)
		set_linear_velocity(lv)

		if SHOOT and can_shoot:
			var xhairpos = get_parent().get_node('xhair').get_pos()
			get_node('shoot').play('shoot')
			#shoot_label.set_text("WILL SHOOT")
			can_shoot = false
			shoot_timer = 0
			var B = bullet.instance()
			B.owner = self
			my_bullet = B
			var bullet_pos = get_pos()
			if bullet_pos.x < xhairpos.x:
				bullet_pos.x += 1
			elif bullet_pos.x > xhairpos.x:
				bullet_pos.x -= 1
			if bullet_pos.y < xhairpos.y:
				bullet_pos.y += 1
			elif bullet_pos.y > xhairpos.y:
				bullet_pos.y -= 1
			B.set_pos(bullet_pos)
			get_parent().add_child(B)
			B.fire(self,xhairpos)
		

			
			
func respawn():
	for bullet in world.get_node('bullets').get_children():
		bullet.queue_free()
	for mook in world.get_mooks():
		mook.queue_free()

	for spawner in world.spawners:
		spawner.start_spawn()
	set_pos(world.player_start)
	dead = false
	world.hide_respawn_label()
	sprite.set_modulate(my_color)
	animator.play('walk')
	set_opacity(1)

func kill():
	dead = true
	world.show_respawn_label()
	get_node('sprite').set_modulate(Color(0,0,0.5,1))
	get_node('animator').stop(false)
	var lv = get_linear_velocity()*0.01
	set_linear_velocity(lv)
	_die()

func _die():
	for bullet in world.get_node('bullets').get_children():
		bullet.queue_free()
	kill.play('kill')
	var lv = get_linear_velocity()*0.4
	set_linear_velocity(lv)
	for i in range(6):
		var G = gib.instance()
		get_node('/root/Game/world').add_child(G)
		G.set_pos(get_pos())
		G.sprite.set_color(sprite.get_modulate())
		G.set_linear_velocity(Vector2(rand_range(-2,2),rand_range(-2,2))*rand_range(2,6))
	set_opacity(0.0)
	world.reset_score()
	


