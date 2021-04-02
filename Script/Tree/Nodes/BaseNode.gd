extends GraphNode

var info = {
	"id":0,
	"nodeName":self.name,
	"parentNode":null,
	"isCreated":false,
	"location":Vector2(),
	"name":""
}

onready var data = $"/root/Saver"
var infoPage = "../../../Select/Info"

func ready():
	pass
 
func updateInfo():
	var exist = false
	var location
	for i in data.nodeList.size():
		if data.nodeList[i]["id"] == info["id"]:
			exist = true
			location = i
			break
	if (!exist):
		data.nodeList.push_back(info)
	if exist:
		data.nodeList[location]["location"] = info["location"]
		updateSpecialInfo(location)
	

func updateSpecialInfo(_loc):
	print("badNews // updateSpecialInfo()")

func updateInfoPage():
	print("badNews // updateInfoPage()")

func updateNode():
	$LineEdit.text = info["name"]
	updateInfo()
