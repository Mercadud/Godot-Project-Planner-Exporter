extends GraphEdit

var spawnLoc = Vector2(20,20)
var nodeCount = 1

onready var data = $"/root/Saver"

func _ready():
	updateConnectionList()

func _physics_process(_delta):
	loadConnections()

func spawnNode(nodeName):
	var node = load("res://Scenes/nodesInherited/" + nodeName + ".tscn")
	var inst = node.instance()
	inst.offset += spawnLoc + (nodeCount * Vector2(20,20))
	add_child(inst)
	inst.updateInfo()
	nodeCount += 1

func _on_GraphEdit_delete_nodes_request():
	nodeCount -= 1

func _on_Folder_item_activated(_index):
	spawnNode("Folder")

func _on_Nodes_item_activated(index):
	if index == 0:
		spawnNode("Scene")
	if index == 1:
		spawnNode("Node")

func _on_Misc_item_activated(_index):
	spawnNode("Script")

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	updateConnectionList()
	if checkConnected(to):
		if connect_node(from, from_slot, to, to_slot) == OK:
			print("connected " + str(from) + " and " + str(to))
		updateConnectionList()

func checkConnected(to):
	var isTrue = true
	for i in data.connectionList.size():
		if data.connectionList[i]["to"] == to:
			isTrue = false
	return isTrue

func updateConnectionList():
	data.connectionList = get_connection_list()
	for i in data.connectionList.size():
		get_node(data.connectionList[i]["to"]).info["parentNode"] = data.connectionList[i]["from"]
		get_node(data.connectionList[i]["to"]).updateInfo()

func loadConnections():
	if data.loadedNewProject == true:
		###create all the nodes###
		for i in data.nodeList.size():
			if "RootFolder" in data.nodeList[i]["nodeName"]:
				var node = load("res://Scenes/nodesInherited/RootFolder.tscn")
				var inst = node.instance()
				add_child(inst)
				inst.info["id"] = data.nodeList[i]["id"]
				inst.info["nodeName"] = "RootFolder"
				inst.info["isCreated"] = false
				inst.info["location"] = data.nodeList[i]["location"]
				inst.info["name"] = data.nodeList[i]["name"]
				inst.info["parentNode"] = data.nodeList[i]["parentNode"]
				nodeCount += 1
			elif "Folder" in data.nodeList[i]["nodeName"]:
				var node = load("res://Scenes/nodesInherited/Folder.tscn")
				var inst = node.instance()
				add_child(inst)
				inst.info["id"] = data.nodeList[i]["id"]
				inst.info["nodeName"] = "Folder"
				inst.info["isCreated"] = false
				inst.info["location"] = data.nodeList[i]["location"]
				inst.info["name"] = data.nodeList[i]["name"]
				inst.info["parentNode"] = data.nodeList[i]["parentNode"]
				nodeCount += 1
			elif "Scene" in data.nodeList[i]["nodeName"]:
				var node = load("res://Scenes/nodesInherited/Scene.tscn")
				var inst = node.instance()
				add_child(inst)
				inst.info["id"] = data.nodeList[i]["id"]
				inst.info["nodeName"] = "Scene"
				inst.info["isCreated"] = false
				inst.info["location"] = data.nodeList[i]["location"]
				inst.info["name"] = data.nodeList[i]["name"]
				inst.info["parentNode"] = data.nodeList[i]["parentNode"]
				inst.info["sceneType"] = data.nodeList[i]["sceneType"]
				inst.info["scriptAttached"] = data.nodeList[i]["scriptAttached"]
				nodeCount += 1
			elif "Node" in data.nodeList[i]["nodeName"]:
				var node = load("res://Scenes/nodesInherited/Node.tscn")
				var inst = node.instance()
				add_child(inst)
				inst.info["id"] = data.nodeList[i]["id"]
				inst.info["nodeName"] = "Node"
				inst.info["isCreated"] = false
				inst.info["location"] = data.nodeList[i]["location"]
				inst.info["name"] = data.nodeList[i]["name"]
				inst.info["parentNode"] = data.nodeList[i]["parentNode"]
				inst.info["nodeType"] = data.nodeList[i]["nodeType"]
				nodeCount += 1
			elif "Script" in data.nodeList[i]["nodeName"]:
				var node = load("res://Scenes/nodesInherited/Script.tscn")
				var inst = node.instance()
				add_child(inst)
				inst.info["id"] = data.nodeList[i]["id"]
				inst.info["nodeName"] = "Script"
				inst.info["isCreated"] = false
				inst.info["location"] = data.nodeList[i]["location"]
				inst.info["name"] = data.nodeList[i]["name"]
				inst.info["parentNode"] = data.nodeList[i]["parentNode"]
				inst.info["functions"] = data.nodeList[i]["functions"]
				nodeCount += 1
		###move all nodes to location and connect to parents
		print(str(get_children()) + "REEEEEEEEEEEEEEEEEEEEE" + str(get_child_count()))
		for i in get_child_count():
			if i > 2:
				var node = get_children()
				node[i].offset = node[i].info["location"]
				if node[i].info["parentNode"] != null: pass
#					connect_node(node.info["parentNode"], 0, node.name, 0)

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	updateConnectionList()
