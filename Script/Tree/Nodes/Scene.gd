extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var sceneInfo = get_node(infoPage + "/Scene")

func _ready():
	info["sceneType"] = "Spatial"
	info["scriptAttached"] = null
	info["nodeName"] = self.name
	info["id"] = data.getRandomNum()

func updateSpecialInfo(loc):
	data.nodeList[loc]["sceneType"] = info["sceneType"]
	data.nodeList[loc]["scriptAttached"] = info["scriptAttached"]

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	sceneInfo.updateInfoPage()

func _on_Scene_dragged(_from, to):
	info["location"] = to

func _on_Scene_close_request():
	queue_free()

func checkSelf():
	if !info["name"].is_valid_filename():
		return info["nodeName"]
	return null
