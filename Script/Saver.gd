extends Node

var connectionList
var exportDirLocation
var SaveFileLocation
var loadedNewProject = false

func _ready():
	pass

func save():
	var file = File.new()
	file.open(SaveFileLocation, File.WRITE)
	file.store_var(connectionList)
	file.close()

func loadProject():
	var file = File.new()
	file.open(SaveFileLocation, File.READ)
	connectionList = file.get_var()
	file.close()
	loadedNewProject = true

func import():
	var dir = Directory.new()
	dir.open(exportDirLocation)
	print("not sure what happens after that")
