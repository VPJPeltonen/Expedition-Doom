extends CanvasLayer

signal start_game
signal night_time
signal morning_time
signal build_mode(item)

var day_progress = 0
var day_stage = false
var stories

var StoryClass = load("res://Data/Day_stories.gd")

func _ready():
	stories = StoryClass.new()

func _process(delta):
	if day_stage:
		day_progress += delta*10
		$ActionUI/Day_meter/ProgressBar.value = day_progress
		if day_progress >= 100:
			#GameData.current_night += 1
			day_stage = false
			$ActionUI/Day_meter.hide()
			$AudioStreamPlayer.play()
			emit_signal("night_time")

func show_win():
	match GameData.current_night:
		0:
			$Start_view.show()
			$Start_view/Opening_text.hide()
			$Start_view/Morning1_text.show()
			GameData.current_night += 1
		5:
			$Start_view.show()
			$Start_view/Continue_button.hide()
			$Start_view/Opening_text.hide()
			$Start_view/Morning1_text.hide()
			$Start_view/Generic_text.show()
			var info = "Another night survived\n"
			info += "The ice has melted enough!\n\n"
			info += "You can escape!"
			$Start_view/Generic_text/Generic_text_text.text = info 
			GameData.current_night += 1
		_:
			$Start_view.show()
			$Start_view/Opening_text.hide()
			$Start_view/Morning1_text.hide()
			$Start_view/Generic_text.show()
			var info = "Another night survived\n"
			info += "Few crewmen have recovered from fewer\n\n"
			info += "Time to prepare for next night"
			$Start_view/Generic_text/Generic_text_text.text = info 
			GameData.current_night += 1			

func _on_Continue_button_pressed():
	match GameData.current_night:
		0:
			$Start_view.hide()
			emit_signal("start_game")
			$AudioStreamPlayer.play()
		5:
			$Start_view.hide()
			$ActionUI.show()
			$ActionUI/Day_meter.show()
			day_progress = 0
			day_stage = true
		_:
			$Start_view.hide()
			$ActionUI.show()
			$ActionUI/Day_meter.show()
			day_progress = 0
			day_stage = true
			emit_signal("morning_time")


func _on_Torch_build_pressed():
	emit_signal("build_mode","torch")


func _on_Player_characters_player_loses():
	$Start_view.show()
	$Start_view/Opening_text.hide()
	$Start_view/Morning1_text.hide()
	$Start_view/Generic_text.hide()
	$Start_view/Continue_button.hide()
	$"Start_view/Lose Screen".show()
