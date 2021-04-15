extends GraphEdit

var spawnLoc = Vector2(20,20)
var nodeCount = 1
var connectionList

onready var data = $"/root/Saver"

func _ready():
	updateConnectionList()

func _physics_process(_delta):
	loadConnections()
	if Input.is_action_just_pressed("delete"):
		for i in get_tree().get_nodes_in_group("node"):
			if "RootFolder" in i.info["nodeName"]:
				continue
			if i.selected == true:
				i.queue_free()

func spawnNode(nodeName):
	var node = load("res://Scenes/nodesInherited/" + nodeName + ".tscn")
	var inst = node.instance()
	inst.offset += spawnLoc + (nodeCount * Vector2(20,20))
	add_child(inst)
	inst.updateInfo()
	nodeCount += 1

func can_drop_data(_position, _type):
	return true

func drop_data(_position, type):
	var node
	if type != "World Environment":
		node = load("res://Scenes/nodesInherited/" + type + ".tscn")
	else:
		node = load("res://Scenes/nodesInherited/WorldEnvironment.tscn")
	if node != null:
		var inst = node.instance()
		add_child(inst)
		inst.offset = get_child(0).get_local_mouse_position()
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

func _on_Misc_item_activated(index):
	if index == 0:
		spawnNode("Script")
	if index == 1:
		spawnNode("Import")
	if index == 2:
		spawnNode("WorldEnvironment")

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	updateConnectionList()
	if checkConnected(to):
		if connect_node(from, from_slot, to, to_slot) == OK:
			print("connected " + str(from) + " and " + str(to))
		updateConnectionList()

func checkConnected(to):
	var isTrue = true
	var connectionList = get_connection_list()
	for i in connectionList.size():
		if connectionList[i]["to"] == to:
			isTrue = false
	return isTrue

func updateConnectionList():
	connectionList = get_connection_list()
	for i in connectionList.size():
		get_node(connectionList[i]["to"]).info["parentNode"] = get_node(connectionList[i]["from"]).info["id"]

func loadConnections():
	if data.loadedNewProject == true:
		###delete all current nodes###
		for i in connectionList.size():
			_on_GraphEdit_disconnection_request(connectionList[i]["from"], connectionList[i]["from_slot"], connectionList[i]["to"], connectionList[i]["to_slot"])
		for i in get_tree().get_nodes_in_group("node"):
			i.queue_free()
		###create all the nodes###
		for i in data.nodeList.size():
			var node
			var inst
			if "RootFolder" in data.nodeList[i]["nodeName"]:
				node = load("res://Scenes/nodesInherited/RootFolder.tscn")
				inst = node.instance()
				add_child(inst)
				nodeCount += 1
			elif "Folder" in data.nodeList[i]["nodeName"]:
				node = load("res://Scenes/nodesInherited/Folder.tscn")
				inst = node.instance()
				add_child(inst)
				nodeCount += 1
			elif "Scene" in data.nodeList[i]["nodeName"]:
				node = load("res://Scenes/nodesInherited/Scene.tscn")
				inst = node.instance()
				add_child(inst)
				inst.info["sceneType"] = data.nodeList[i]["sceneType"]
				inst.info["scriptAttached"] = data.nodeList[i]["scriptAttached"]
				nodeCount += 1
			elif "Node" in data.nodeList[i]["nodeName"]:
				node = load("res://Scenes/nodesInherited/Node.tscn")
				inst = node.instance()
				add_child(inst)
				inst.info["nodeType"] = data.nodeList[i]["nodeType"]
				nodeCount += 1
			elif "Script" in data.nodeList[i]["nodeName"]:
				node = load("res://Scenes/nodesInherited/Script.tscn")
				inst = node.instance()
				add_child(inst)
				inst.info["functions"] = data.nodeList[i]["functions"]
				inst.info["singleton"] = data.nodeList[i]["singleton"]
				nodeCount += 1
			elif "WorldEnvironment" in data.nodeList[i]["nodeName"]:
				node = load("res://Scenes/nodesInherited/WorldEnvironment.tscn")
				inst = node.instance()
				add_child(inst)
				inst.info["default"] = data.nodeList[i]["default"]
				inst.info["WEType"] = data.nodeList[i]["WEType"]
				nodeCount += 1
			elif "Import" in data.nodeList[i]["nodeName"]:
				node = load("res://Scenes/nodesInherited/Import.tscn")
				inst = node.instance()
				add_child(inst)
				inst.info["importLocation"] = data.nodeList[i]["importLocation"]
				nodeCount += 1
			###assigning common variables###
			inst.info["id"] = data.nodeList[i]["id"]
			inst.info["nodeName"] = inst.name
			inst.info["isCreated"] = false
			inst.info["location"] = data.nodeList[i]["location"]
			inst.info["name"] = data.nodeList[i]["name"]
			inst.info["parentNode"] = data.nodeList[i]["parentNode"]
		###move all nodes to location and connect to parents
		for node in get_tree().get_nodes_in_group("node"):
			node.updateNode()
			node.offset = node.info["location"]
			if node.info["parentNode"] != null:
				var parentName
				for parent in get_tree().get_nodes_in_group("node"):
					if node.info["parentNode"] == parent.info["id"]:
						parentName = parent.info["nodeName"]
						if connect_node(parentName, 0, node.name, 0) == OK:
							print("connected " + str(parentName + " and " + str(node.name)))
		data.loadedNewProject = false

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	updateConnectionList()
	
