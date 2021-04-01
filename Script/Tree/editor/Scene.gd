extends VBoxContainer

var childLoc

onready var textInfo = $"../../../Select/Info/Folder"

func _ready():
	pass

func setNode(n):
	childLoc = n
