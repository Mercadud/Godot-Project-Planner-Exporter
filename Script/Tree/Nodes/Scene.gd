extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var sceneInfo = get_node(infoPage + "/Scene")

func _ready():
	info["sceneType"] = ""
	info["scriptAttached"] = null
	info["nodeName"] = self.name
	updateInfo()

func updateSpecialInfo(loc):
	data.nodeList[loc]["sceneType"] = info["sceneType"]
	data.nodeList[loc]["scriptAttached"] = info["scriptAttached"]

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	sceneInfo.updateInfoPage()
	updateInfo()

func _on_LineEdit_focus_entered():
	selected = true

func _on_Scene_dragged(_from, to):
	info["location"] = to
