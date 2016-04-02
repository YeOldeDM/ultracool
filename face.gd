
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
	s.x = clamp(s.x,0.5,1.5)
	s.y = clamp(s.y,0.5,1.5)
	set_scale(s)
	var fr = int(round(rand_range(0,F-1)))
	if randf() < 0.1:
		set_frame(fr)


