extends VBoxContainer

var childLoc

func _ready():
	pass

func setNode(n):
	childLoc = n
	updateInfo(childLoc.info)

func _on_LineEdit_text_changed(new_text):
	childLoc.FolderNameUpdate(new_text)

func updateInfo(arr):
	$FolderName/LineEdit.text = arr.folderName
