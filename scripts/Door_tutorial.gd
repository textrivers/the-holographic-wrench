extends Spatial

var door_is_closed = true

func _ready():
	pass # Replace with function body.

func activate():
	if door_is_closed == true:
		$AnimationPlayer.play("open")
	if door_is_closed == false:
		$AnimationPlayer.play_backwards("open")
	$AudioStreamPlayer3D.play()

func deactivate():
	activate()

func destroy():
	queue_free()
