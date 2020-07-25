extends Node2D

signal enemy_dead(enemy)

export (PackedScene) var monster

onready var crewmen = get_parent().get_node("Player_characters")
onready var main = get_parent().get_parent()
onready var spawn_points = $Spawn_points.get_children()

var monster_phase = false
var rng = RandomNumberGenerator.new()
var spawn_amounts = [2,3,3,5,5,6,6,7,7]
var spawn_groups = [4,4,5,5,6,6,7,7]

func _process(delta):
	if !monster_phase:
		return
	var monsters = get_children()
	if monsters.size() <= 1:
		main.monsters_killed()
		monster_phase = false

func enemy_died(enemy):
	emit_signal("enemy_dead",enemy)

func get_closest_target(hunter):
	return crewmen.get_closest_character(hunter)

func spawn_enemies():
	var night = GameData.current_night
	rng.randomize()
	for i in range(0,spawn_groups[night]):
		var spawn_pos = spawn_points[rng.randi_range(0,spawn_points.size()-1)].global_position
		for j in range (0,spawn_amounts[night]):
			print("monster spawned")
			var m = monster.instance() 
			add_child(m)
			
			var offset = Vector2(rng.randi_range(-50,50),rng.randi_range(-50,50))
			m.global_position = spawn_pos+offset
	monster_phase = true
	
func _on_UI_start_game():
	spawn_enemies()

func _on_UI_night_time():
	spawn_enemies()
