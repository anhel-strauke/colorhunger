extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var hero = $Hero
onready var level_root = $LevelRoot

var hero_rel_pos: Vector3
var level_pos: float = 0
var screen_width

const hero_h_speed = 12.0
const hero_v_speed = 8.0
const level_speed = 6.0

func _input(event):
	if event.is_action_pressed("ui_up"):
		hero.v_accel = -hero_v_speed
	if event.is_action_pressed("ui_down"):
		hero.v_accel = hero_v_speed
	if event.is_action_pressed("ui_left"):
		hero.h_accel = -hero_h_speed
	if event.is_action_pressed("ui_right"):
		hero.h_accel = hero_h_speed
	if event.is_action_released("ui_up") and hero.v_accel < 0.0:
		hero.v_accel = 0.0
	elif  event.is_action_released("ui_down") and hero.v_accel > 0.0:
		hero.v_accel = 0.0
	if event.is_action_released("ui_left") and hero.h_accel < 0.0:
		hero.h_accel = 0.0
	elif event.is_action_released("ui_right") and hero.h_accel > 0.0:
		hero.h_accel = 0.0


func _ready():
	hero_rel_pos = Vector3(-6, 0, 0)
	hero.set_position(hero_rel_pos.x, hero_rel_pos.z)
	var half_h = abs(tan($GameCamera.fov) / $GameCamera.translation.y)
	var vp_size = get_tree().get_root().size
	var half_w = vp_size.x * half_h / vp_size.y
	screen_width = half_w * 2
	$Hero.level_bound_x_min = -(half_w - 1)
	$Hero.level_bound_x_max = half_w - 1
	$Hero.level_bound_z_min = -(half_h - 1)
	$Hero.level_bound_z_max = half_h - 1
	print("Game size: ", half_w * 2, " x ", half_h * 2)
	


func _process(delta):
	hero_rel_pos.x += hero.h_accel * delta
	hero_rel_pos.z += hero.v_accel * delta
	hero_rel_pos = hero.set_position(hero_rel_pos.x, hero_rel_pos.z)
	level_pos -= delta * level_speed
	level_root.translation = Vector3(level_pos, 0, 0)
	$LevelRoot/AutoGenLevel.update_visibility(-level_pos, screen_width)
	
	