
extends Control






func _on_play_pressed():
	get_parent().load_scene('res://scn/world.tscn')


func _on_quit_pressed():
	get_tree().quit()


func _on_help_pressed():
	get_parent().load_scene('res://scn/help.tscn')
