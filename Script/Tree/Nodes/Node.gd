extends "res://Script/Tree/Nodes/BaseNode.gd"


func _ready():
	info["nodeType"] = ""

func updateSpecialInfo(loc):
	data.nodeList[loc]["nodeType"] = info["nodeType"]
