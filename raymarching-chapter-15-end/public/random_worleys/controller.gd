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
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/ExponentSlider/HSlider.value_changed.connect(exponent_slider_updater)
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/RandomizeButton.pressed.connect(randomize_f_values)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shader_setter(value, control_name):
	var uniform_name = control_name
	uniform_name = uniform_name.to_lower()
	if value is String:
		value = value.to_float()

		shader_material.set_shader_parameter(uniform_name, value)
	elif value is bool:
		shader_material.set_shader_parameter(uniform_name, value)
	else:
		push_warning("The shader_setter function received an unhandled type for " + uniform_name)
		print("The shader_setter function has pushed a warning.")

func exponent_slider_updater(updated_value:float):
	var exponent_node = $CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/Exponent/LineEdit
	var updated_value_as_string = str(updated_value)
	exponent_node.text = updated_value_as_string
	shader_material.set_shader_parameter("exponent", updated_value)
	
func weighted_random_number(exponent:float, multiplier:float):
	var x = randf_range(-1.0, 1.0) #random float between -1 and 1
	var sign_of_x = sign(x) #store the sign of x as -1, 0, or 1
	var x_weighted_to_center = pow(abs(x),exponent) #pull the result closer to zero based on
	# strength of exponent
	return sign_of_x * x_weighted_to_center * multiplier #restore sign and use multiplier to produce
	#numbers outside of the -1 to 1 range.
	
func randomize_f_values() ->void:
	var f0 = weighted_random_number(3.0, 10)
	var f1 = weighted_random_number(3.0, 5)
	var f2 = weighted_random_number(3.0, 4)
	var f3 = weighted_random_number(3.0, 3)
	var f4 = weighted_random_number(3.0, 2)
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F0/LineEdit.text = str(f0)
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F1/LineEdit.text = str(f1)
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F2/LineEdit.text = str(f2)
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F3/LineEdit.text = str(f3)
	$CanvasLayer/MarginContainer/HBoxContainer/ShaderSettings/F4/LineEdit.text = str(f4)
	shader_material.set_shader_parameter("f0", f0)
	shader_material.set_shader_parameter("f1", f1)
	shader_material.set_shader_parameter("f2", f2)
	shader_material.set_shader_parameter("f3", f3)
	shader_material.set_shader_parameter("f4", f4)
	
