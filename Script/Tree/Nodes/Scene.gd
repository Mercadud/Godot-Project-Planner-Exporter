extends "res://Script/Tree/Nodes/BaseNode.gd"


func _ready():
	info["sceneType"] = ""
	info["scriptAttached"] = null

func updateSpecialInfo(loc):
	data.nodeList[loc]["sceneType"] = info["sceneType"]
	data.nodeList[loc]["scriptAttached"] = info["scriptAttached"]
