extends OmniLight

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var stage;
var orig_y;
# Called when the node enters the scene tree for the first time.
func my_init(tr):
	translation = tr
	stage = rand_range(0.0, 1.0);
	orig_y = translation.y

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
