extends VBoxContainer

var childLoc

onready var sceneName = $SceneName/LineEdit
onready var sceneType = $SceneType/OptionButton
onready var connectScript = $ConnectScript/OptionButton

func setNode(n):
	childLoc = n
	updateInfoPage()

func updateInfoPage():
	sceneName.text = childLoc.info["name"]
	for i in sceneType.get_item_count():
		if childLoc.info["sceneType"] == sceneType.get_item_text(i):
			sceneType.select(i)

func _on_LineEdit_text_changed(new_text):
	childLoc.info["name"] = new_text
	childLoc.updateNode()

func _on_OptionButton_item_selected(index):
	childLoc.info["sceneType"] = sceneType.get_item_text(index)

#func _on_OptionButton_button_up():
#	var items = connectScript.get_item_count()
#	for i in items:
#		if i < 1:
#			continue
#		print("removing " + str(i))
#		connectScript.remove_item(i)
#	var itemCount = 1
#	print(connectScript)
#	for node in get_tree().get_nodes_in_group("Script"):
#		print("adding " + str(itemCount))
#		connectScript.add_item(node.info["name"], itemCount)
#		itemCount += 1
