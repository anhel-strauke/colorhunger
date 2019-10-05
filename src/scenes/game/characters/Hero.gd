extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var h_accel: float = 0.0
export var v_accel: float = 0.0
export var level_bound_x_min: float
export var level_bound_x_max: float
export var level_bound_z_min: float
export var level_bound_z_max: float


func set_position(x: float, z: float) -> Vector3:
	var new_pos = Vector3(x, 1.0, z)
	if x < level_bound_x_min:
		new_pos.x = level_bound_x_min
	elif x > level_bound_x_max:
		new_pos.x = level_bound_x_max
	if z < level_bound_z_min:
		new_pos.z = level_bound_z_min
	elif z > level_bound_z_max:
		new_pos.z = level_bound_z_max
	translation = new_pos
	return new_pos
	

func get_position() -> Vector3:
	var pos = get_translation()
	pos.y = 0.0
	return pos


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass
