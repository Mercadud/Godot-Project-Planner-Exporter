extends Control

onready var graph = $Mount/MainWindow/Editor/Graph/GraphEdit
var ctrlPressed = false

# Everything here is to allow the user to zoom in using ctrl + scroll
# This can probably be moved to the graph, but this is not my priority at the moment

func _process(_delta):
	if Input.is_action_just_pressed("ctrl"):
		graph.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ctrlPressed = true
	elif Input.is_action_just_released("ctrl"):
		graph.mouse_filter = Control.MOUSE_FILTER_STOP
		ctrlPressed = false

func _on_Main_Page_gui_input(event):
	if event.is_pressed() && ctrlPressed:
		if event.button_index == BUTTON_WHEEL_UP:
			graph.zoom += graph.zoom * 0.2
		if event.button_index == BUTTON_WHEEL_DOWN:
			graph.zoom -= graph.zoom * .2
