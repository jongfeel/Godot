extends CanvasLayer

@onready var power_bar = $MarginContainer/VBoxContainer/PowerBar
@onready var shots = $MarginContainer/VBoxContainer/Shots

var bar_textures = {
	"green": preload("res://assets/bar_green.png"),
	"yellow": preload("res://assets/bar_yellow.png"),
	"red": preload("res://assets/bar_red.png")
}

var message_token := 0

func update_shots(value: int) -> void:
	shots.text = "Shots: %s" % value

func update_power_bar(value: float) -> void:
	power_bar.texture_progress = bar_textures["green"]
	if value > 70:
		power_bar.texture_progress = bar_textures["red"]
	elif value > 40:
		power_bar.texture_progress = bar_textures["yellow"]
	power_bar.value = value

func show_message(text: String) -> void:
	message_token += 1
	var current_token = message_token
	$Message.text = text
	$Message.show()
	await get_tree().create_timer(2).timeout
	if current_token == message_token:
		$Message.hide()
