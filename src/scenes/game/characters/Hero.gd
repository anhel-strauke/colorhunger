extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal color_updated(col)
signal died()

onready var color_tool = preload("res://scenes/game/ColorTool.gd").new()

export var h_accel: float = 0.0
export var v_accel: float = 0.0
export var level_bound_x_min: float
export var level_bound_x_max: float
export var level_bound_z_min: float
export var level_bound_z_max: float
export var white_boost: int = 6

var color: Color = Color(1.0, 1.0, 1.0)

var _colors = []

onready var _kinematic_body = $KinematicBody


func try_move(hero_delta: Vector3):
	var res = _kinematic_body.move_and_collide(hero_delta, true, true, true)
	return res


func set_position(x: float, z: float) -> Vector3:
	var new_pos = Vector3(x, 4.0, z)
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


func update_color():
	var weighted_cols = []
	for col in _colors:
		weighted_cols.append([col, 1])
	if len(_colors) < white_boost:
		for i in range(white_boost - len(_colors)):
			weighted_cols.append([Color(1.0, 1.0, 1.0), 1])
	color = color_tool.mix_colors(weighted_cols)
	$Model/Body/MeshInstance.setColor(Vector3(color.r, color.g, color.b))
	emit_signal("color_updated", color)


func add_hero_color(col: Color, direction):
	_colors.append(col)
	$Model/Body/MeshInstance.flash(direction)
	update_color()
	print("Mix: ", color)


func die():
	emit_signal("died")


func clear_color():
	_colors = []
	update_color()


func _ready():
	update_color()


func _process(delta):
	pass
