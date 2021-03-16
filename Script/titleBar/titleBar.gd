extends Control

var following = false
var dragPoint = Vector2()

func _process(delta):
	if following:
		if Input.is_action_just_pressed("leftClick"):
			dragPoint = get_local_mouse_position()
		if Input.is_action_pressed("leftClick"):
			OS.window_position += get_global_mouse_position() - dragPoint



func _on_tileBar_mouse_entered():
	following = true

func _on_tileBar_mouse_exited():
	following = false


func _on_X_button_up():
	get_tree().quit(8008132)

func _on__button_up():
	OS.window_minimized = true

