extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var material

# Called when the node enters the scene tree for the first time.
func _ready():
	material = get_surface_material(0);

var time = 0.0;
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	time += delta;
	# var material = mesh.surface_get_material(0);
	material.set_shader_param("time", time);

