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

func exportProject():
	var allExported = false
	nodeList = []
	for nodes in get_tree().get_nodes_in_group("node"):
		nodes.updateInfo()
	print(nodeList)
	while (!allExported):
		allExported = true
		for i in nodeList.size():
			if nodeList[i]["isCreated"] == false:
				allExported = false
		if allExported == false:
			var dir = Directory.new()
			for node in nodeList.size():
				if nodeList[node]["parentNode"] == null && !("RootFolder" in nodeList[node]["nodeName"]):
					nodeList[node]["isCreated"] = true
					continue
				var nodeParent = nodeList[node]["parentNode"]
				for parent in nodeList.size():
					if "RootFolder" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
							nodeList[node]["isCreated"] = true
					elif nodeList[parent]["id"] == nodeParent:
						if nodeList[parent]["isCreated"] == true:
							if "Folder" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
								nodeList[node]["isCreated"] = true
							elif "Scene" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
								nodeList[node]["isCreated"] = true
							elif "Script" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
								nodeList[node]["isCreated"] = true
							elif "Node" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
								nodeList[node]["isCreated"] = true
	for i in get_tree().get_nodes_in_group("node"):
		i.info["isCreated"] = false
		i.updateInfo()
		print(i)


func getRandomNum():
	if nodeList.size() != 0:
		for i in get_tree().get_nodes_in_group("node"):
			var num = randi()
			if i.info["id"] != num:
				return num
	else:
		var num = randi()
		return num
