extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _update_sizes():
	var viewport_height = get_tree().get_root().size.y
	var sep = 30 * viewport_height / 720
	$Buttons.add_constant_override("separation", sep)
	var font = load("res://fonts/play_font.tres")
	font.size = 40 * viewport_height / 720
	for button in $Buttons.get_children():
		if button.get_class() == "Button":
			button.add_font_override("font", font)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().connect("size_changed", self, "_update_sizes")
	_update_sizes()
	if OS.get_name() == "HTML5":
		$Buttons/ExitButton.hide()
	$AnimationPlayer.play("idle")
	$StartupAnimationPlayer.play("startup")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_CreditsButton_pressed():
	get_tree().change_scene("res://scenes/ui/Credits.tscn")


func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/ui/greeter.tscn")


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
