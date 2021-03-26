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

func spawnNode(nodeName, _dragged):
	var node = load("res://Scenes/nodes/" + nodeName + ".tscn")
	var inst = node.instance()
	inst.offset += spawnLoc + (nodeCount * Vector2(20,20))
	add_child(inst)
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
	if checkConnected(to):
		if connect_node(from, from_slot, to, to_slot) == OK:
			print("connected")
		updateConnectionList()

func checkConnected(to):
	var isTrue = true
	for i in data.connectionList.size():
		if data.connectionList[i].values()[2] == to:
			isTrue = false
	return isTrue

func updateConnectionList():
	data.connectionList = get_connection_list()

func loadConnections(thing):
	pass

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	if "Script" in to:
		get_node(to).disconnectedFromNode()
	disconnect_node(from, from_slot, to, to_slot)
