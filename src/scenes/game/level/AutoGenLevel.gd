extends Spatial

var tiles = []
var real_level_length: float = 0.0
var items = []

export var level_length: float = 0.0

onready var tile_resources = [
	#preload("res://scenes/game/level/tiles/test_tile_1.tscn"),
	preload("res://scenes/game/level/tiles/test_tile_2.tscn"),
	#preload("res://scenes/game/level/tiles/test_tile_3.tscn"),
	preload("res://scenes/game/level/tiles/test_tile_4.tscn"),
]

onready var item_resources = [
	preload("res://scenes/game/level/objects/RedSphere.tscn"),
]

onready var random_colors = [
	Color(1.0, 0.0, 0.0),
	Color(0.0, 1.0, 0.0),
	Color(0.0, 0.0, 1.0)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	if level_length > 0.0:
		generate_level(level_length, 30)


func update_visibility(from_pos: float, screen_w: float):
	var cur_pos: float = 0.0
	for tile in tiles:
		tile.visible = false
		if cur_pos + tile.tile_width >= from_pos or cur_pos <= from_pos + screen_w:
			tile.visible = true
		cur_pos += tile.tile_width
	#for item in items:
	#	if item.translation


func _make_floor(length: float):
	for tile in tiles:
		self.remove_child(tile)
		tile.queue_free()
	tiles = []
	real_level_length = 0.0
	while real_level_length < length:
		var res: Resource = tile_resources[randi() % len(tile_resources)]
		var tile: Spatial = res.instance()
		self.add_child(tile)
		tile.translation = Vector3(real_level_length + tile.tile_width / 2, 0, 0)
		real_level_length += tile.tile_width


func _make_items(items_count: int):
	for item in items:
		self.remove_child(item)
		item.queue_free()
	for i in range(items_count):
		var new_item: Spatial = item_resources[0].instance()
		var z_pos = rand_range(-3.5, 3.5)
		var x_pos = rand_range(0.0, real_level_length)
		self.add_child(new_item)
		new_item.set_color(random_colors[randi() % len(random_colors)])
		new_item.translation = Vector3(x_pos, 4.0, z_pos)
		new_item.connect("kill_me", self, "kill_item")
		items.append(new_item)


func kill_item(item):
	var index = items.find(item)
	if index >= 0:
		items.remove(index)
		self.remove_child(item)
		item.queue_free()


func generate_level(length: float, items: int):
	_make_floor(length)
	_make_items(items)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
