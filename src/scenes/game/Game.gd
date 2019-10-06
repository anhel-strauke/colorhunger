extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var hero = $Hero
onready var level_root = $LevelRoot

var hero_rel_pos: Vector3
var level_pos: float = 0
var screen_width
var controls_enabled = true
var wait_for_any_key = false

const hero_h_speed = 12.0
const hero_v_speed = 8.0
const level_speed_base = 6.0

var level_speed = level_speed_base

onready var hero_color = $UI/VBoxContainer/HeroColor
onready var win_con_color = $UI/VBoxContainer/WinConColor
onready var win_con_label = $UI/VBoxContainer/WinConLabel
onready var camera = $GameCamera

var base_camera_pos: Vector3

func _input(event):
	if wait_for_any_key:
		if event.is_pressed():
			wait_for_any_key = false
			$UI/Message/WinMessage.hide()
			$UI/Message/LooseMessage.hide()
			$"/root/singleton".level = $LevelRoot/AutoGenLevel.level_index + 1
			$"/root/singleton".transit_to_scene("res://scenes/game/Game.tscn")
	if not controls_enabled:
		return
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
	$Hero.clear_color()
	$Hero.level_bound_x_min = -(half_w - 1)
	$Hero.level_bound_x_max = half_w - 1
	$Hero.level_bound_z_min = -(half_h - 1)
	$Hero.level_bound_z_max = half_h - 1
	level_pos = -6.0
	print("Game size: ", half_w * 2, " x ", half_h * 2)
	_on_AutoGenLevel_win_condition_color_updated($LevelRoot/AutoGenLevel.win_condition_color)
	base_camera_pos = camera.translation
	var level = $"/root/singleton".level
	if level == 1:
		$Hero.white_boost = 0
	elif level == 2:
		$Hero.white_boost = 2
	else:
		$Hero.white_boost = 6
	if level:
		$LevelRoot/AutoGenLevel.run_level(level)
	

func _process(delta):
	var level_pos_delta = delta * level_speed
	var level_delta = Vector3(level_pos_delta, 0, 0)
	var hero_delta = Vector3(hero.h_accel * delta, 0, hero.v_accel * delta)
	var full_hero_delta = level_delta + hero_delta
	var collide_res: KinematicCollision = hero.try_move(full_hero_delta)
	if collide_res:
		var collide_with = (collide_res.collider as Spatial).get_parent()
		collide_with.affect_hero(hero)
	hero_rel_pos += hero_delta
	var new_hero_rel_pos = hero.set_position(hero_rel_pos.x, hero_rel_pos.z)
	if hero_delta.x > 0 and hero_rel_pos.x == new_hero_rel_pos.x:
		camera.move_to(base_camera_pos + Vector3(0.0, 1.0, 0.0))
	elif hero_delta.x < 0 and hero_rel_pos.x == new_hero_rel_pos.x:
		camera.move_to(base_camera_pos + Vector3(0.0, -1.0, 0.0))
	else:
		camera.move_to(base_camera_pos)
	hero_rel_pos = new_hero_rel_pos
	level_pos -= delta * level_speed
	level_root.translation = Vector3(level_pos, 0, 0)
	$LevelRoot/AutoGenLevel.update_visibility(-level_pos, screen_width)
	
	if level_pos - hero_rel_pos.x < -($LevelRoot/AutoGenLevel.real_level_length - 6):
		level_speed = 0.0
		controls_enabled = false
		var complete = calc_distance_to_wincon(hero.color, $LevelRoot/AutoGenLevel.win_condition_color)
		if complete >= 0.85:
			$UI/Message/WinMessage.show()
		else:
			$UI/Message/LooseMessage.show()
		wait_for_any_key = true


func distance(col1, col2):
	var vec1 = Vector3(col1.r, col1.g, col1.b)
	var vec2 = Vector3(col2.r, col2.g, col2.b)
	return abs((vec2 - vec1).length())


func calc_distance_to_wincon(curr, wincon) -> float:
	var from_white_to_wincon = distance(Color(1.0, 1.0, 1.0), wincon)
	var from_curr_to_wincon = distance(curr, wincon)
	return abs(from_white_to_wincon - from_curr_to_wincon) / from_white_to_wincon


func _on_Hero_color_updated(col):
	if hero_color:
		hero_color.color = col
	if win_con_label:
		var complete = calc_distance_to_wincon(col, $LevelRoot/AutoGenLevel.win_condition_color)
		win_con_label.text = str(int(complete * 100.0)) + "%"


func _on_AutoGenLevel_win_condition_color_updated(color):
	print("WinCon: ", color)
	if win_con_color:
		print("Setting WinCon")
		win_con_color.color = color


func _on_Hero_died():
	level_speed = 0.0
	controls_enabled = false
	$UI/Message/LooseMessage.show()
	wait_for_any_key = true
