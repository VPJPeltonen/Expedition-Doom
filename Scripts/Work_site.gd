extends Sprite

export (PackedScene) var Torch

var building
var work_done = 0

func add_work(work):
	work_done += work
	print("adding work")
	$ProgressBar.value = work_done
	if work_done >= 100:
		var t = Torch.instance() 
		get_parent().add_child(t)
		t.global_position = global_position
		queue_free()
