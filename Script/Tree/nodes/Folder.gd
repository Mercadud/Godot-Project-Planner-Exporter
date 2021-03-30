extends GraphNode

var info = {
	nodeCode = 0,
	nodeName = self.name,
	parentNode = null,
	isCreated = false,
	location = Vector2(),
	folderName = ""
}

onready var data = $"/root/Saver"
onready var textInfo = $"../../../Select/Info/Folder"


func _ready():
	info.nodeCode = data.getRandomNum()


func _on_FolderName_text_changed(new_text):
	info.folderName = new_text
	textInfo.updateInfo(info)
	updateInfo()

func FolderNameUpdate(t):
	$FolderName.text = t

func _on_Folder_close_request():
	for i in data.nodeList.size():
		if data.nodeList[i].values()[0] == info.nodeCode:
			data.nodeList.remove(i)
			break
	queue_free()

func _on_Folder_dragged(_from, to):
	info.location = to
	updateInfo()

func updateInfo():
	var exist = false
	var location
	for i in data.nodeList.size():
		if data.nodeList[i].values()[0] == info.nodeCode:
			exist = true
			location = i
			break
	if (!exist):
		data.nodeList.push_back(info)
	if exist:
		data.nodeList[location].values()[4] = info.location
		data.nodeList[location].values()[5] = info.folderName
