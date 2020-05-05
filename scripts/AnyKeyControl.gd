extends Control

var fun_underway = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	if fun_underway == false:
		if Input.is_action_pressed("interact"):
			fun_underway = true
			Signals.emit_signal("initiate_fun")
			self.hide()
