extends Node2D

onready var UI = $Camera2D/UI

func _ready():
	$Pathfinder/Navigation2D/Snow.set_cell ( 0, 0, -1)

func monsters_killed():
	UI.show_win()
