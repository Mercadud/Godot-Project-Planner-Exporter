extends HSplitContainer


func _ready():
	_on_Editor_resized()


func _on_Editor_resized():
	self.split_offset = int(80 * OS.window_size.x / 100)
