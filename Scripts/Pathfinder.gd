extends Node2D

onready var nav_2d = $Navigation2D
onready var character = $Player_characters/Crew

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_RIGHT or not event.pressed:
		return
	if $Player_characters.selected_character == null:
		return
	var new_path = nav_2d.get_simple_path($Player_characters.selected_character.global_position, get_global_mouse_position())
	#line_2d.points = new_path
	$Player_characters.selected_character.path = new_path

func get_AI_path(start,end):
	var new_path = nav_2d.get_simple_path(start.global_position, end.global_position)
	return new_path
