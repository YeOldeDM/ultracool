
extends Sprite

var f=0
func _ready():
	set_process(true)

func _process(delta):
	f += 0.21
	if f >= 3:
		queue_free()
	set_frame(int(f))


