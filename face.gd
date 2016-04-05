
extends Sprite

var N = 2
var F = 4

func _ready():
	set_process(true)

func _process(delta):
	var rx = rand_range(-N,N)
	var ry = rand_range(-N,N)
	var s = get_scale()
	s.x += rx*delta
	s.y += ry*delta
	s.x = clamp(s.x,1.0,3.0)
	s.y = clamp(s.y,1.0,3.0)
	set_scale(s)
	var fr = int(round(rand_range(0,F-1)))
	if randf() < 0.01:
		set_frame(fr)


