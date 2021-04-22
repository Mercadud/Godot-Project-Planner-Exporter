extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var scriptInfo = get_node(infoPage + "/Script")

func _ready():
	info["singleton"] = false
	info["functions"] = []
	info["nodeName"] = self.name
	info["id"] = data.getRandomNum()

func updateSpecialInfo(loc):
	data.nodeList[loc]["functions"] = info["functions"]

func updateInfoPage():
	scriptInfo.updateInfoPage()

func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	updateInfoPage()

func _on_Script_dragged(_from, to):
	info["location"] = to

func _on_Script_close_request():
	queue_free()

func checkSelf():
	if !info["name"].is_valid_filename():
		return info["nodeName"]
	var reg = RegEx.new()
	reg.compile("/^[A-Za-z_]+[(][A-Za-z,_ ]*[)]$/g")
	for function in info["functions"].size():
		var regular = reg.search(info["functions"][function])
		print("RegEx issue: " + str(regular) + " from: " + info["functions"][function])
		if regular == null:
			return info["nodeName"]
	return null
