extends MeshInstance

var parent
var shader_material

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_node("..")
	shader_material = get_surface_material(0)

func _physics_process(delta):
	shader_material.set_shader_param("PlayerPos", parent.translation)
	pass
