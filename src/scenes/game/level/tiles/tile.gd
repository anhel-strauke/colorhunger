extends Spatial

export var tile_width: float

# Called when the node enters the scene tree for the first time.

var lights = [];

var lightClass = preload("res://scenes/game/level/objects/FloatingLight.gd");

func _ready():
	for v in range(0, 0):
		var l = lightClass.new()
		add_child(l)
		lights.append(l)
		l.translation = Vector3(rand_range(-tile_width/2.0, tile_width/2.0), 2.0, rand_range(-tile_width/2.0, tile_width/2.0))
		# l.translation = Vector3(-3.6, 1.64, 7.6)
		#l.rotate_x(0.3);
		l.rotate_y(rand_range(0, 3.14));
		l.spot_attenuation = 1.36;
		l.spot_angle = 41.0;
		l.spot_range = 12.0;
		l.light_energy = 4.44;
		l.editor_only = true
		
	for v in range(0, 0):
		var l = lightClass.new()
		# var l = OmniLight.new()
		add_child(l)
		lights.append(l)
		l.my_init(Vector3(rand_range(-tile_width/2.0, tile_width/2.0), 3.3, rand_range(-tile_width/2.0, tile_width/2.0)))
		# l.translation = Vector3(rand_range(-tile_width/2.0, tile_width/2.0), 3.3, rand_range(-tile_width/2.0, tile_width/2.0))
		# l.translation = Vector3(-3.6, 1.64, 7.6)
		#l.rotate_x(0.3);
		l.rotate_y(rand_range(0, 3.14));
		l.omni_attenuation = 0.64;
		l.omni_range = 6.4;
		l.light_energy = 1.86/2.0;
		l.editor_only = true;
		#l.stage = rand_range(0.0, 1.0);
		#l.orig_y = l.translation.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (global_transform.origin - get_node("/root/Game/GameCamera").global_transform.origin).length() < 20.0:
		for l in lights:
			l.stage = l.stage + delta;
			l.translation.y = l.orig_y + sin(l.stage)*2;
			#continue
			l.editor_only = false
	else:
		for l in lights:
			pass
			l.editor_only = true
