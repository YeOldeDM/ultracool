
extends Node

func _ready():
	pass


func process_sound(sound,time):
	sound.set('params/pitch_scale',time)

