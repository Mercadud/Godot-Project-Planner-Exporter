extends Node

var connectionList

func _ready():
	pass

func save(filePath : String):
	var file = File.new()
	file.open(filePath, File.WRITE)
	file.store_var(connectionList)
	file.close()

func load(filePath : String):
	var file = File.new()
	file.open(filePath, File.READ)
	connectionList = file.get_var()
	file.close()
