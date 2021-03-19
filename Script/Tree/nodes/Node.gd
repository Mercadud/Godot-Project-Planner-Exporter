extends GraphNode

var connected = false

func _ready():
	pass

func connectedToNode():
	connected = true

func disconnectedFromNode():
	connected = false
