extends RigidBody3D

signal stopped(angle: float)

var was_moving = false
var last_direction = Vector3.FORWARD

func shoot(angle, power) -> void:
	var force = Vector3.FORWARD.rotated(Vector3.UP, angle)
	apply_central_impulse(force * power)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if state.linear_velocity.length() < 0.1:
		state.linear_velocity = Vector3.ZERO
		if was_moving:
			var angle = Vector3.FORWARD.signed_angle_to(last_direction, Vector3.UP)
			stopped.emit(angle)
		was_moving = false
	else:
		last_direction = Vector3(state.linear_velocity.x, 0, state.linear_velocity.z)
		was_moving = true
	if position.y < -20:
		get_tree().reload_current_scene()
