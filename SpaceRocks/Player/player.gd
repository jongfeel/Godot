extends RigidBody2D

enum { INIT, ALIVE, INVULNERABLE, DEAD }
var state = INIT

func _ready():
	change_state(ALIVE)

	
func change_state(new_state):
	$CollisionShape2D.set_deferred("disabled", new_state == ALIVE)
	state = new_state

