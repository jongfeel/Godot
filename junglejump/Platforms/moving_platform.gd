extends Node2D

@export var offset = Vector2(320, 0)
@export var duration = 10.0

func _ready() -> void:
	var tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops()
	tween.tween_property($TileMap, "position", offset, duration / 2.0)
	tween.tween_property($TileMap, "position", Vector2.ZERO, duration / 2.0)
