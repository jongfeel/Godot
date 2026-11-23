extends Control

func _ready() -> void:
	$TextureButton.grab_focus()

# The default ui_accept action has no gamepad button, so handle it here.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.button_index == JOY_BUTTON_A and event.pressed:
		get_viewport().set_input_as_handled()
		_on_texture_button_pressed()

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
