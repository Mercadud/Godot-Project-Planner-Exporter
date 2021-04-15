extends Node

var exportDirLocation
var SaveFileLocation
var loadedNewProject = false
var nodeList = []

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

func exportProject():
	var rootFolderLocation
	var resLoc
	
	for node in get_tree().get_nodes_in_group("node"):
		if node.info["name"] == "":
			return false
		if "import" in  node.info["nodeName"]:
			if node.info["importLocation"] == "":
				return false
		if "Script" in node.info["nodeName"]:
			for i in node.info["functions"].size():
				if node.info["functions"][i] == "":
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
						rootFolderLocation = node
						resLoc = nodeList[node]["path"].length()
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
							###WorldEnvironment###
							elif "WorldEnvironment" in nodeList[node]["nodeName"]:
								nodeList[node]["path"] = nodeList[parent]["path"] + "/" + nodeList[node]["name"] + ".tres"
								var file = File.new()
								file.open(nodeList[node]["path"], File.WRITE)
								file.store_string("[gd_resource type=\"Environment\" load_steps=2 format=2]\n\n")
								if nodeList[node]["WEType"] == "Default":
									file.store_string("""[sub_resource type=\"ProceduralSky\" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )""")
								elif nodeList[node]["WEType"] == "Realistic":
									file.store_string("""[sub_resource type=\"ProceduralSky\" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )
ambient_light_energy = 0.0
ambient_light_sky_contribution = 0.0
tonemap_mode = 2
tonemap_exposure = 0.7
tonemap_white = 16.0
auto_exposure_speed = 4.0
ss_reflections_enabled = true
ss_reflections_max_steps = 128
ss_reflections_roughness = false
ssao_enabled = true
ssao_quality = 2
ssao_edge_sharpness = 32.0
dof_blur_far_distance = 50.0
dof_blur_far_transition = 8192.0
dof_blur_far_quality = 2
dof_blur_near_quality = 2
glow_levels/1 = true
glow_levels/2 = true
glow_levels/5 = false
glow_intensity = 0.2
adjustment_enabled = true""")
									
								nodeList[node]["isCreated"] = true
	
	###create the project.godot file###
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
	###reset everything###
	for i in get_tree().get_nodes_in_group("node"):
		i.info["isCreated"] = false
	nodeList = []
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
