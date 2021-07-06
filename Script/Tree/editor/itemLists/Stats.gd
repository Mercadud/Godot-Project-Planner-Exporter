extends VBoxContainer

onready var nodeCount = $nodeCount/count
onready var connectionCount = $Connections/count
onready var RamUsage = $RAMUsage/count

func _ready():
	$Timer.start()
	updateStatic(0)

func updateStatic(CC:int):
	#update Node count
	nodeCount.text = str(get_tree().get_nodes_in_group("node").size())
	#update the amount of connections
	connectionCount.text = str(CC)

func updateDynamic():
	RamUsage.text = str(stepify(OS.get_static_memory_usage()/1000000.0, 0.01)) + "mb"


func _on_Timer_timeout():
	updateDynamic()
