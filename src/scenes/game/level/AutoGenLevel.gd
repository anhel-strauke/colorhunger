extends Spatial

var tiles = []

export var level_length: float = 0.0

onready var tile_resources = [
	preload("res://scenes/game/level/tiles/test_tile_1.tscn"),
	preload("res://scenes/game/level/tiles/test_tile_2.tscn"),
	preload("res://scenes/game/level/tiles/test_tile_3.tscn"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	if level_length > 0.0:
		generate_level(level_length)


func update_visibility(from_pos: float, screen_w: float):
	var cur_pos: float = 0.0
	for tile in tiles:
		tile.visible = false
		if cur_pos + tile.tile_width >= from_pos or cur_pos <= from_pos + screen_w:
			tile.visible = true
		cur_pos += tile.tile_width


func generate_level(length: float):
	for tile in tiles:
		self.remove_child(tile)
		tile.queue_free()
	tiles = []
	var	curr_length = 0.0
	while curr_length < length:
		var res: Resource = tile_resources[randi() % len(tile_resources)]
		var tile: Spatial = res.instance()
		self.add_child(tile)
		tile.translation = Vector3(curr_length + tile.tile_width / 2, 0, 0)
		curr_length += tile.tile_width

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
