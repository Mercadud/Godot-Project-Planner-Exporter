extends GraphNode

var connected = false

var info = {
	nodeType = "Node",
	nodeName = ""
}

func _ready():
	pass

func connectedToNode():
	connected = true

func disconnectedFromNode():
	connected = false


func _on_LineEdit_text_changed(new_text):
	info.nodeName = new_text


func _on_Node_close_request():
	queue_free()
