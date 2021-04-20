extends Node

var exportDirLocation
var SaveFileLocation
var loadedNewProject = false
var nodeList = []

var progressBarLength
var progress

func save():
	nodeList = []
	var dir = Directory.new()
	dir.remove(SaveFileLocation)
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


###EXPORT THE WHOLE PROJECT###

var rootFolderLocation
var resLoc

func exportProject():
	var thread = Thread.new()
	thread.start(self, "threadedExport", "Running Export")
	thread.wait_to_finish()


func threadedExport(exportStatus):
	print(exportStatus)
	nodeList = []
	#Add Root Folder to Array
	for node in get_tree().get_nodes_in_group("node"):
		print("checking " + str(node.info["nodeName"]))
		if "RootFolder" in node.info["nodeName"]:
			node.updateInfo()
			print(nodeList)
	exportRootFolder()
	
	#Add Folders to array
	for node in get_tree().get_nodes_in_group("node"):
		if "Folder" in node.info["nodeName"]:
			node.updateInfo()
	exportFolders()
	
	#Add Scripts to array
	for node in get_tree().get_nodes_in_group("node"):
		if "Script" in node.info["nodeName"]:
			node.updateInfo()
	exportScripts()
	
	#Add World Environments to array
	for node in get_tree().get_nodes_in_group("node"):
		if "WorldEnvironment" in node.info["nodeName"]:
			node.updateInfo()
	exportWorldEnvironment()
	
	#Add Scenes to array
	for node in get_tree().get_nodes_in_group("node"):
		if "Scene" in node.info["nodeName"]:
			node.updateInfo()
	exportScenes()
	
	#complete export
	exportGodotProject()
	
	###reset everything###
	for i in get_tree().get_nodes_in_group("node"):
		i.info["isCreated"] = false


func exportRootFolder():
	print("started Root Folder Export")
	var node = 0
	nodeList[node]["path"] = exportDirLocation
	var dir = Directory.new()
	dir.open(nodeList[node]["path"])
	dir.make_dir(nodeList[node]["name"])
	nodeList[node]["path"] = exportDirLocation + "/" + nodeList[node]["name"]
	rootFolderLocation = node
	resLoc = nodeList[node]["path"].length()
	nodeList[node]["isCreated"] = true
	progress += 1

func exportFolders():
	var allExported = false
	while !allExported:
		allExported = true
		for i in nodeList.size():
			if "Folder" in nodeList[i]["nodeName"]:
				if nodeList[i]["isCreated"] == false:
					allExported = false
		if !allExported:
			for node in nodeList.size():
				if "Folder" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
					for parent in nodeList.size():
						if nodeList[parent]["isCreated"]:
							nodeList[node]["path"] = nodeList[parent]["path"]
							var dir = Directory.new()
							dir.open(nodeList[node]["path"])
							dir.make_dir(nodeList[node]["name"])
							nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"] + "/"
							nodeList[node]["isCreated"] = true

func exportScripts():
	var allExported = false
	while !allExported:
		allExported = true
		for i in nodeList.size():
			if "Script" in nodeList[i]["nodeName"]:
				if nodeList[i]["isCreated"] == false:
					allExported = false
		if !allExported:
			for node in nodeList.size():
				if "Script" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
					for parent in nodeList.size():
						if nodeList[parent]["isCreated"]:
							nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"] + ".gd"
							var file = File.new()
							file.open(nodeList[node]["path"], File.WRITE)
							file.store_string("extends Node")
							for i in nodeList[node]["functions"].size():
									file.store_string("\n\n" + "func " + nodeList[node]["functions"][i] + "():\n\tpass")
							nodeList[node]["isCreated"] = true

func exportWorldEnvironment():
	var allExported = false
	while !allExported:
		allExported = true
		for i in nodeList.size():
			if "WorldEnvironment" in nodeList[i]["nodeName"]:
				if nodeList[i]["isCreated"] == false:
					allExported = false
		if !allExported:
			for node in nodeList.size():
				if "WorldEnvironment" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
					for parent in nodeList.size():
						if nodeList[parent]["isCreated"]:
							nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"] + ".tres"
							var dir = Directory.new()
							dir.copy("res://templates/WorldEnv/" + nodeList[node]["WEType"] + ".tres", nodeList[node]["path"])
							nodeList[node]["isCreated"] = true

func exportScenes():
	var allExported = false
	while !allExported:
		allExported = true
		for i in nodeList.size():
			if "Scene" in nodeList[i]["nodeName"]:
				if nodeList[i]["isCreated"] == false:
					allExported = false
		if !allExported:
			for node in nodeList.size():
				if "Scene" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
					for parent in nodeList.size():
						if nodeList[parent]["isCreated"]:
							nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"] + ".tscn"
							var file = File.new()
							file.open(nodeList[node]["path"], File.WRITE)
							file.store_string("[gd_scene format=2]\n\n[node name=\"" + nodeList[node]["name"] + "\" type=\"" + nodeList[node]["sceneType"] +"\"]")
							nodeList[node]["isCreated"] = true

func exportGodotProject():
	var file = File.new()
	file.open(nodeList[rootFolderLocation]["path"] + "/project.godot", File.WRITE)
	file.store_string("config_version=4\n\n_global_script_classes=[  ]\n_global_script_class_icons={\n\n}\n\n[application]\nconfig/name=\""
	+ nodeList[rootFolderLocation]["name"] + "\"\n\n")
	var ScriptSingleton = false
	for i in nodeList.size():
		if "Script" in nodeList[i]["nodeName"]:
			if nodeList[i]["singleton"] == true:
				ScriptSingleton = true
	if ScriptSingleton:
		file.store_string("[autoload]\n\n")
		for i in nodeList.size():
			if "Script" in nodeList[i]["nodeName"]:
				if nodeList[i]["singleton"]:
					file.store_string(nodeList[i]["name"] + "=\"*res:/" + nodeList[i]["path"].substr(resLoc, nodeList[i]["path"].length()) + "\"\n")

func getRandomNum():
	if nodeList.size() != 0:
		for i in get_tree().get_nodes_in_group("node"):
			var num = randi()
			if i.info["id"] != num:
				return num
	else:
		var num = randi()
		return num

func _exit_tree():
	pass


###GRAVEYARD###
#func oldExportMethod:
	###OLD EXPORT METHOD###
	
#	for node in get_tree().get_nodes_in_group("node"):
#		if node.info["name"] == "":
#			return false
#		if "import" in  node.info["nodeName"]:
#			if node.info["importLocation"] == "":
#				return false
#		if "Script" in node.info["nodeName"]:
#			for i in node.info["functions"].size():
#				if node.info["functions"][i] == "":
#					return false
#	var allExported = false
#	nodeList = []
#	for nodes in get_tree().get_nodes_in_group("node"):
#		nodes.updateInfo()
#	while (!allExported):
#		allExported = true
#		for i in nodeList.size():
#			if nodeList[i]["isCreated"] == false:
#				allExported = false
#		if allExported == false:
#			for node in nodeList.size():
#				if nodeList[node]["parentNode"] == null && !("RootFolder" in nodeList[node]["nodeName"]):
#					nodeList[node]["isCreated"] = true
#					continue
#				var nodeParent = nodeList[node]["parentNode"]
#				for parent in nodeList.size():
#					if "RootFolder" in nodeList[node]["nodeName"] && nodeList[node]["isCreated"] == false:
#						nodeList[node]["path"] = exportDirLocation
#						var dir = Directory.new()
#						dir.open(nodeList[node]["path"])
#						dir.make_dir(nodeList[node]["name"])
#						nodeList[node]["path"] = exportDirLocation + "/" + nodeList[node]["name"]
#						rootFolderLocation = node
#						resLoc = nodeList[node]["path"].length()
#						nodeList[node]["isCreated"] = true
#					elif nodeList[parent]["id"] == nodeParent:
#						if nodeList[parent]["isCreated"] == true && nodeList[node]["isCreated"] == false:
#							##Folder###
#							if "Folder" in nodeList[node]["nodeName"]:
#								nodeList[node]["path"] = nodeList[parent]["path"]
#								var dir = Directory.new()
#								dir.open(nodeList[node]["path"])
#								dir.make_dir(nodeList[node]["name"])
#								nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"]
#								nodeList[node]["isCreated"] = true
#							###Scene###
#							elif "Scene" in nodeList[node]["nodeName"]:
#								nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"] + ".tscn"
#								var file = File.new()
#								file.open(nodeList[node]["path"], File.WRITE)
#								file.store_string("[gd_scene format=2]\n\n[node name=\"" + nodeList[node]["name"] + "\" type=\"" + nodeList[node]["sceneType"] +"\"]")
#								nodeList[node]["isCreated"] = true
#							###Script###
#							elif "Script" in nodeList[node]["nodeName"]:
#								nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"] + ".gd"
#								var file = File.new()
#								file.open(nodeList[node]["path"], File.WRITE)
#								file.store_string("extends Node")
#								for i in nodeList[node]["functions"].size():
#									if "()" in nodeList[node]["functions"][i]:
#										file.store_string("\n\n" + "func " + nodeList[node]["functions"][i] + ":pass")
#									else:
#										file.store_string("\n\n" + "func " + nodeList[node]["functions"][i] + "():pass")
#								nodeList[node]["isCreated"] = true
#							###Node###
#							elif "Node" in nodeList[node]["nodeName"]:
#								###This will be done once Godot 4 comes out###
#								nodeList[node]["path"] = nodeList[parent]["path"]
#								nodeList[node]["isCreated"] = true
#							###Import###
#							elif "Import" in nodeList[node]["nodeName"]:
#								nodeList[node]["path"] = nodeList[parent]["path"] + "/"
#								var dir = Directory.new()
#								dir.open(nodeList[node]["importLocation"])
#								var fileName = nodeList[node]["importLocation"].split("/")
#								print(nodeList[node]["path"] + fileName[fileName.size() - 1])
#								dir.copy(nodeList[node]["importLocation"],  nodeList[node]["path"] + "/" + fileName[fileName.size() - 1])
#								nodeList[node]["isCreated"] = true
#							###WorldEnvironment###
#							elif "WorldEnvironment" in nodeList[node]["nodeName"]:
#								nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"] + ".tres"
#								var dir = Directory.new()
#								dir.copy("res://templates/WorldEnv/" + nodeList[node]["WEType"] + ".tres", nodeList[node]["path"])
#								nodeList[node]["isCreated"] = true
#	###create the project.godot file###
#	var file = File.new()
#	file.open(nodeList[rootFolderLocation]["path"] + "/project.godot", File.WRITE)
#	file.store_string("config_version=4\n\n_global_script_classes=[  ]\n_global_script_class_icons={\n\n}\n\n[application]\nconfig/name=\""
#	+ nodeList[rootFolderLocation]["name"] + "\"\n\n")
#	var ScriptSingleton = false
#	for i in nodeList.size():
#		if "Script" in nodeList[i]["nodeName"]:
#			if nodeList[i]["singleton"] == true:
#				ScriptSingleton = true
#	if ScriptSingleton:
#		file.store_string("[autoload]\n\n")
#		for i in nodeList.size():
#			if "Script" in nodeList[i]["nodeName"]:
#				if nodeList[i]["singleton"]:
#					file.store_string(nodeList[i]["name"] + "=\"*res:/" + nodeList[i]["path"].substr(resLoc, nodeList[i]["path"].length()) + "\"\n")
	
