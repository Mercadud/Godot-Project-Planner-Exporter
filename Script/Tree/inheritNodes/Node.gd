extends "res://Script/Tree/inheritNodes/BaseNode.gd"


func _ready():
	info["nodeType"] = ""

func updateSpecialInfo(loc):
	data.nodeList[loc]["nodeType"] = info["nodeType"]
