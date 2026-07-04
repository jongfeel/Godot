extends Node2D

signal score_changed

var item_scene = load("res://Items/item.tscn")
var door_scene = load("res://Items/door.tscn")

var score = 0: set = set_score

func _ready():
	$Items.hide()
	$Player.reset($SpawnPoint.position)
	set_camera_limits()
	spawn_items()
	create_ladders()
	
func set_camera_limits():
	var map_size = $World.get_used_rect()
	var cell_size = $World.tile_set.tile_size
	$Player/Camera2D.limit_left = (map_size.position.x - 5) * cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 5) * cell_size.x
	
func spawn_items():
	var item_cells = $Items.get_used_cells(0)
	for cell in item_cells:
		var data = $Items.get_cell_tile_data(0, cell)
		var type = data.get_custom_data("type")
		if type == "door":
			var door = door_scene.instantiate()
			add_child(door)
			door.position = $Items.map_to_local(cell)
			door.body_entered.connect(_on_door_entered)
		else:
			var item = item_scene.instantiate()
			add_child(item)
			item.init(type, $Items.map_to_local(cell))
			item.picked_up.connect(self._on_item_picked_up)
		
func _on_item_picked_up():
	score += 1
	$ITEM_PICKED_UP_AudioStreamPlayer2D.play()
	
func set_score(value):
	score = value
	score_changed.emit(score)

func _on_player_died():
	GameState.restart()

func _on_door_entered(body):
	GameState.next_level()
	
func create_ladders():
	var top_cells = {}
	var cells = $World.get_used_cells(0)
	for cell in cells:
		var data = $World.get_cell_tile_data(0, cell)
		if data.get_custom_data("special") == "ladder":
			var c = CollisionShape2D.new()
			$Ladders.add_child(c)
			c.position = $World.map_to_local(cell)
			var s = RectangleShape2D.new()
			s.size = Vector2(8, 16)
			c.shape = s
			if not top_cells.has(cell.x) or cell.y < top_cells[cell.x]:
				top_cells[cell.x] = cell.y
	for x in top_cells:
		create_ladder_top(Vector2i(x, top_cells[x]))

func create_ladder_top(cell):
	var cell_size = $World.tile_set.tile_size
	var body = StaticBody2D.new()
	body.collision_layer = 1
	body.collision_mask = 0
	add_child(body)
	body.position = $World.map_to_local(cell)
	var c = CollisionShape2D.new()
	c.one_way_collision = true
	var s = RectangleShape2D.new()
	s.size = Vector2(cell_size.x, 2)
	c.shape = s
	c.position = Vector2(0, -cell_size.y / 2.0 + s.size.y / 2.0)
	body.add_child(c)
