extends Node2D

onready var selected_character = $Crew
onready var characters = [$Crew,$Crew2,$Crew3]

func _ready():
	selected_character.select(true)

func set_selected_character(character):
	selected_character = character
	for crewman in characters:
		crewman.select(false)
	selected_character.select(true)

func get_closest_character(from):
	var closest_char
	var dist = 3000.0
	for crewman in characters:
		var temp_dist = from.global_position.distance_to(crewman.global_position)
		if temp_dist < dist:
			dist = temp_dist
			closest_char = crewman
	return closest_char

func crewman_dead(crewman):
	if characters.has(crewman):
		characters.erase(crewman)
