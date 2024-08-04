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
	
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	pass

func start():
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"
	
func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)
