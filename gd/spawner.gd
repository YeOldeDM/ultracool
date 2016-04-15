
extends Sprite

onready var timer = get_node('Timer')
onready var anim = get_node('animator')
onready var splode = get_node('splode')
onready var mook = preload('res://scn/mook.tscn')

onready var world = get_node('/root/Game/world')

var can_splode=true
func _ready():
	start_spawn()	#bootstrap
	set_process(true)

func _process(delta):
	var D = (timer.get_time_left() / timer.get_wait_time())*1.0
	var R = lerp(0.0,0.8,D)
	set_modulate(Color(R,R-1,1-R,1))
	if timer.get_time_left() <= splode.get_lifetime():
		if can_splode:
			splode.set_emitting(true)
			can_splode=false

func start_spawn():
	timer.start()
	anim.play('go')
	can_splode=true
	
func _spawn():
	timer.stop()
	var m = mook.instance()
	world.add_mook(m)
	world.find_mooks()
	m.set_pos(get_pos())
	m.spawner = self
	anim.stop_all()
	set_frame(0)
	




func _on_Timer_timeout():
	_spawn()
