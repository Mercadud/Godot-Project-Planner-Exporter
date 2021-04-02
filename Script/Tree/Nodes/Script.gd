extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var scriptInfo = get_node(infoPage + "/Script")

func _ready():
	info["functions"] = []
	info["nodeName"] = self.name

func updateSpecialInfo(loc):
	data.nodeList[loc]["functions"] = info["functions"]

func updateInfoPage():
	scriptInfo.updateInfoPage()

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	updateInfoPage()
	updateInfo()
