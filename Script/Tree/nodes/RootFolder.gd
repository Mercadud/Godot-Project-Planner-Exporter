extends GraphNode

var info = {
	nodeCode = 0,
	nodeName = self.name,
	location = Vector2(),
	folderName = ""
}

onready var data = $"/root/Saver"

func _ready():
	info.nodeCode = 0

func _on_FolderName_text_changed(new_text):
	info.folderName = new_text
	updateInfo()

func _on_RootFolder_dragged(_from, to):
	info.location = to

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
		data.nodeList[location].values()[2] = info.location
		data.nodeList[location].values()[3] = info.folderName
