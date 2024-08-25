extends CharacterBody2D

@export var gravity = 750
@export var run_speed = 150
@export var jump_speed = -300

enum { IDLE, RUN, JUMP, HURT, DEAD }
var state = IDLE

func _ready():
	change_state(IDLE)
	
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
		RUN:
			$AnimationPlayer.play("run")
		HURT:
			$AnimationPlayer.play("hurt")
		JUMP:
			$AnimationPlayer.play("jump_up")
		DEAD:
			hide()
