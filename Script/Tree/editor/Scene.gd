extends VBoxContainer

var childLoc

onready var sceneName = $SceneName/LineEdit
onready var sceneType = $SceneType/OptionButton

func _ready():
	pass

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
	childLoc.info["sceneType"] = $SceneType/OptionButton.get_item_text(index)
