extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var folderInfo = get_node(infoPage + "/Folder")

func _ready():
	info["nodeName"] = self.name

func updateSpecialInfo(_loc):
	pass

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	folderInfo.updateInfoPage()
	updateInfo()

func _on_LineEdit_focus_entered():
	selected = true

func _on_Folder_dragged(_from, to):
	info["location"] = to
	updateInfo()
