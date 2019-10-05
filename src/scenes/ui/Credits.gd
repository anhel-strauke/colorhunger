extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(String, FILE) var return_to_scene = "res://scenes/ui/MainMenu.tscn"

onready var anim_player = $ShowAnimationPlayer
onready var hide_anim_player = $HideAnimationPlayer

var labels = []

func _update_sizes():
	var viewport_height = get_tree().get_root().size.y
	var font = load("res://fonts/credits_font.tres")
	font.size = font.size * viewport_height / 720
	for label in labels:
		label.add_font_override("font", font)


func _build_animation():
	var anim = Animation.new()
	var time = 0.5
	var show_time = 0.5
	var delta = 0.7
	var header_add_delta = 0.5
	var anim_length = time
	for child in $VBoxContainer.get_children():
		if child is Control:
			labels.append(child)
			anim_length += delta
			if child.size_flags_vertical & Control.SIZE_EXPAND:
				anim_length += header_add_delta
	anim.set_length(anim_length)
	for label in labels:
		if label.size_flags_vertical & Control.SIZE_EXPAND:
			time += header_add_delta
		label.modulate.a = 0.0
		var track = anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(track, NodePath("VBoxContainer/" + label.name + ":modulate:a"))
		anim.track_insert_key(track, 0.0, 0.0)
		anim.track_insert_key(track, time, 0.0)
		anim.track_insert_key(track, time + show_time, 1.0)
		anim.track_insert_key(track, anim_length, 1.0)
		time += delta
	anim_player.add_animation("show", anim)


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