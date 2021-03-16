extends GraphNode

onready var connections = $"."

var addSlot = 5

func _ready():
	updateSize()

func updateConnections():
	for i in [addSlot]:
		self.set_slot(i-1, false, 0, Color(1,0,0,1), true, 0,  Color(1,0,0,1), null, null)
		updateSize()

func _on__button_up():
	if connections.get_child_count() != 5:
		connections.get_child(connections.get_child_count()-1).queue_free()
		addSlotCountDown()
	updateSize()
	

func _on_plus_button_up():
	addSlotCountUp()
	var label = Label.new()
	label.align = Label.ALIGN_CENTER
	connections.add_child(label)
	label.text = "Connection " + str(connections.get_child_count() - 5)
	updateConnections()
	updateSize()

func addSlotCountUp():
	addSlot += 1

func addSlotCountDown():
	if addSlot != 5:
		addSlot -= 1

func updateSize():
	rect_size.y = 0


func _on_SceneNode_close_request():
	queue_free()
