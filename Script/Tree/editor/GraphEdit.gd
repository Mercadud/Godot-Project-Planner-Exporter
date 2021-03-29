extends GraphEdit


var mouseLocation
var recordMouseLocation = false

var spawnLoc = Vector2(20,20)
var nodeCount = 1

onready var data = $"/root/Saver"

func _ready():
	updateConnectionList()

func _physics_process(_delta):
	if recordMouseLocation:
		mouseLocation = get_local_mouse_position()
	loadConnections()

func spawnNode(nodeName, _dragged):
	var node = load("res://Scenes/nodes/" + nodeName + ".tscn")
	var inst = node.instance()
	inst.offset += spawnLoc + (nodeCount * Vector2(20,20))
	add_child(inst)
	print(get_children())
	inst.info.nodeName = inst
	nodeCount += 1

func _on_GraphEdit_mouse_entered():
	recordMouseLocation = true

func _on_GraphEdit_mouse_exited():
	recordMouseLocation = false

func _on_Folder_item_activated(_index):
	spawnNode("Folder", false)

func _on_Nodes_item_activated(index):
	if index == 0:
		spawnNode("Scene", false)
	if index == 1:
		spawnNode("Node", false)

func _on_Misc_item_activated(_index):
	spawnNode("Script", false)

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

func loadConnections():
	if (data.loadedNewProject == true):
		for i in data.connectionList.size():
			if "Folder" in data.connectionList[i].values()[2]:
				spawnNode("Folder", false)
			elif "Scene" in data.connectionList[i].values()[2]:
				spawnNode("Scene", false)
			elif "Node" in data.connectionList[i].values()[2]:
				spawnNode("Node", false)
			elif "Script" in data.connectionList[i].values()[2]:
				spawnNode("Script", false)
		for i in data.connectionList.size():
			if connect_node(data.connectionList[i].values()[0],
			 data.connectionList[i].values()[1],
			 data.connectionList[i].values()[2],
			 data.connectionList[i].values()[3]) == OK:
				print(data.connectionList[i])
		data.loadedNewProject = false

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	if "Script" in to:
		get_node(to).disconnectedFromNode()
	disconnect_node(from, from_slot, to, to_slot)

