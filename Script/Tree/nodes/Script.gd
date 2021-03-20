extends GraphNode

var connected = false

var info = {
	scriptName = "",
	funtions = []
}

func _ready():
	pass

func connectedToNode():
	connected = true

func disconnectedFromNode():
	connected = false


func _on_LineEdit_text_changed(new_text):
	info.scriptName = new_text


func _on_Script_close_request():
	queue_free()
