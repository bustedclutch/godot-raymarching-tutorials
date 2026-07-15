extends Node

@export var shaded_object : MeshInstance3D
@onready var shader_material = shaded_object.get_active_material(0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	##Below line ineffective, as it doesn't carry the name of the node emitting the signal.
	#$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F0/LineEdit.text_changed.connect(shader_setter)
	
#	Corrected code to bind the control names along with the signal.
#	WARNING: Below code uses capital names! Use to_lower() later when creating uniform names.
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F0/LineEdit.text_changed.connect(shader_setter.bind("F0"))
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F1/LineEdit.text_changed.connect(shader_setter.bind("F1"))
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F2/LineEdit.text_changed.connect(shader_setter.bind("F2"))
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F3/LineEdit.text_changed.connect(shader_setter.bind("F3"))
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F4/LineEdit.text_changed.connect(shader_setter.bind("F4"))
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/Exponent/LineEdit.text_changed.connect(shader_setter.bind("Exponent"))
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/NormalizeFactor/LineEdit.text_changed.connect(shader_setter.bind("Normalize_Factor"))
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/NormalizeXButton.toggled.connect(shader_setter.bind("Normalized_Bool"))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shader_setter(value, control_name):
	var uniform_name = control_name
	uniform_name = uniform_name.to_lower()
	if value is String:
		value = value.to_float()
		shaded_object.set_shader_parameter(uniform_name, value)
	elif value is bool:
		shaded_object.set_shader_parameter(uniform_name, value)
	else:
		push_warning("The shader_setter function received an unhandled type for " + uniform_name)
		print("The shader_setter function has pushed a warning.")
