extends "res://Script/Tree/inheritNodes/BaseNode.gd"


func _ready():
	info["functions"] = []

func updateSpecialInfo(loc):
	data.nodeList[loc]["functions"] = info["functions"]
