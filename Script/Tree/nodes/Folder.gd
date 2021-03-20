extends GraphNode

var connected = false

var info = {
	folderName = ""
}

func _ready():
	pass

func connectedToNode():
	connected = true

func disconnectedFromNode():
	connected = false

func _on_FolderName_text_changed(new_text):
	info.folderName = new_text


func _on_Folder_close_request():
	queue_free()
