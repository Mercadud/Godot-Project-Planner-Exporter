extends VBoxContainer

var childLoc


onready var WEType = $WEType/OptionButton

func setNode(e):
	childLoc = e
	updateInfoPage()

func updateInfoPage():
	$NodeName/LineEdit.text = childLoc.info["name"]
	for i in WEType.get_item_count():
		if childLoc.info["WEType"] == WEType.get_item_text(i):
			WEType.select(i)

func _on_LineEdit_text_changed(new_text):
	childLoc.info["name"] = new_text
	childLoc.updateNode()


func _on_OptionButton_item_selected(index):
	childLoc.info["WEType"] = WEType.get_item_text(index)
