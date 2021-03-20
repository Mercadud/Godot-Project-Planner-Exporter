extends GraphNode

var info = {
	folderName = ""
}

func _ready():
	pass



func _on_FolderName_text_changed(new_text):
	info.folderName = new_text
