extends "res://Script/Tree/Nodes/BaseNode.gd"

onready var folderInfo = get_node(infoPage + "/Folder")

# adds the info required for this node
func _ready():
	info["nodeName"] = self.name
	info["id"] = data.getRandomNum()

# changes the text of the info page
func _on_LineEdit_text_changed(new_text):
	info["name"] = new_text
	folderInfo.updateInfoPage()

# updates the location of the folder
func _on_Folder_dragged(_from, to):
	info["location"] = to

# calls the close function
func _on_Folder_close_request():
	queue_free()

# this checks to make sure it is exportable
func checkSelf():
	if !info["name"].is_valid_filename():
		return info["nodeName"]
	return null
