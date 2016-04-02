
extends RigidBody2D

onready var sound = get_node('sound')

func _ready():
	get_parent().sounds.append(sound)




func _on_RigidBody2D_body_enter( body ):
	print('hit')
	#sound.play('hit')
