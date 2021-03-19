extends GraphEdit


var mouseLocation
var recordMouseLocation = false

var spawnLoc = Vector2(20,20)

var nodeCount = 1


func _ready():
	pass

func _physics_process(delta):
	if recordMouseLocation:
		mouseLocation = get_local_mouse_position()

func spawnNode(nodeName, dragged):
	var node = load("res://Scenes/nodes/" + nodeName + ".tscn")
	var inst = node.instance()
	inst.offset += spawnLoc + (nodeCount * Vector2(20,20))
	add_child(inst)
	nodeCount += 1
	

func _on_GraphEdit_mouse_entered():
	recordMouseLocation = true

func _on_GraphEdit_mouse_exited():
	recordMouseLocation = false

func _on_Folder_item_activated(index):
	spawnNode("Folder", false)


func _on_Nodes_item_activated(index):
	if index == 0:
		spawnNode("Scene", false)
	if index == 1:
		spawnNode("Node", false)


func _on_Misc_item_activated(index):
	spawnNode("Script", false)


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	print(from)
	print(to)
	if "Folder" in from or "RootFolder" in from:
		if "Script" in to:
			if checkScriptConnected(to):
				connect_node(from, from_slot, to, to_slot)
		elif !"Node" in to:
			connect_node(from, from_slot, to, to_slot)
		else:
			print(str(from) + " and " + str(to) + " do not connect")
	if "Scene" in from or "Node" in from:
		if "Node" in to or "Scene" in to:
			connect_node(from, from_slot, to, to_slot)
	

func checkScriptConnected(scriptNode):
	print(str(get_node(scriptNode)))
	if get_node(scriptNode).connected == false:
		get_node(scriptNode).connectedToNode()
		print("connected")
		return true
	else:
		print("can't connect")
		return false

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	if "Script" in to:
		get_node(to).disconnectedFromNode()
	disconnect_node(from, from_slot, to, to_slot)
