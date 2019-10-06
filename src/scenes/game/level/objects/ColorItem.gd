extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (Color) var color = Color(1.0, 0.0, 0.0)

var color_classes = [
	preload("res://scenes/gfx/Color1.tscn"),
	preload("res://scenes/gfx/Color2.tscn"),
	preload("res://scenes/gfx/Color3.tscn")
]

signal kill_me(item)

func affect_hero(hero, direction):
	print("RedSphere ", self.get_index(), " affects hero")
	hero.add_hero_color(color, direction)
	$RedStaticBody.collision_layer = 0
	$RedStaticBody.collision_mask = 0
	$AnimationPlayer.play("destroy")

func suicide():
	emit_signal("kill_me", self)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# set_color(color)

func create_model():
	var model;
	model = $Model
	remove_child(model)
	model.free()
	
	if color.r > 0.0:
		model = color_classes[0].instance()
	elif color.g > 0.0:
		model = color_classes[1].instance()
	elif color.b > 0.0:
		model = color_classes[2].instance()
	else:
		raise()
	model.name = "Model"
	add_child(model)

func set_color(col: Color):
	color = col
	create_model()
	
	$Model/MeshInstance.setColor(Vector3(color.r, color.g, color.b), 1.0);
	return
	var mat = SpatialMaterial.new()
	mat.albedo_color = color
	mat.emission = color
	mat.emission_energy = 0.6
	mat.emission_enabled = true
	$MeshInstance.material_override = mat

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
