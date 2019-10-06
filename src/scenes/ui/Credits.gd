extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(String, FILE) var return_to_scene = "res://scenes/ui/MainMenu.tscn"

onready var anim_player = $ShowAnimationPlayer
onready var hide_anim_player = $HideAnimationPlayer

var main_font = preload("res://fonts/play_font.tres")
var header_font = preload("res://fonts/credits_font.tres")

onready var main_font_base_size = 40
onready var header_font_base_size = 30

const text = [
	"AND TAK SOIDET GAMES",
	"",
	"",
	"#Design / Sounds / Management",
	"Dina",
	"",
	"#Game Art",
	"Evy",
	"Oksana",
	"Sofa",
	"",
	"#3D Models",
	"Oda",
	"",
	"#Programming",
	"Anhel",
	"",
	"#VFX Programming",
	"Scoba",
	"",
	"#Music",
	"BlazeDi",
	"",
	"#Special Thanks",
	"Dari",
	"",
	"#Made with Godot Engine at Siberian Game Jam (5-6 Oct 2019)",
]

var labels = []
var header_labels = []

func _update_sizes():
	var viewport_height = get_tree().get_root().size.y
	main_font.size = main_font_base_size * viewport_height / 720
	header_font.size = header_font_base_size * viewport_height / 720


func _build_animation():
	var anim = Animation.new()
	var delta = 0.6
	var start_at = 0.8
	var stop_at = 0.2
	var anim_length = 12
	var index = 0
	for s in text:
		var lbl: Label = Label.new()
		lbl.name = "Label" + str(index)
		lbl.align = Label.ALIGN_CENTER
		var is_hdr = (len(s) > 0 && s[0] == "#")
		if is_hdr:
			lbl.text = s.substr(1, s.length() - 1)
			lbl.add_font_override("font", header_font)
			header_labels.append(lbl)
			anim_length += 0.3
		else:
			lbl.add_font_override("font", main_font)
			lbl.text = s
		add_child(lbl)
		labels.append(lbl)
		lbl.anchor_left = 0.0
		lbl.anchor_right = 1.0
		lbl.anchor_top = start_at
		lbl.margin_left = 0
		lbl.margin_right = 0
		lbl.margin_top = 0
		lbl.margin_bottom = 0.0
		lbl.modulate = Color(1.0, 1.0, 1.0, 0.0)
		anim_length += delta
		index += 1
		
	anim.set_length(anim_length)
		
	var time = 0.5
	
	for lbl in labels:
		var ta = anim.add_track(Animation.TYPE_VALUE)
		var tt = anim.add_track(Animation.TYPE_VALUE)
		var tm = anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(ta, lbl.name + ":modulate:a")
		anim.track_insert_key(ta, 0.0, 0.0)
		anim.track_insert_key(ta, time, 0.0)
		anim.track_insert_key(ta, time + 0.5, 1.0)
		anim.track_insert_key(ta, time + 5.5, 1.0)
		anim.track_insert_key(ta, time + 6.0, 0.0)
		anim.track_set_path(tt, lbl.name + ":anchor_top")
		anim.track_insert_key(tt, 0.0, start_at)
		anim.track_insert_key(tt, time, start_at)
		anim.track_insert_key(tt, time + 6.0, stop_at)
		anim.track_set_path(tm, lbl.name + ":margin_top")
		anim.track_set_interpolation_type(tm, Animation.INTERPOLATION_CUBIC)
		anim.track_insert_key(tm, 0.0, 0.0)
		anim.track_insert_key(tm, time, 0.0)
		anim.track_insert_key(tm, time + 6.0, 0.0)
		time += delta
#		if header_labels.find(lbl):
#			time += 0.3
		
	anim_player.add_animation("show", anim)


#	for child in $VBoxContainer.get_children():
#		if child is Control:
#			labels.append(child)
#			anim_length += delta
#			if child.size_flags_vertical & Control.SIZE_EXPAND:
#				anim_length += header_add_delta
#	anim.set_length(anim_length)
#	for label in labels:
#		if label.size_flags_vertical & Control.SIZE_EXPAND:
#			time += header_add_delta
#		label.modulate.a = 0.0
#		var track = anim.add_track(Animation.TYPE_VALUE)
#		anim.track_set_path(track, NodePath("VBoxContainer/" + label.name + ":modulate:a"))
#		anim.track_insert_key(track, 0.0, 0.0)
#		anim.track_insert_key(track, time, 0.0)
#		anim.track_insert_key(track, time + show_time, 1.0)
#		anim.track_insert_key(track, anim_length, 1.0)
#		time += delta
#	anim_player.add_animation("show", anim)


# Called when the node enters the scene tree for the first time.
func _ready():
	if not anim_player.has_animation("show"):
		_build_animation()
	_update_sizes()
	get_tree().get_root().connect("size_changed", self, "_update_sizes")
	anim_player.play("show")
	hide_anim_player.play("show")


func go_to_next_scene():
	get_tree().change_scene(return_to_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if event.is_action_released("ui_accept") or (event is InputEventMouseButton 
			and event.is_pressed() and event.get_button_index() == BUTTON_LEFT):
		if not (hide_anim_player.is_playing() and hide_anim_player.current_animation == "hide"):
			hide_anim_player.play("hide")