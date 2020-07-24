extends Node2D

signal enemy_dead(enemy)

onready var crewmen = get_parent().get_node("Player_characters")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enemy_died(enemy):
	emit_signal("enemy_dead",enemy)

func get_closest_target(hunter):
	return crewmen.get_closest_character(hunter)
