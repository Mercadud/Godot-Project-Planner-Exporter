extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var WEInfo = get_node(infoPage + "/WorldEnvironment")

func _ready():
	info["default"] = false
	info["WEType"] = "Default"
	info["nodeName"] = self.name
	info["id"] = data.getRandomNum()
	print(info["id"])

func updateSpecialInfo(loc):
	data.nodeList[loc]["default"] = info["default"]
	data.nodeList[loc]["WEType"] = info["WEType"]

func updateInfoPage():
	WEInfo.updateInfoPage()

func _on_WorldEnvironment_close_request():
	queue_free()

func _on_WorldEnvironment_dragged(_from, to):
	info["location"] = to

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	WEInfo.updateInfoPage()

func checkSelf():
	if !info["name"].is_valid_filename():
		return info["nodeName"]
	return null
