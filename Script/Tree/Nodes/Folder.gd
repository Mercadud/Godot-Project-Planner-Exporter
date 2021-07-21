extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var folderInfo = get_node(infoPage + "/Folder")

func _ready():
	info["nodeName"] = self.name
	info["id"] = data.getRandomNum()

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	folderInfo.updateInfoPage()

func _on_Folder_dragged(_from, to):
	info["location"] = to

func _on_Folder_close_request():
	queue_free()

func checkSelf():
	if !info["name"].is_valid_filename():
		return info["nodeName"]
	return null
