extends RigidBody2D

@export var engine_power = 500
@export var spin_power = 8000

@export var bullet_scene : PackedScene
@export var fire_rate = 0.25

var can_shoot = true

var thrust = Vector2.ZERO
var rotation_dir = 0

enum { INIT, ALIVE, INVULNERABLE, DEAD }
var state = INIT

var screensize = Vector2.ZERO

var radius

signal lives_changed
signal dead

var reset_pos = false
var lives = 0: set = set_lives

signal shield_changed

@export var max_shield = 100.0
@export var shield_regen = 5.0

var shield = 0: set = set_shield

func _ready():
	change_state(ALIVE)
	screensize = get_viewport_rect().size
	$GunCooldown.wait_time = fire_rate
	radius = int($Sprite2D.texture.get_size().x / 2 * $Sprite2D.scale.x)

func _process(delta):
	get_input()
	shield += shield_regen * delta
	
func change_state(new_state):
	match new_state:
		INIT:
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite2D.modulate.a = 0.5
		ALIVE:
			$CollisionShape2D.set_deferred("disabled", false)
			$Sprite2D.modulate.a = 1.0
		INVULNERABLE:
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite2D.modulate.a = 0.5
			$InvulnerabilityTimer.start()
		DEAD:
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite2D.hide()
			linear_velocity = Vector2.ZERO
			dead.emit()
	state = new_state

func get_input():
	thrust = Vector2.ZERO
	if state in [DEAD, INIT]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
	rotation_dir = Input.get_axis("rotate_left", "rotate_right")
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
	
func _physics_process(_delta):
	constant_force = thrust
	constant_torque = rotation_dir * spin_power

func _integrate_forces(physics_state):
	var xform = physics_state.transform
	xform.origin.x = wrapf(xform.origin.x, 0 - radius, screensize.x + radius)
	xform.origin.y = wrapf(xform.origin.y, 0 - radius, screensize.y + radius)
	physics_state.transform = xform
	if reset_pos:
		physics_state.transform.origin = screensize / 2
		reset_pos = false

func shoot():
	if state == INVULNERABLE:
		return
	can_shoot = false
	$GunCooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start($Muzzle.global_transform)

func _on_gun_cooldown_timeout():
	can_shoot = true

func set_lives(value):
	shield = max_shield
	lives = value
	lives_changed.emit(lives)
	if lives <= 0:
		change_state(DEAD)
	else:
		change_state(INVULNERABLE)

func reset():
	reset_pos = true
	$Sprite2D.show()
	lives = 3
	change_state(ALIVE)

func _on_invulnerability_timer_timeout():
	change_state(ALIVE)

func _on_body_entered(body):
	if body.is_in_group("rocks"):
		shield -= body.size * 25
		body.explode()
		
func explode():
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
	await $Explosion/AnimationPlayer.animation_finished
	$Explosion.hide()

func set_shield(value):
	value = min(value, max_shield)
	shield = value
	shield_changed.emit(shield / max_shield)
	if shield <= 0:
		lives -= 1
		explode()
