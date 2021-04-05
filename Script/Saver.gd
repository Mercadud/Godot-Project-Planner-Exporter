extends Node

var exportDirLocation
var SaveFileLocation
var loadedNewProject = false
var nodeList = []

func save():
	nodeList = []
	for nodes in get_tree().get_nodes_in_group("node"):
		nodes.updateInfo()
	print(nodeList)
	var file = File.new()
	file.open(SaveFileLocation, File.WRITE)
	file.store_var(nodeList)
	file.close()

func loadProject():
	var file = File.new()
	file.open(SaveFileLocation, File.READ)
	nodeList = file.get_var()
	file.close()
	loadedNewProject = true

func import():
	var dir = Directory.new()
	dir.open(exportDirLocation)
	###I have no clue what happens now...

func getRandomNum():
	if nodeList.size() != 0:
		for i in nodeList.size():
			var num = randi()
			if nodeList[i]["id"] == num:
				continue
			else:
				return num
	else:
		var num = randi()
		return num
