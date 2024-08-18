extends Node

@export var rock_scene : PackedScene
@export var enemy_scene : PackedScene

var screensize = Vector2.ZERO

var level = 0
var score = 0
var playing = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
		
func spawn_rock(size, pos=null, vel=null):
	if pos == null:
		$RockPath/RockSpawn.progress = randi()
		pos = $RockPath/RockSpawn.position
	if vel == null:
		vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(50, 125)
	var r = rock_scene.instantiate()
	r.screensize = screensize
	r.start(pos, vel, size)
	call_deferred("add_child", r)
	r.exploded.connect(self._on_rock_exploded)

func _on_rock_exploded(size, radius, pos, vel):
	score += 10 * size
	if size <= 1:
		return
	for offset in [-1, 1]:
		var dir = $Player.position.direction_to(pos).orthogonal() * offset
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.1
		spawn_rock(size - 1, newpos, newvel)
		
func new_game():
	get_tree().call_group("rocks", "queue_free()")
	level = 0
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Player.reset()
	await $HUD/Timer.timeout
	playing = true
	
func new_level():
	level += 1
	$HUD.show_message("Wave %s" % level)
	for i in level:
		spawn_rock(3)
	$EnemyTimer.start(randf_range(1, 2))

func _process(_delta):
	if not playing:
		return
	if get_tree().get_nodes_in_group("rocks").size() == 0:
		new_level()
		
func game_over():
	playing = false
	$HUD.game_over()
	
func _input(event):
	if event.is_action_pressed("pause"):
		if not playing:
			return
		get_tree().paused = not get_tree().paused
		var message = $HUD/VBoxContainer/Message
		if get_tree().paused:
			message.text = "Paused"
			message.show()
		else:
			message.text = ""
			message.hide()

func _on_enemy_timer_timeout():
	var e = enemy_scene.instantiate()
	add_child(e)
	e.target = $Player
	$EnemyTimer.start(randf_range(2, 4))
