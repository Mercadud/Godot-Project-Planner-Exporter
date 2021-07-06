extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var nodeInfo = get_node(infoPage + "/Node")

func _ready():
	info["nodeType"] = ""
	info["nodeName"] = self.name
	info["id"] = data.getRandomNum()

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	nodeInfo.updateInfoPage()

func updateNode():
	$LineEdit.text = info["name"]
	update()

func _on_Node_dragged(_from, to):
	info["location"] = to

func _on_Node_close_request():
	queue_free()

func checkSelf():
	if !info["name"].is_valid_filename():
		return info["nodeName"]
	return null
