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

var color = Vector3(1.0, 1.0, 1.0);
var prevColor = color;
var colorTransition = 1.0;

func _ready():
	material = get_surface_material(0);
	
	light = get_node("../OmniLight");
	lightDist = light.translation.length();
	
	light2 = get_node("../OmniLight2");
	if light2:
		lightDist2 = light2.translation.length();
	
	setColor(Vector3(1.0, 0.0, 0.0));
	

var time = 0.0;
# Called every frame. 'delta' is the elapsed time since the previous frame.


func setColor(newColor: Vector3):
	prevColor = color;
	color = newColor;
	colorTransition = 0.0;
	material.set_shader_param("color1", prevColor);
	material.set_shader_param("color2", color);

func moveLight():
	light.translation = Vector3(lightDist * sin(time), lightDist * cos(time), 0.0);
	if light2:
		light2.translation = Vector3(lightDist2 * sin(time*3.0), 0.0, lightDist2 * cos(time*2.0));

var colorSet = false;
func _process(delta):
	time += delta;
	# var material = mesh.surface_get_material(0);
	material.set_shader_param("time", time);
	colorTransition += delta*1.0;
	if time > 3 and not colorSet:
		setColor(Vector3(0.0, 1.0, 0.0));
		colorSet = true;
	if colorTransition > 1.0:
		colorTransition = 1.0;
	material.set_shader_param("colorMix", colorTransition);
	moveLight();

