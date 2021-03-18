extends GraphEdit


var mouseLocation
var recordMouseLocation = false


func _ready():
	pass

func _physics_process(delta):
	if recordMouseLocation:
		mouseLocation = get_local_mouse_position()

func spawnNode(nodeName, dragged):
	var node = load("res://Scenes/nodes/" + nodeName + ".tscn")
	var inst = node.instance()
	
	add_child(inst)
	

func _on_GraphEdit_mouse_entered():
	recordMouseLocation = true

func _on_GraphEdit_mouse_exited():
	recordMouseLocation = false

func _on_Folder_item_activated(index):
	spawnNode("Folder", false)


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	connect_node(from, from_slot, to, to_slot)
