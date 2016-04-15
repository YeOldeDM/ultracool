
extends Sprite

onready var world = get_node('/root/Game/world')
onready var rico = get_node('rico')

var f=0
func _ready():
	set_process(true)
	world.sounds.append(rico)
	rico.play('rico')
	

func _process(delta):
	f += 0.21
	if f >= 3:
		world.sounds.remove(world.sounds.find(rico))
		queue_free()
	set_frame(int(f))


