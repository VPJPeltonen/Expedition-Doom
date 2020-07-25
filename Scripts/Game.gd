extends Node2D

onready var UI = $Camera2D/UI

func monsters_killed():
	UI.show_win()
