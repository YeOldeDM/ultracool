
extends Label
var n = 0
var time = 1
var timer = 0

func _ready():
	set_process(true)
	
func _process(delta):
	timer += delta
	if timer >= time:
		timer = 0
		if n == 0:
			n = 1
		else:
			n = 0
	if n == 0:
		set_text('ULTRA COOL')
	if n == 1:
		set_text('MOVE WADS')


