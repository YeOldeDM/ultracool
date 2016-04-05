
extends RigidBody2D

onready var sprite = get_node('sprite')

func _ready():
	pass

func _process(delta):
	var o = sprite.get_opacity()
	o -= 0.6*delta
	if o <= 0.0:
		queue_free()
	else:
		sprite.set_opacity(o)



func _on_Timer_timeout():
	set_process(true)
