extends VBoxContainer

var childLoc

onready var importLoc = $ImportLocation/LineEdit
onready var fileSelect = $"../../../../ImportFile"

func _ready():
	pass

func setNode(e):
	childLoc = e
	updateInfoPage()

func updateInfoPage():
	if childLoc.info["importLocation"] == "":
		importLoc.text = "Not Selected"
	else:
		importLoc.text = childLoc.info["importLocation"]


func _on_ImportFile_file_selected(path):
	importLoc.text = path
	childLoc.info["importLocation"] = path


func _on_Button_button_up():
	fileSelect.popup_centered()
