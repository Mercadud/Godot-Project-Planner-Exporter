extends VBoxContainer

var childLoc
var funcArr = []

onready var functions = $functions/func

func setNode(e):
	childLoc = e
	updateInfoPage()

func updateFunc(_new_text):
	for i in functions.get_child_count():
		funcArr[i] = functions.get_child(i).text
	

func updateInfoPage():
	for i in functions.get_child_count():
		functions.get_child(i).queue_free()
	funcArr = []
	$ScriptName/LineEdit.text = childLoc.info["name"]
	funcArr = childLoc.info["functions"]
	for i in funcArr.size():
		var function = LineEdit.new()
		functions.add_child(function)
		function.placeholder_text = "ready()"
		function.connect("text_changed", self, "updateFunc")
		if funcArr[i] != null:
			functions.get_child(functions.get_child_count()-1).text = funcArr[i]

func _on_addFunction_button_up():
	childLoc.info["functions"].resize(childLoc.info["functions"].size() + 1)
	updateInfoPage()
	

func _on_removeFunction_button_up():
	if childLoc.info["functions"].size() > 0:
		childLoc.info["functions"].remove(childLoc.info["functions"].size() - 1)
		updateInfoPage()


func _on_LineEdit_text_changed(new_text):
	childLoc.info["name"] = new_text
	childLoc.updateNode()
