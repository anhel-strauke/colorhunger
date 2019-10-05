extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var material

# Called when the node enters the scene tree for the first time.
var light;
var lightDist;

var light2;
var lightDist2;

func _ready():
	material = get_surface_material(0);
	
	light = get_node("../OmniLight");
	lightDist = light.translation.length();
	
	light2 = get_node("../OmniLight2");
	lightDist2 = light2.translation.length();
	

var time = 0.0;
# Called every frame. 'delta' is the elapsed time since the previous frame.

func moveLight():
	light.translation = Vector3(lightDist * sin(time), lightDist * cos(time), 0.0);
	light2.translation = Vector3(lightDist2 * sin(time*3.0), 0.0, lightDist2 * cos(time*2.0));

func _process(delta):
	time += delta;
	# var material = mesh.surface_get_material(0);
	material.set_shader_param("time", time);
	moveLight();

