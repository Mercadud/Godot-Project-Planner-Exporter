extends ItemList

# allows drag and drop functionality
func get_drag_data(_pos):
	var selected = get_selected_items()
	if selected.size() != 0:
		var prev = TextureRect.new()
		prev.texture = get_item_icon(selected[0])
		set_drag_preview(prev)
		return get_item_text(selected[0])
