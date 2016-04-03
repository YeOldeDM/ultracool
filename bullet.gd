
extends RigidBody2D






func _on_bullet_body_enter( body ):
	queue_free()
