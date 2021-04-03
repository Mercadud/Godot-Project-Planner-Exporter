extends GridContainer

onready var fileMenu = $File
onready var editMenu = $Edit
onready var fileLocation = $"../../FileDialog"
onready var data = $"/root/Saver"

func _ready():
	fileMenu.get_popup().connect("id_pressed", self, "_on_File_item_pressed")
	editMenu.get_popup().connect("id_pressed", self, "_on_Edit_item_pressed")

func _process(_delta):
	if Input.is_action_just_pressed("save"):
		SavePressed()

func _on_File_item_pressed(id):
	if id == 0:
		NewPressed()
	elif id == 1:
		OpenPressed()
	elif id == 2:
		SavePressed()
	elif id == 3:
		ExportPressed()
	elif id == 4:
		QuitPressed()

func _on_Edit_item_pressed(id):
	if id == 0:
		undoPressed()
	elif id == 1:
		redoPressed()

func NewPressed():
	var nodes = get_tree().get_nodes_in_group("nodes")
	for i in nodes:
		print(i)
		i.queue_free()

func OpenPressed():
	fileLocation.mode = FileDialog.MODE_OPEN_FILE
	fileLocation.popup_centered()

func SavePressed():
	fileLocation.mode = FileDialog.MODE_SAVE_FILE
	fileLocation.popup_centered()

func ExportPressed():
	pass

func QuitPressed():
	get_tree().quit(-1)

func _on_FileDialog_dir_selected(dir):
	data.exportDirLocation = dir

func _on_FileDialog_file_selected(path):
	data.SaveFileLocation = path
	if fileLocation.mode == FileDialog.MODE_SAVE_FILE:
		data.save()
	elif fileLocation.mode == FileDialog.MODE_OPEN_FILE:
		NewPressed()
		data.loadProject()

func undoPressed():
	pass

func redoPressed():
	pass
