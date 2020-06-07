extends CSGCombiner

var speed = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	rotation_degrees.y += rotation_degrees.y + speed * delta
