extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var folderInfo = get_node(infoPage + "/RootFolder")

func _ready():
	info["nodeName"] = self.name
	info["id"] = data.getRandomNum()
	info["driverName"] = "GLES3"
	info["projectName"] = ""
	info["projectHeight"] = 1024
	info["projectWidth"] = 600

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	folderInfo.updateInfoPage()

func _on_RootFolder_dragged(_from, to):
	info["location"] = to

func checkSelf():
	if !info["name"].is_valid_filename():
		return info["nodeName"]
	elif info["projectName"] == "":
		return info["nodeName"]
	return null
