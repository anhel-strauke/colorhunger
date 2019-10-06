extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (Color) var color = Color(1.0, 1.0, 1.0)


func set_color(col: Color):
	color = col
	var mesh_obj: MeshInstance = $Model/MeshInstance
	var mesh_material: SpatialMaterial = (mesh_obj.mesh.material as SpatialMaterial)
	if mesh_material:
		mesh_material.emission = col
	var emitter: Particles = $Model/Particles
	var emitter_mesh: SphereMesh = emitter.mesh
	var emitter_mat: SpatialMaterial = (emitter_mesh.material as SpatialMaterial)
	if emitter_mat:
		emitter_mat.emission = col


# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
