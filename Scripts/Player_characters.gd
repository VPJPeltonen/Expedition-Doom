extends Node2D

onready var selected_character = $Crew
onready var characters = [$Crew,$Crew2,$Crew3]
onready var sick_characters = $Sick_crew.get_children()

export (PackedScene) var crew_man_scene

var rng = RandomNumberGenerator.new()

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
	sick_characters = $Sick_crew.get_children()
	for sick_crewman in sick_characters:
		var temp_dist = from.global_position.distance_to(sick_crewman.global_position)
		if temp_dist < dist:
			dist = temp_dist
			closest_char = sick_crewman		
	return closest_char

func wake_crewmen():
	for i in range(0,2):
		if $Sick_crew.get_child_count() != 0:
			sick_characters = $Sick_crew.get_children()
			var reviving = sick_characters[rng.randi_range(0,sick_characters.size()-1)]
			var c = crew_man_scene.instance() 
			add_child(c)
			characters.append(c)
			c.global_position = reviving.global_position
			reviving.queue_free()

func crewman_dead(crewman):
	if characters.has(crewman):
		characters.erase(crewman)


func _on_UI_morning_time():
	wake_crewmen()
