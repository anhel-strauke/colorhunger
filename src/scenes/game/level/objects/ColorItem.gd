extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (Color) var color = Color(1.0, 0.0, 0.0)

signal kill_me(item)

func affect_hero(hero):
	print("RedSphere ", self.get_index(), " affects hero")
	hero.add_hero_color(color)
	$RedStaticBody.collision_layer = 0
	$RedStaticBody.collision_mask = 0
	$AnimationPlayer.play("destroy")

func suicide():
	emit_signal("kill_me", self)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(color)


func set_color(col: Color):
	color = col
	var mat = SpatialMaterial.new()
	mat.albedo_color = color
	mat.emission = color
	mat.emission_energy = 0.6
	mat.emission_enabled = true
	$MeshInstance.material_override = mat

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
