extends CanvasLayer

signal start_game

func show_win():
	$Win_view.show()

func _on_Continue_button_pressed():
	$Start_view.hide()
	emit_signal("start_game")
