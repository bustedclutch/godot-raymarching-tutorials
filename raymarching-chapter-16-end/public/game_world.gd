@tool

extends Node3D

#Getting all the variables needed in the process function to pass every frame
#into the the shader.
@onready var camera = $CharacterBody3D/CameraPivot/Camera3D
@onready var marble1 = $Marble1
@onready var marble2 = $Marble2
@onready var marble3 = $Marble3
@onready var game_floor = $GameFloor/CollisionShape3D

@onready var raymarching_gel = $CharacterBody3D/CameraPivot/Camera3D/RaymarchingGel
@onready var shader_material = raymarching_gel.get_active_material(0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	shader_material.set_shader_parameter("camera_pos", camera.global_position)
	shader_material.set_shader_parameter("camera_basis", camera.global_basis)
	shader_material.set_shader_parameter("marble1_pos", marble1.global_position)
	shader_material.set_shader_parameter("marble2_pos", marble2.global_position)
	shader_material.set_shader_parameter("marble3_pos", marble3.global_position)
	shader_material.set_shader_parameter("game_floor_pos", game_floor.global_position)
	shader_material.set_shader_parameter("game_floor_size", game_floor.shape.size)
