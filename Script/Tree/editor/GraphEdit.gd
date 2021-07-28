extends GraphEdit

var spawnLoc = Vector2(20,20)
var nodeCount = 1
var connectionList = []

onready var data = $"/root/Saver"

func _ready():
	updateConnectionList()

# allows user to delete all selected nodes using the delete key
func _physics_process(_delta):
	if Input.is_action_just_pressed("delete"):
		for i in get_tree().get_nodes_in_group("node"):
			if "RootFolder" in i.info["nodeName"]:
				continue
			if i.selected == true:
				i.queue_free()

# This spawns a node when you double click it
func spawnNode(nodeName):
	var node = load("res://Scenes/nodesInherited/" + nodeName + ".tscn")
	var inst = node.instance()
	inst.offset += spawnLoc + (nodeCount * Vector2(20,20))
	add_child(inst)
	inst.updateInfo()
	nodeCount += 1
	updateStats()

# This allows drag and drop functionality and spawns a node
func can_drop_data(_position, _type):
	return true

# follow up from the previous function
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
	updateStats()

# Deletes a node
func _on_GraphEdit_delete_nodes_request():
	nodeCount -= 1
	updateStats()

# This spawns nodes depending on what you double clicked
#probably the cleanest looking thing I've done
func _on_ItemList_item_activated(index):
	match index:
		0: spawnNode("Folder")
		1: spawnNode("Scene")
		2: spawnNode("Script")
		3: spawnNode("Import")
		4: spawnNode("WorldEnvironment")

# Makes sure that the node connecting to it only has one parent and connects them
func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	updateConnectionList()
	if checkConnected(to):
		if connect_node(from, from_slot, to, to_slot) == OK:
			print("connected " + str(from) + " and " + str(to))
		updateConnectionList()
	updateStats()

# this checks if the receiving end of the connection is already connected to something
func checkConnected(to):
	var isTrue = true
	updateConnectionList()
	for i in connectionList.size():
		if connectionList[i]["to"] == to:
			isTrue = false
	return isTrue

# This saves the connection list on a variable to avoid calling get_connection_list() too many times
func updateConnectionList():
	connectionList = get_connection_list()
	for i in connectionList.size():
		get_node(connectionList[i]["to"]).info["parentNode"] = get_node(connectionList[i]["from"]).info["id"]


# I will improve this to load nodes the same way the exporter exports nodes to
# make it look nicer and less error prone in the next release hopefully
func loadConnections():
	###delete all current nodes###
	updateConnectionList()
	disconnect_all()
	for i in get_tree().get_nodes_in_group("node"):
		i.queue_free()
	###create all the nodes###
	for i in data.nodeList.size():
		var node : PackedScene
		var inst : GraphNode
		if "RootFolder" in data.nodeList[i]["nodeName"]:
			node = load("res://Scenes/nodesInherited/RootFolder.tscn")
			inst = node.instance()
			add_child(inst)
			inst.info["driverName"] = data.nodeList[i]["driverName"]
			inst.info["projectName"] = data.nodeList[i]["projectName"]
			inst.info["projectHeight"] = data.nodeList[i]["projectHeight"]
			inst.info["projectWidth"] = data.nodeList[i]["projectWidth"]
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
		elif "Script" in data.nodeList[i]["nodeName"]:
			node = load("res://Scenes/nodesInherited/Script.tscn")
			inst = node.instance()
			add_child(inst)
			inst.info["functions"] = data.nodeList[i]["functions"]
			inst.info["singleton"] = data.nodeList[i]["singleton"]
			inst.info["extends"] = data.nodeList[i]["extends"]
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
		inst.info["isCreated"] = false
		inst.info["location"] = data.nodeList[i]["location"]
		inst.info["name"] = data.nodeList[i]["name"]
		inst.info["parentNode"] = data.nodeList[i]["parentNode"]
		data.nodeList[i]["nodeName"] = inst.name
		inst.offset = inst.info["location"]
	###move all nodes to location and connect to parents
	for node in get_tree().get_nodes_in_group("node"):
		node.updateNode()
		if node.info["parentNode"] != null:
			var parentName
			for parent in get_tree().get_nodes_in_group("node"):
				if node.info["parentNode"] == parent.info["id"]:
					parentName = parent.info["nodeName"]
					if connect_node(parentName, 0, node.name, 0) == OK:
						print("connected " + str(parentName + " and " + str(node.name)))
	updateStats()

# disconnects the nodes
func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	updateConnectionList()
	updateStats()

# disconnects all the nodes visible on the screen
func disconnect_all():
	var cl = connectionList
	for i in cl.size():
		print_debug(cl)
		_on_GraphEdit_disconnection_request(cl[i]["from"], cl[i]["from_port"], cl[i]["to"], cl[i]["to_port"])

# this updates the stats board on the info page
func updateStats():
	$"../../Select/Nodes/VSplitContainer/Stats".updateStatic(connectionList.size())
