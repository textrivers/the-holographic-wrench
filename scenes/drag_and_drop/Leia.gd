extends Control

func get_drag_data(_pos):
	var preview = load("res://Leia.tscn").instance()
	## preview.set_texture()
	set_drag_preview(preview)
	self.hide()
	return preview

