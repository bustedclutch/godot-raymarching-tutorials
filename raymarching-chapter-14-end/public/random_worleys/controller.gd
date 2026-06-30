extends Node

@export var shaded_object : MeshInstance3D
@onready var shader_material = shaded_object.get_active_material(0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shader_setter(value, control):
	pass
	
