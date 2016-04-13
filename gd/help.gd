
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_back_pressed():
	get_parent().load_scene('res://scn/title.tscn')
