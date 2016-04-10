
extends RigidBody2D

const SPEED = 50

var splode = preload('res://scn/splode.tscn')

func fire(owner,target_pos):
	var V = target_pos - owner.get_pos()
	PS2D.body_add_collision_exception(get_rid(),owner.get_rid())
	V = V.normalized()*SPEED
	set_linear_velocity(V)


func _on_bullet_body_enter( body ):
	if body.has_method('kill'):
		body.call('kill')
	var s = splode.instance()
	get_parent().add_child(s)
	s.set_pos(get_pos())
	queue_free()
