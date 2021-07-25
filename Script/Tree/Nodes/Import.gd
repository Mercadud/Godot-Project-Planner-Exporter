extends "res://Script/Tree/Nodes/BaseNode.gd"

# adds the info required for this node
func _ready():
	info["importLocation"] = ""
	info["id"] = data.getRandomNum()
	info["nodeName"] = self.name
	info["name"] = "import"
	print(info["id"])

func _on_Import_dragged(_from, to):
	info["location"] = to

func _on_Import_close_request():
	queue_free()

func checkSelf():
	var file = File.new()
	if !file.file_exists(info["importLocation"]):
		return info["nodeName"]
	return null
