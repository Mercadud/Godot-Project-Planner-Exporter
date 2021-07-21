extends VBoxContainer

onready var rootFolderSelected = $RootFolder
onready var folderSelected = $Folder
onready var sceneSelected = $Scene
onready var scriptSelected = $Script
onready var nodeSelected = $Node
onready var noneSelected = $None
onready var importSelected = $Import
onready var WESelected = $WorldEnvironment

func _on_GraphEdit_node_selected(n):
	$Title.text = n.name
	if "RootFolder" in n.name:
		onRoot(n)
	elif "Folder" in n.name:
		onFolder(n)
	elif "Scene" in n.name:
		onScene(n)
	elif "Script" in n.name:
		onScript(n)
	elif "Node" in n.name:
		onNode(n)
	elif "Import" in n.name:
		onImport(n)
	elif "WorldEnvironment" in n.name:
		onWE(n)


func onRoot(node):
	rootFolderSelected.visible = true
	rootFolderSelected.setNode(node)
	folderSelected.visible = false
	sceneSelected.visible = false
	scriptSelected.visible = false
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = false
	WESelected.visible = false



func onFolder(node):
	rootFolderSelected.visible = false
	folderSelected.visible = true
	folderSelected.setNode(node)
	sceneSelected.visible = false
	scriptSelected.visible = false
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = false
	WESelected.visible = false


func onScene(node):
	rootFolderSelected.visible = false
	folderSelected.visible = false
	sceneSelected.visible = true
	sceneSelected.setNode(node)
	scriptSelected.visible = false
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = false
	WESelected.visible = false

func onScript(node):
	rootFolderSelected.visible = false
	folderSelected.visible = false
	sceneSelected.visible = false
	scriptSelected.visible = true
	scriptSelected.setNode(node)
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = false
	WESelected.visible = false

func onNode(node):
	rootFolderSelected.visible = false
	folderSelected.visible = false
	sceneSelected.visible = false
	scriptSelected.visible = false
	nodeSelected.visible = true
	nodeSelected.setNode(node)
	noneSelected.visible = false
	importSelected.visible = false
	WESelected.visible = false

func onImport(node):
	rootFolderSelected.visible = false
	folderSelected.visible = false
	sceneSelected.visible = false
	scriptSelected.visible = false
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = true
	importSelected.setNode(node)
	WESelected.visible = false

func onWE(node):
	rootFolderSelected.visible = false
	folderSelected.visible = false
	sceneSelected.visible = false
	scriptSelected.visible = false
	nodeSelected.visible = false
	noneSelected.visible = false
	importSelected.visible = false
	WESelected.visible = true
	WESelected.setNode(node)
