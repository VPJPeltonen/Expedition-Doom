extends Node2D

export (PackedScene) var build_site

var state = "default"
var item_being_placed 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position()
	match state:
		"default":
			$Sprite.hide()
		"placing":
			$Sprite.show()

func _on_UI_build_mode(item):
	state = "placing"
	item_being_placed = item
	
func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if state != "placing":
		return
	if !(event.button_index != BUTTON_RIGHT or not event.pressed):
		state = "default"
	if !(event.button_index != BUTTON_LEFT or not event.pressed):
		state = "default"
		var b = build_site.instance() 
		get_parent().add_child(b)
		b.global_position = global_position
