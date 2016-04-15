
extends Node2D

var strings = [
"[center]Made in two weeks for\nitch.io\n#LOWREZJAM2016[/center]",
"[center]Based on the game\n[color=red]superhot[/color]\n(its better than this!)[/center]",
"[center][color=aqua]Engine By[/color]\nGodot\n[img]res://gfx/godot16.png[/img]\ngodotengine.org[/center]",
"[center][color=aqua]Design,GFX,SFX & Code[/color]\nYeOldeDM[/center]",
"[center][color=aqua]QA[/color]\nAngular_Mike[/center]",
"[center][color=aqua]SPECIAL THANKS[/color]\nall the cool peepz @ #godotengine[/center]",
"[center][color=aqua]AND[/color]\n\nYou\n(yeah, you!)[/center]",
]

onready var text = get_node('text')
onready var tick = get_node('tick')
onready var stepper = get_node('stepper')
onready var tap = get_node('tap')
var step = 0

func _ready():
	text.set_scroll_active(false)
	new_text()

func is_done():
	if text.get_visible_characters() >= text.get_total_character_count():
		return true
	return false

func new_text():
	text.set_visible_characters(0)
	text.set_bbcode(strings[step])
	tick.start()




func _on_tick_timeout():
	if !is_done():
		text.set_visible_characters(text.get_visible_characters()+1)
		tap.play('tap')
	else:
		tick.stop()
		stepper.start()


func _on_stepper_timeout():
	text.clear()
	stepper.stop()
	step += 1
	if step <= strings.size()-1:
		new_text()
	else:
		get_node('/root/Game').load_scene('res://scn/title.tscn')
