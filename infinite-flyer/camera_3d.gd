extends Camera3D

@export var target_path : NodePath
@export var offset = Vector3.ZERO

var target = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target_path:
		target = get_node(target_path)
		position = target.position + offset
		look_at(target.position)

func _physics_process(_delta: float) -> void:
	if !target:
		return
	position = target.position + offset
