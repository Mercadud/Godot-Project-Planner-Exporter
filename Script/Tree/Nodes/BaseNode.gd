extends GraphNode

# This holds all the info of a node
var info = {
	"id":null,
	"nodeName":null,
	"parentNode":null,
	"isCreated":false,
	"location":Vector2(),
	"name":"",
	"path":""
}

onready var data = $"/root/Saver"
var infoPage = "../../../Select/Info"

func ready():
	pass
 
# this updates all the info of all the nodes
func updateInfo():
	var exist = false
	var location
	for i in data.nodeList.size():
		if data.nodeList[i]["id"] == info["id"]:
			exist = true
			location = i
			break
	if !exist:
		data.nodeList.push_back(info)
	if exist:
		data.nodeList[location] = info

# just some placeholder functions
func updateInfoPage():
	print("badNews // updateInfoPage()")

# updates the text on a node
func updateNode():
	$LineEdit.text = info["name"]

# just some placeholder functions
func checkSelf():
	print("badNews // checkSelf()")
	return null
