extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var folderInfo = get_node(infoPage + "/Folder")

func _ready():
	pass

func updateSpecialInfo(_loc):
	pass

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	folderInfo.updateInfoPage()
	updateInfo()
