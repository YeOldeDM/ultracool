
extends RigidBody2D

onready var gib = preload('res://scn/gib.tscn')
onready var sprite = get_node('sprite')

onready var kill = get_node('kill')
onready var shoot = get_node('shoot')

func _ready():
	get_parent().sounds.append(kill)
	get_parent().sounds.append(shoot)
	pass

func _process(delta):
	if !kill.is_voice_active(0):
		_die()

func kill():
	kill.play('kill')
	set_process(true)

func _die():
	for i in range(6):
		var G = gib.instance()
		get_parent().add_child(G)
		G.set_pos(get_pos())
		G.sprite.set_color(sprite.get_modulate())
		G.set_linear_velocity(Vector2(rand_range(-2,2),rand_range(-2,2))*rand_range(2,6))
	get_parent().sounds.remove(get_parent().sounds.find(kill))
	get_parent().sounds.remove(get_parent().sounds.find(shoot))
	queue_free()
