extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (Color) var color = Color(1.0, 0.0, 0.0)

signal kill_me(item)

func affect_hero(hero):
	print("RedSphere ", self.get_index(), " affects hero")
	hero.add_hero_color(color)
	emit_signal("kill_me", self)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(color)


func set_color(col: Color):
	color = col
	var mat = SpatialMaterial.new()
	print(color)
	mat.emission = color
	mat.albedo_color = color
	mat.emission_energy = 3.05
	mat.emission_enabled = true
	$CSGSphere.material = mat
	
	#$OmniLight.light_color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
