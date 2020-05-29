extends Control


func can_drop_data(_pos, _data):
	return true

func drop_data(_pos, data):
	var new_leia = load("res://Leia.tscn").instance()
	add_child(new_leia)
	data.queue_free()
	
