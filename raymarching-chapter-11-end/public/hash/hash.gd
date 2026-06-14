extends Node3D

##A simple vec2 to integer converter for hashing purposes
func combine_x_and_y_to_uint(x: int, y: int) -> int:
	x *= 0x27d4eb2d #multiply by a big random odd constant
	y *= 0x165667b1 #multiply by some other big random odd constant
	x &= 0xFFFFFFFF #AND mask to prevent 64 bit CPU from diverging from 32 bit GPU
	y &= 0xFFFFFFFF #AND mask to prevent 64 bit CPU from diverging from 32 bit GPU
	return x ^ y #return x combined with y using XOR

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
	##The Wellons hash, step by step.
	
	var x : int = 65536
	print(str(x) + " is the input integer.")
	print(to_binary(x) + " is the initial input in binary.")
	print(to_binary(x>>16) + " is X bitshifted.")
	x ^= x >> 16
	print(to_binary(x) + " the XOR result of the input and bitshifted input")
	x *= 0x7feb352d # 	2146500909 in hex form,
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
	var random : float = x / 4294967296.0
	print("Dividing the resulting number between the total number of all possible values to get a result between 0 and 1")
	print("Random number between 0 and 1 is: " + str(random))


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
