extends ItemList

onready var text = load("res://Assets/Nodes/Folder.png")

func _ready():
	add_item("Folder", text, true)
