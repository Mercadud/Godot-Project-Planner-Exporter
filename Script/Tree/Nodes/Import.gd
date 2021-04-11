extends "res://Script/Tree/Nodes/BaseNode.gd"

func _ready():
	info["importLocation"] = ""
	info["id"] = data.getRandomNum()
	info["nodeName"] = self.name
	info["name"] = "import"

func updateSpecialInfo(loc):
	data.nodeList[loc]["importLocation"] = info["importLocation"]

func _on_Import_dragged(_from, to):
	info["location"] = to

func _on_Import_close_request():
	queue_free()
