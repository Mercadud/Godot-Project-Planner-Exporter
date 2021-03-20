extends GraphNode

var connected = false

var info = {
	sceneName = "",
	sceneType = "",
	attachedScript = ""
}

func _ready():
	pass

func connectedToNode():
	connected = true

func disconnectedFromNode():
	connected = false

func _on_LineEdit_text_changed(new_text):
	info.sceneName = new_text


func _on_Scene_close_request():
	queue_free()
