extends VBoxContainer

var childLoc

onready var folderName = $FolderName/LineEdit
onready var projectName = $ProjectName/LineEdit
onready var driverName = $DriverName/OptionButton
onready var windowHeight = $WindowHeight/SpinBox
onready var windowWidth = $WindowWidth/SpinBox

func setNode(n):
	childLoc = n
	updateInfoPage()

func updateInfoPage():
	folderName.text = childLoc.info["name"]
	projectName.text = childLoc.info["projectName"]
	for i in driverName.get_item_count():
		if childLoc.info["driverName"] == driverName.get_item_text(i):
			driverName.select(i)
	windowHeight.value = childLoc.info["projectHeight"]
	windowWidth.value = childLoc.info["projectWidth"]

func _on_LineEdit_text_changed(new_text):
	childLoc.info["name"] = new_text
	childLoc.updateNode()

func _on_Window_Height_value_changed(value):
	childLoc.info["projectHeight"] = value

func _on_Window_Width_value_changed(value):
	childLoc.info["projectWidth"] = value

func _on_Project_Name_text_changed(new_text):
	childLoc.info["projectName"] = new_text
