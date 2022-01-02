extends GridContainer

onready var fileMenu = $File
onready var editMenu = $Edit
onready var helpMenu = $Help
onready var fileLocation = $"../../FileDialog"
onready var windowMessage = $"../../WindowDialog"
onready var data = $"/root/Saver"
onready var graphEdit = $"../../Editor/Graph/GraphEdit"

var fileGetType;

enum GetType {
	SAVE,
	LOAD,
	IMPORT,
	EXPORT
}

func _ready():
	fileMenu.get_popup().connect("id_pressed", self, "_on_File_item_pressed")
	editMenu.get_popup().connect("id_pressed", self, "_on_Edit_item_pressed")
	helpMenu.get_popup().connect("id_pressed", self, "_on_Help_item_pressed")

func _process(_delta):
	if Input.is_action_just_pressed("save"):
		SavePressed()

func _on_File_item_pressed(id):
	if id == 0:
		NewPressed()
	elif id == 1:
		fileGetType = GetType.LOAD
		LoadPressed()
	elif id == 2:
		fileGetType = GetType.IMPORT
		ImportPressed()
	elif id == 3:
		fileGetType = GetType.SAVE
		SavePressed()
	elif id == 4:
		fileGetType = GetType.EXPORT
		ExportPressed()
	elif id == 5:
		QuitPressed()

func _on_Edit_item_pressed(id):
	if id == 0:
		undoPressed()
	elif id == 1:
		redoPressed()
	elif id == 2:
		fullscreenPressed()

func _on_Help_item_pressed(_id):
	contactPressed()

func NewPressed():
	graphEdit.disconnect_all()
	for i in get_tree().get_nodes_in_group("node"):
		if "RootFolder" in i.info["nodeName"]:
			i.info["name"] = ""
			i.info["id"] = data.getRandomNum()
			i.info["driverName"] = "GLES3"
			i.info["projectName"] = ""
			i.info["projectHeight"] = 1024
			i.info["projectWidth"] = 600
			continue
		i.queue_free()

func LoadPressed() -> void :
	fileLocation.mode = FileDialog.MODE_OPEN_FILE
	fileLocation.filters = ["*.GPPE"]
	fileLocation.popup_centered()

func ImportPressed() -> void:
	fileLocation.mode = FileDialog.MODE_OPEN_FILE
	fileLocation.filters = ["project.godot"]
	fileLocation.popup_centered()

func SavePressed() -> void :
	fileLocation.mode = FileDialog.MODE_SAVE_FILE
	fileLocation.popup_centered()

func ExportPressed() -> void :
	fileLocation.mode = FileDialog.MODE_OPEN_DIR
	fileLocation.popup_centered()

func QuitPressed() -> void:
	get_tree().quit(-1)

func _on_FileDialog_dir_selected(dir) -> void:
	data.exportDirLocation = dir
	if fileLocation.mode == FileDialog.MODE_OPEN_DIR:
		if data.exportProject():
			windowMessage.dialog_text = "Export Successful"
			windowMessage.popup_centered()

func _on_FileDialog_file_selected(path) -> void:
	data.SaveFileLocation = path
	if fileGetType == GetType.SAVE:
		if data.save():
			windowMessage.dialog_text = "Save successful"
			windowMessage.popup_centered()
		else:
			windowMessage.dialog_text = "Save Failed!\n If this persists, contact the developer"
			windowMessage.popup_centered()
	elif fileGetType == GetType.LOAD:
		if data.loadProject():
			windowMessage.dialog_text = "load successful"
			windowMessage.popup_centered()
		else:
			windowMessage.dialog_text = "Load Failed!\n If this persists, open an issue in the Github"
			windowMessage.popup_centered()
	elif fileGetType == GetType.IMPORT:
		if data.import():
			windowMessage.dialog_text = "import successful"
			windowMessage.popup_centered()

func undoPressed():
	pass

func redoPressed():
	pass

func fullscreenPressed():
	OS.window_fullscreen = !OS.window_fullscreen

func errExport(message : String):
	windowMessage.dialog_text = "Export Failed! The following nodes have issues: " + message
	windowMessage.popup_centered()


func contactPressed():
	if OS.shell_open("https://github.com/Mercadud/Godot-Project-Planner-Exporter/issues/new/choose") == OK:
		print("opened Issue")
