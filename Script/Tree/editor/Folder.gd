extends VBoxContainer

var childLoc

onready var folderName = $FolderName/LineEdit

func _ready():
	pass

func setNode(n):
	childLoc = n
	updateInfoPage()

func updateInfoPage():
	folderName.text = childLoc.info["name"]

func _on_LineEdit_text_changed(new_text):
	childLoc.info["name"] = new_text
	childLoc.updateNode()
