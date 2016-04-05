
extends RigidBody2D

onready var gib = preload('res://scn/gib.tscn')
onready var sprite = get_node('sprite')

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func kill():
	for i in range(6):
		var G = gib.instance()
		get_parent().add_child(G)
		G.set_pos(get_pos())
		G.sprite.set_color(sprite.get_modulate())
		G.set_linear_velocity(Vector2(rand_range(-2,2),rand_range(-2,2))*rand_range(2,6))
		
	queue_free()
