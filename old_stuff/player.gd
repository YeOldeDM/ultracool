
extends RigidBody2D

onready var shoot_label = get_parent().get_node('shoot_label')

var bullet = preload('res://bullet.tscn')

var speed = 50
var top_speed = 64

var can_shoot = true
var shoot_time = 1.0
var shoot_timer = 0

func _ready():
	set_process(true)
	get_parent().sounds.append(get_node('shoot'))

func _process(delta):
	if not can_shoot:
		shoot_timer += delta
		if shoot_timer >= shoot_time:
			can_shoot = true
			shoot_label.set_text("CAN SHOOT")
	var UP = Input.is_action_pressed('up')
	var DOWN = Input.is_action_pressed('down')
	var LEFT = Input.is_action_pressed('left')
	var RIGHT = Input.is_action_pressed('right')
	var SHOOT = Input.is_action_pressed('shoot')
	
	var lv = get_linear_velocity()
	var spd = speed*delta
	var ts = OS.get_time_scale()
	
	if UP and !DOWN:
		lv.x = 0
		lv.y -= spd
	if DOWN and !UP:
		lv.x = 0
		lv.y += spd
	if LEFT and !RIGHT:
		lv.x -= spd
		lv.y = 0
	if RIGHT and !LEFT:
		lv.x += spd
		lv.y = 0
	if !LEFT and !RIGHT:
		if lv.x > 0:
			lv.x -= spd
		elif lv.x < 0:
			lv.x += spd
		else:
			lv.x = 0
	if !UP and !DOWN:
		if lv.y > 0:
			lv.y -= spd
		elif lv.y < 0:
			lv.y += spd
		else:
			lv.y = 0
	if !UP or !DOWN or !LEFT or !RIGHT:
		ts = 1.0
	lv.x = clamp(lv.x,-top_speed,top_speed)
	lv.y = clamp(lv.y,-top_speed,top_speed)
	
	set_linear_velocity(lv*(1.0+(1-ts)))
	
	
	if SHOOT and can_shoot:
		get_node('shoot').play('laser_bullet_fire')
		shoot_label.set_text("WILL SHOOT")
		can_shoot = false
		shoot_timer = 0
		var B = bullet.instance()
		PS2D.body_add_collision_exception(B.get_rid(),get_rid())
		var V = get_viewport().get_mouse_pos() - get_pos()
		V = V.normalized()*100
		B.set_linear_velocity(V)
		B.set_pos(get_pos())
		get_parent().add_child(B)
