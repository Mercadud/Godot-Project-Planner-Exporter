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
		functions.get_child(functions.get_child_count()-1).text = funcArr[i]

func _on_addFunction_button_up():
	var function = LineEdit.new()
	functions.add_child(function)
	funcArr.push_back(function.text)
	function.placeholder_text = "ready()"
	function.connect("text_changed", self, "updateFunc")

func _on_removeFunction_button_up():
	if functions.get_child_count() > 0:
		functions.get_child(functions.get_child_count() -1 ).queue_free()
		funcArr.remove(get_child_count() - 1)


func _on_LineEdit_text_changed(new_text):
	childLoc.info["name"] = new_text
	childLoc.updateNode()
