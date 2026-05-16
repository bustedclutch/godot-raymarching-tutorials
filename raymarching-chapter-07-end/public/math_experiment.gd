extends Node3D

##Chapter 7: Convert the noise function from shader code to gdscript.
#float simple_hash_noise(vec3 p, float t) {
	#return fract(sin(dot(p+t,vec3(13.74,71.89,31.92)))*10000.01);
#}

var some_vector : Vector3 = Vector3(13.74,71.89,31.92)
var some_float : float = 10000.01
var simple_point : Vector3 = Vector3(2.0, 5.0, 7.0)
var slightly_different_point := Vector3(2.00001, 5.0, 7.0)

func simple_hash_noise(p: Vector3, t:float):
	#return fract(sin(dot(p+t, some_vector))*some_float)
	#return fractional_part(sin(dot(p+t, some_vector))*some_float)
	#return fractional_part(sin(  dot(p+Vector3(t,t,t), some_vector)  )*some_float)
	return fractional_part(sin(  (p+Vector3(t,t,t)).dot(some_vector)  )*some_float)

##Create a fract function, since it doesn't exist in gdscript.
func fractional_part(x: float):
	return x - floor(x)

func quantized_vector(vector : Vector3):
	var x = floor(vector.x*100)/100
	var y = floor(vector.y*100)/100
	var z = floor(vector.z*100)/100
	return Vector3(x,y,z)
	
func smoother_hash_noise(p: Vector3, t:float):
	return fractional_part(sin(  (p+Vector3(t,t,t)).dot(some_vector)  )*1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(simple_hash_noise(simple_point, 1.0))
	print(simple_hash_noise(slightly_different_point,1.0))
	#Quantized
	print(simple_hash_noise(quantized_vector(simple_point), 1.0))
	print(simple_hash_noise(quantized_vector(slightly_different_point),1.0))
	#Smoother hash
	print(smoother_hash_noise(simple_point,1.0))
	print(smoother_hash_noise(slightly_different_point,1.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
