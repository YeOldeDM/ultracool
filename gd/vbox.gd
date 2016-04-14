
extends SamplePlayer2D



func _ready():
	set_process(true)
	
func _process(delta):
	if not is_voice_active(0):
		if Input.is_action_pressed('ultra'):
			if !is_voice_active(0):
				play('ultra',0)
		if Input.is_action_pressed('cool'):
			if !is_voice_active(0):
				play('cool',0)


