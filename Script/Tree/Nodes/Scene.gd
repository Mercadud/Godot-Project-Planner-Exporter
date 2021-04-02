extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var sceneInfo = get_node(infoPage + "/Scene")

func _ready():
	info["sceneType"] = ""
	info["scriptAttached"] = null

func updateSpecialInfo(loc):
	data.nodeList[loc]["sceneType"] = info["sceneType"]
	data.nodeList[loc]["scriptAttached"] = info["scriptAttached"]

func updateInfoPage():
	sceneInfo.updateInfoPage()

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	updateInfoPage()
	updateInfo()
