extends Spatial

signal win_condition_color_updated(color)

onready var color_tool = preload("res://scenes/game/ColorTool.gd").new()

var tiles = []
var real_level_length: float = 0.0
var items = []
var walls = []
var portal = null
var level_index = 1
var win_condition_colors = {}
var win_condition_color: Color

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

onready var wall_resources = [
	preload("res://scenes/game/level/tiles/Wall_1.tscn"),
	preload("res://scenes/game/level/tiles/Wall_1.tscn"),
]

onready var decale_resources = [
	preload("res://scenes/game/level/tiles/decale_test_1.tscn"),
	preload("res://scenes/game/level/tiles/decale_test_2.tscn")
]


onready var random_colors = [
	Color(1.0, 0.0, 0.0),
	Color(0.0, 1.0, 0.0),
	Color(0.0, 0.0, 1.0)
]

onready var portal_res = preload("res://scenes/game/level/objects/Portal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
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


func _safety_zone_length():
	if level_index == 1:
		return 50
	elif level_index < 7:
		return 30
	return 10
	


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
		tiles.append(tile)
		tile.translation = Vector3(real_level_length + tile.tile_width / 2, 0, 0)
		real_level_length += tile.tile_width


func _make_walls():
	_make_walls_on(false)
	_make_walls_on(true)


func _make_walls_on(mirror: bool):
	var wall_length = 0.0
	while wall_length < real_level_length:
		var wall_res = wall_resources[randi() % len(wall_resources)]
		var wall: Spatial = wall_res.instance()
		self.add_child(wall)
		wall.translation = Vector3(wall_length + wall.tile_width / 2, 0, 0)
		if mirror:
			wall.scale = Vector3(0.0, 0.0, -1.0)
		wall_length += wall.tile_width
		walls.append(wall)
		


func _make_items(items_count: int):
	var safe_dist = _safety_zone_length()
	for item in items:
		self.remove_child(item)
		item.queue_free()
	for i in range(items_count):
		var new_item: Spatial = item_resources[0].instance()
		var z_pos = rand_range(-3.2, 3.2)
		var x_pos = rand_range(safe_dist, real_level_length - 12)
		self.add_child(new_item)
		if level_index == 1:
			new_item.set_color(random_colors[0])
		elif level_index == 2:
			new_item.set_color(random_colors[randi() % 2])
		else:
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


func _make_portal():
	if portal:
		remove_child(portal)
		portal.queue_free()
	portal = portal_res.instance()
	add_child(portal)
	portal.translation = Vector3(real_level_length - 6.0, 4.0, 0.0)
	portal.set_color(win_condition_color)


func _place_decales():
	for tile in tiles:
		if tile.accept_decales:
			if randf() > 0.3:
				var decale_res = decale_resources[randi() % len(decale_resources)]
				var decale = decale_res.instance()
				tile.add_child(decale)
				var h_shift_max = tile.tile_width - decale.tile_width
				var v_shift_max = tile.tile_height - decale.tile_height
				decale.translation = Vector3(randf() * h_shift_max, 2.0, randf() * v_shift_max)
 

func randint(a: int, b: int) -> int:
	var r = b - a
	return a + randi() % r


func _make_win_condition():
	if level_index == 1:
		win_condition_colors = {
			random_colors[0]: 1	
		}
	else:
		var total_items = len(items)
		var num_items = randint(int(total_items / 4), int(total_items / 2))
		var colors = []
		for item in items:
			colors.append(item.color)
		for i in range(num_items):
			var index = randi() % len(colors)
			if win_condition_colors.has(colors[index]):
				win_condition_colors[colors[index]] += 1
			else:
				win_condition_colors[colors[index]] = 1
			colors.remove(index)
	win_condition_color = color_tool.mix_colors_dict(win_condition_colors)
	emit_signal("win_condition_color_updated", win_condition_color)


func generate_level(length: float, items: int):
	_make_floor(length)
	_make_walls()
	_make_items(items)
	_make_win_condition()
	_make_portal()
	_place_decales()


func run_level(index: int):
	level_index = index
	if index == 1:
		generate_level(150, 5)
	elif index == 2:
		generate_level(200, 10)
	else:
		generate_level(200 + 10 * index, 25 + int(index / 2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
