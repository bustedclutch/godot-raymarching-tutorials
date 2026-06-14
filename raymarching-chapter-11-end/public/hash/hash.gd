extends Node3D

##A simple vec2 to integer converter for hashing purposes
func combine_x_and_y_to_uint(x: int, y: int) -> int:
	x *= 0x27d4eb2d #multiply by a big random odd constant
	y *= 0x165667b1 #multiply by some other big random odd constant
	x &= 0xFFFFFFFF #AND mask to prevent 64 bit CPU from diverging from 32 bit GPU
	y &= 0xFFFFFFFF #AND mask to prevent 64 bit CPU from diverging from 32 bit GPU
	return x ^ y #return x combined with y using XOR
	
	
###These functions are too inefficient, so they get replaced with a
###unified function, below. But uncomment if you want to see
###how I initially wrote a less efficient version.
#func normalized_x_hash_half(input: int) -> float:
	#input = input >> 16 #	bitshift 16 places to the right, capturing 
	##						the left 16 bits of the binary number
	#var result : float = input / 65536.0 #divide by the total number of possibilities
	##									possible in a 16 bit number
	#print("The x half is " + str(result))
	#return result
	#
#func normalized_y_hash_half(input: int) -> float:
	#input &= 0xFFFF #eliminate the left 16 bits of the binary number, 
	##				capturing the right sixteen bits only.
	#var result : float = input / 65536.0 #divide by total number of possible numbers
	#print("The y half is " + str(result))
	#return result
	
func print_x_and_y_halves(input: int) -> void:
	var x : int = input >> 16 #	bitshift 16 places to the right, capturing 
	#						the left 16 bits of the binary number
	var y : int = input & 0xFFFF #eliminate the left 16 bits of the binary number,
	#								capturing the right sixteen bits only.
	var x_float : float = x / 65536.0
	var y_float : float = y / 65536.0
	print("The random x coordinate is " + str(x_float) + " and the random y coordinate is " + str(y_float))
	
	
func wellons_integer_hash(input: int) -> int:
	var x = input
	print(str(x) + " is the input integer.")
	print(to_binary(x) + " is the initial input in binary.")
	print(to_binary(x>>16) + " is X bitshifted.")
	x ^= x >> 16
	print(to_binary(x) + " the XOR result of the input and bitshifted input")
	x *= 0x7feb352d # 	2,146,121,005 in hex form,
	#					0111 1111 1110 1011 0011 0101 0010 1101 is binary
	print(to_binary(x) + " after getting multiplied by magic constant number one")
	x &= 0xFFFFFFFF # A chain of 32 ones in binary
	print(to_binary(x) + " after masking out the numbers on the left half, if any exist")
	print(to_binary(x>>15) + " after a bit shift 15 spaces right")
	x ^= x >> 15
	print(to_binary(x) + " the XOR result of the previous two values.")
	x *= 0x846ca68b # 	2221713035 in hex form, and in binary...
	#					1000   0100   0110   1100   1010   0110   1000   1011
	print(to_binary(x) + " after multiplying by the second magic constant")
	x &= 0xFFFFFFFF
	print(to_binary(x) + " after masking out the numbers on the left half, if any exist")
	print(to_binary(x>>16) + " the third and final bitshift, sixteen places to the right")
	x ^= x >> 16
	print(to_binary(x) + " XOR on the previous two values")
	var hashed_integer_result = x
	return hashed_integer_result

##Claude's binary display function

func to_binary(x: int, width: int = 32) -> String:
	var s := String.num_int64(x, 2).lpad(width, "0")
	var out := ""
	for i in s.length():
		if i > 0 and i % 8 == 0:
			out += " "
		out += s[i]
	return out

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var x : int = 1
	var y : int = 3
	var combined_x_and_y = combine_x_and_y_to_uint(x, y)
	var combo_hashed = wellons_integer_hash(combined_x_and_y)
	print_x_and_y_halves(combo_hashed)
	

	
	#var random : float = x / 4294967296.0
	#print("Dividing the resulting number between the total number of all possible values to get a result between 0 and 1")
	#print("Random number between 0 and 1 is: " + str(random))

##	Inverting the Wellons Hash.

	#x ^= x >> 16                                  # step 5 undone
	#x = (x * 0x43021123) & 0xFFFFFFFF             # step 4 undone — INV of 0x846ca68b
	#x ^= (x >> 15) ^ (x >> 30)                    # step 3 undone
	#x = (x * 0x1d69e2a5) & 0xFFFFFFFF             # step 2 undone — INV of 0x7feb352d
	#x ^= x >> 16                                  # step 1 undone
	#print(str(x) + " testing if inversion successful")
	
	
	###Melissa O'Neil's PCG
	
	#var x : int = 345634576  
	#var state : int = (x * 747796405 + 2891336453) & 4294967295
	#var word : int = ((state >> ((state >> 28) + 4)) ^ state) * 277803737
	#word &= 4294967295
	#x = (word >> 22) ^ word
	#var random : float = x / 4294967296.0
	#print(random)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
