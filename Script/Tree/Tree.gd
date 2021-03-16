extends Control

onready var graph = $GraphEdit
onready var rightClic = $"right Click"

func _ready():
	rightClic.get_popup().add_item("Root")
	rightClic.get_popup().add_item("Scene")
	rightClic.get_popup().add_item("node")
	rightClic.get_popup().add_item("Script")
	


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	graph.connect_node(from, from_slot, to, to_slot)


func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	graph.disconnect_node(from, from_slot, to, to_slot)

func _input(event):
	if Input.is_action_just_pressed("right Click"):
		rightClic.visible = true
		rightClic.disabled = false
		rightClic.get_popup().popup(Rect2(get_local_mouse_position(), Vector2(100, 80) ))
	elif Input.is_action_just_pressed("leftClick"):
		rightClic.visible = false
		rightClic.disabled = true


func _on_GraphEdit_gui_input(event):
	if Input.is_action_just_pressed("right Click"):
		rightClic.visible = true
		rightClic.disabled = false
		rightClic.rect_position = get_local_mouse_position()
	if Input.is_action_just_pressed("leftClick"):
		rightClic.visible = false
		rightClic.disabled = true
