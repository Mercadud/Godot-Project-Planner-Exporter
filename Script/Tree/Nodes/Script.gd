extends "res://Script/Tree/Nodes/BaseNode.gd"


func _ready():
	info["functions"] = []

func updateSpecialInfo(loc):
	data.nodeList[loc]["functions"] = info["functions"]
