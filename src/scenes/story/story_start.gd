extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func run_menu():
	get_tree().change_scene("res://scenes/ui/MainMenu.tscn")
	
func _input(event):
	if event.is_action_released("ui_accept") or (event is InputEventMouseButton 
			and event.is_pressed() and event.get_button_index() == BUTTON_LEFT):
		run_menu()