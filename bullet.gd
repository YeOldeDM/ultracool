
extends RigidBody2D

var splode = preload('res://scn/splode.tscn')





func _on_bullet_body_enter( body ):
	if body.has_method('kill'):
		body.call('kill')
	var s = splode.instance()
	get_parent().add_child(s)
	s.set_pos(get_pos())
	queue_free()
