extends Control

func _ready():
	pass # Replace with function body.

func _on_ButtonCommit_pressed():
	print("commit")
	self.hide()

func _on_ButtonExit_pressed():
	print("exit")
	self.hide()
