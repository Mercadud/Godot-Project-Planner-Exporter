extends VBoxContainer

var childLoc

onready var nodeName = $NodeName/LineEdit
onready var nodeType = $NodeType/LineEdit

func _ready():
	pass

func setNode(e):
	childLoc = e
	updateInfoPage()

func updateInfoPage():
	nodeName.text = childLoc.info["name"]
	nodeType.text = childLoc.info["nodeType"]

func _on_LineEdit_text_changed(new_text):
	childLoc.info["name"] = new_text
	childLoc.updateNode()

func _on_nodeType_text_changed(new_text):
	childLoc.info["nodeType"] = new_text
