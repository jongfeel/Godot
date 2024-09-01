extends Area2D

signal picked_up

var textures = {
	"cherry": "res://assets/sprites/cherry.png",
	"gem": "res://assets/sprites/gem.png",
}

func init(type, _position):
	$Sprite2D.texture = load(textures[type])
	position = _position
	

func _on_body_entered(_body):
	picked_up.emit()
	queue_free()
