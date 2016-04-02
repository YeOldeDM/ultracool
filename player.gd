
extends RigidBody2D

var speed = 5
var top_speed = 64

func _ready():
	set_process(true)

func _process(delta):
	var UP = Input.is_action_pressed('up')
	var DOWN = Input.is_action_pressed('down')
	var LEFT = Input.is_action_pressed('left')
	var RIGHT = Input.is_action_pressed('right')
	
	var lv = get_linear_velocity()
	var spd = speed*delta
	
	if UP and !DOWN:
		lv.y -= spd
	if DOWN and !UP:
		lv.y += spd
	if LEFT and !RIGHT:
		lv.x -= spd
	if RIGHT and !LEFT:
		lv.x += spd
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
			
	lv.x = clamp(lv.x,-top_speed,top_speed)
	lv.y = clamp(lv.y,-top_speed,top_speed)
	set_linear_velocity(lv)
