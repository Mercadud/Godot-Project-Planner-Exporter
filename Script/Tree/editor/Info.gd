extends VBoxContainer

var node

onready var folderSelected = $Folder
onready var sceneSelected = $Scene
onready var scriptSelected = $Script
onready var nodeSelected = $Node
onready var noneSelected = $None
onready var importSelected = $Import

func _ready():
	pass

func _on_GraphEdit_node_selected(n):
	node = n
	$Title.text = node.name
	if "Folder" in n.name:
		onFolder()
	elif "Scene" in n.name:
		onScene()
	elif "Script" in n.name:
		onScript()
	elif "Node" in n.name:
		onNode()
	elif "Import" in n.name:
		onImport()

func onFolder():
	folderSelected.visible = true
	folderSelected.setNode(node)
	sceneSelected.visible = false
	scriptSelected.visible = false
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = false


func onScene():
	folderSelected.visible = false
	sceneSelected.visible = true
	sceneSelected.setNode(node)
	scriptSelected.visible = false
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = false

func onScript():
	folderSelected.visible = false
	sceneSelected.visible = false
	scriptSelected.visible = true
	scriptSelected.setNode(node)
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = false

func onNode():
	folderSelected.visible = false
	sceneSelected.visible = false
	scriptSelected.visible = false
	nodeSelected.visible = true
	nodeSelected.setNode(node)
	noneSelected.visible = false
	importSelected.visible = false

func onNone():
	folderSelected.visible = false
	sceneSelected.visible = false
	scriptSelected.visible = false
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = false

func onImport():
	folderSelected.visible = false
	sceneSelected.visible = false
	scriptSelected.visible = false
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = true
	importSelected.setNode(node)
