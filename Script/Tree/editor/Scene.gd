extends VBoxContainer

var childLoc

onready var sceneName = $SceneName/LineEdit

func _ready():
	pass

func setNode(n):
	childLoc = n

func updateInfoPage():
	sceneName.text = childLoc.info["name"]

func _on_LineEdit_text_changed(new_text):
	childLoc.info["name"] = new_text
	childLoc.updateNode()

func _on_OptionButton_item_selected(index):
	childLoc.info["sceneType"] = $SceneType/OptionButton.get_item_text(index)
