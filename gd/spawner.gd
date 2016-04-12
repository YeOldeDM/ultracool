
extends Sprite

onready var timer = get_node('Timer')
onready var anim = get_node('animator')

onready var mook = preload('res://scn/mook.tscn')

onready var world = get_node('../../')

func _ready():
	start_spawn()	#bootstrap
	set_process(true)

func _process(delta):
	var D = (timer.get_time_left() / timer.get_wait_time())*1.0
	var R = lerp(0.0,0.8,D)
	set_modulate(Color(R,R-1,1-R,1))

func start_spawn():
	timer.start()
	anim.play('go')
	
func _spawn():
	timer.stop()
	var m = mook.instance()
	world.get_node('mooks').add_child(m)
	world.find_mooks()
	m.set_pos(get_pos())
	m.spawner = self
	anim.stop_all()
	set_frame(0)
	




func _on_Timer_timeout():
	_spawn()
