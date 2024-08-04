extends Area2D

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)
var spriteHalfWidth = 33 / 2
var spriteHalfHeight = 32 / 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	position.x = clamp(position.x, spriteHalfWidth, screensize.x - spriteHalfWidth)
	position.y = clamp(position.y, spriteHalfHeight, screensize.y - spriteHalfHeight)
	pass
