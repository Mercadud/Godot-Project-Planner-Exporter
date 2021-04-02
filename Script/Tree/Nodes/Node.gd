extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var nodeInfo = get_node(infoPage + "/Node")

func _ready():
	info["nodeType"] = ""
	info["nodeName"] = self.name

func updateSpecialInfo(loc):
	data.nodeList[loc]["nodeType"] = info["nodeType"]

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	nodeInfo.updateInfoPage()
	updateInfo()

func updateNode():
	$LineEdit.text = info["name"]
	update()

func _on_LineEdit_focus_entered():
	selected = true

func _on_Node_dragged(_from, to):
	info["location"] = to
	updateInfo()
