extends Node

var exportDirLocation
var SaveFileLocation
var loadedNewProject = false
var nodeList = []

func save():
	nodeList = []
	for nodes in get_tree().get_nodes_in_group("node"):
		nodes.updateInfo()
	var file = File.new()
	file.open(SaveFileLocation, File.WRITE)
	file.store_var(nodeList)
	file.close()
	###this should never fail###
	return true

func loadProject():
	var file = File.new()
	file.open(SaveFileLocation, File.READ)
	nodeList = file.get_var()
	file.close()
	loadedNewProject = true
	###this should never fail###
	return true

func import():
	var dir = Directory.new()
	dir.open(exportDirLocation)
	###I have no clue what happens now...

func exportProject():
	for node in get_tree().get_nodes_in_group("node"):
		if node.info["name"] == "":
			return false
	var allExported = false
	nodeList = []
	for nodes in get_tree().get_nodes_in_group("node"):
		nodes.updateInfo()
	while (!allExported):
		allExported = true
		for i in nodeList.size():
			if nodeList[i]["isCreated"] == false:
				allExported = false
		if allExported == false:
			for node in nodeList.size():
				if nodeList[node]["parentNode"] == null && !("RootFolder" in nodeList[node]["nodeName"]):
					nodeList[node]["isCreated"] = true
					continue
				var nodeParent = nodeList[node]["parentNode"]
				for parent in nodeList.size():
					if "RootFolder" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
						nodeList[node]["path"] = exportDirLocation
						var dir = Directory.new()
						dir.open(nodeList[node]["path"])
						dir.make_dir(nodeList[node]["name"])
						nodeList[node]["path"] = exportDirLocation + "/" + nodeList[node]["name"]
						var file = File.new()
						file.open(nodeList[node]["path"] + "/project.godot", File.WRITE)
						file.store_string("config_version=4\n\n_global_script_classes=[  ]\n_global_script_class_icons={\n\n}\n\n[application]\nconfig/name=\""
						+ nodeList[node]["name"] + "\"")
						nodeList[node]["isCreated"] = true
						
					elif nodeList[parent]["id"] == nodeParent:
						if nodeList[parent]["isCreated"] == true && nodeList[node]["isCreated"] == false:
							##Folder###
							if "Folder" in nodeList[node]["nodeName"]:
								nodeList[node]["path"] = nodeList[parent]["path"]
								var dir = Directory.new()
								dir.open(nodeList[node]["path"])
								dir.make_dir(nodeList[node]["name"])
								nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"]
								nodeList[node]["isCreated"] = true
							###Scene###
							elif "Scene" in nodeList[node]["nodeName"]:
								nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"] + ".tscn"
								var file = File.new()
								file.open(nodeList[node]["path"], File.WRITE)
								file.store_string("[gd_scene format=2]\n\n[node name=\"" + nodeList[node]["name"] + "\" type=\"" + nodeList[node]["sceneType"] +"\"]")
								nodeList[node]["isCreated"] = true
							###Script###
							elif "Script" in nodeList[node]["nodeName"]:
								nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"] + ".gd"
								var file = File.new()
								file.open(nodeList[node]["path"], File.WRITE)
								file.store_string("extends Node")
								for i in nodeList[node]["functions"].size():
									if "()" in nodeList[node]["functions"][i]:
										file.store_string("\n\n" + "func " + nodeList[node]["functions"][i] + ":pass")
									else:
										file.store_string("\n\n" + "func " + nodeList[node]["functions"][i] + "():pass")
								nodeList[node]["isCreated"] = true
							###Node###
							elif "Node" in nodeList[node]["nodeName"]:
								###This will be done once Godot 4 comes out###
								nodeList[node]["path"] = nodeList[parent]["path"]
								nodeList[node]["isCreated"] = true
							###Import###
							elif "Import" in nodeList[node]["nodeName"]:
								nodeList[node]["path"] = nodeList[parent]["path"] + "/"
								var dir = Directory.new()
								dir.open(nodeList[node]["importLocation"])
								var fileName = nodeList[node]["importLocation"].split("/")
								print(nodeList[node]["path"] + fileName[fileName.size() - 1])
								dir.copy(nodeList[node]["importLocation"],  nodeList[node]["path"] + "/" + fileName[fileName.size() - 1])
								nodeList[node]["isCreated"] = true
	for i in get_tree().get_nodes_in_group("node"):
		i.info["isCreated"] = false
		i.updateInfo()
	return true

func getRandomNum():
	if nodeList.size() != 0:
		for i in get_tree().get_nodes_in_group("node"):
			var num = randi()
			if i.info["id"] != num:
				return num
	else:
		var num = randi()
		return num
