extends VBoxContainer

var childLoc

onready var textInfo = $"../../../Select/Info/Folder"

func _ready():
	pass

func setNode(n):
	childLoc = n

func _on_OptionButton_item_selected(index):
	pass # Replace with function body.

func updateInfo(arr):
	$SceneName/LineEdit.text = arr.sceneName


func _on_LineEdit_text_changed(new_text):
	pass
