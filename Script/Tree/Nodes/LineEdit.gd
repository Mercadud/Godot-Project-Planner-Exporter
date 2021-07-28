extends LineEdit

onready var info_page = $"../../../../Select/Info"

func _ready():
	pass

func _on_LineEdit_focus_entered():
	info_page._on_GraphEdit_node_selected(get_parent())
