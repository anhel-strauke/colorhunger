extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _pivot_updated = false

func _update_pivot():
	self.rect_pivot_offset = self.rect_size / 2
	_pivot_updated = true

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().connect("size_changed", self, "_update_pivot")
	_pivot_updated = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rect_size.x > 0 and rect_size.y > 0 and not _pivot_updated:
		_update_pivot()
