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
	print(get_children())
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
		if data.connectionList[i].values()[2] == to:
			isTrue = false
	return isTrue

func updateConnectionList():
	data.connectionList = get_connection_list()
	for i in data.connectionList.size():
		get_node(data.connectionList[i].values()[2]).info.parentNode = data.connectionList[i].values()[0]

func loadConnections():
	if (data.loadedNewProject == true):
		for i in data.connectionList.size():
			if "Folder" in data.connectionList[i]["nodeName"]:
				spawnNode("Folder")
			elif "Scene" in data.connectionList[i]["nodeName"]:
				spawnNode("Scene")
			elif "Node" in data.connectionList[i]["nodeName"]:
				spawnNode("Node")
			elif "Script" in data.connectionList[i]["nodeName"]:
				spawnNode("Script")
		for i in data.connectionList.size():
			if connect_node(data.connectionList[i]["from"],
			 data.connectionList[i]["from_slot"],
			 data.connectionList[i]["to"],
			 data.connectionList[i]["to_slot"]) == OK:
				print(data.connectionList[i])
		data.loadedNewProject = false

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	updateConnectionList()
