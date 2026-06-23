shader_type spatial;
render_mode unshaded;

uniform float scale = 3.0;
const float MAX_DISTANCE = 10.0;

void winners_podium(float input_distance, inout float distance_array[5]){
	if (input_distance < distance_array[0]){
		distance_array[4]=distance_array[3];
		distance_array[3]=distance_array[2];
		distance_array[2]=distance_array[1];
		distance_array[1]=distance_array[0];
		distance_array[0]=input_distance;}
	else if (input_distance < distance_array[1]){
		distance_array[4]=distance_array[3];
		distance_array[3]=distance_array[2];
		distance_array[2]=distance_array[1];
		distance_array[1]=input_distance;}
	else if (input_distance < distance_array[2]){
		distance_array[4]=distance_array[3];
		distance_array[3]=distance_array[2];
		distance_array[2]=input_distance;}
	else if (input_distance < distance_array[3]){
		distance_array[4]=distance_array[3];
		distance_array[3]=input_distance;}
	else if (input_distance < distance_array[4]){
		distance_array[4]=input_distance;}
	}

	vec2 local_space_uv_coordinate(vec2 xy){
		return vec2(fract(xy.x), fract(xy.y));
	}

uint grid_id_x(vec2 xy){
	float x_vec = xy.x;
	float x_floor = floor(x_vec);
	return uint(int(x_floor));
}
uint grid_id_y(vec2 xy){
	float y_vec = xy.y;
	float y_floor = floor(y_vec);
	return uint(int(y_floor));
}
	
vec3 random_point_light(vec2 xy, float local_scale, uint hashed_uint, float x_grid_id, float y_grid_id){
	uint combined_hash_uint = hashed_uint;
	uint x_uint = combined_hash_uint >> 16u;
	uint y_uint = combined_hash_uint &0xFFFFu;
	float x_normalized_hash = float(x_uint) / float(65536);
	float y_normalized_hash = float(y_uint) / float(65536);
	vec2 coordinate_pos_in_global_space = vec2(x_grid_id+x_normalized_hash,y_grid_id+y_normalized_hash);
	vec2 scaled_current_position = xy; // * local_scale;
	float current_distance_to_point = abs(distance(coordinate_pos_in_global_space, scaled_current_position));
	vec3 light = vec3(step(current_distance_to_point, 0.08));
	return light;
}

uint combined_x_and_y_uint(uint x, uint y){
	x *= 0x27d4eb2du ; //multiply by a big random odd constant
	y *= 0x165667b1u ; //multiply by some other big random odd constant
	x &= 0xFFFFFFFFu ; //AND mask to prevent 64 bit CPU from diverging from 32 bit GPU
	y &= 0xFFFFFFFFu ; //AND mask to prevent 64 bit CPU from diverging from 32 bit GPU
	return x ^ y ; //return x combined with y using XOR
}

uint wellons_integer_hashed(uint input){
	uint x = input;
	x ^= x >> 16u;
	x *= 0x7feb352du;
	x &= 0xFFFFFFFFu;
	x ^= x >> 15u;
	x *= 0x846ca68bu;
	x &= 0xFFFFFFFFu;
	x ^= x >> 16u;
	uint hashed_integer_result = x;
	return hashed_integer_result;
}

vec3 grid_line (vec2 xy, float local_scale) {
	//Take fractional parts of X and Y
	float x_fract = fract(xy.x);
	float y_fract = fract(xy.y);
	//Test each part to see if the fractional part is close to zero or almost one.
	float grid_test = step(x_fract, 0.02) + step(0.98, x_fract) + step(y_fract, 0.02) + step(0.98, y_fract) ;
	float lit = min(1.0, grid_test);
	vec3 grid_light = lit * vec3(0.0, 0.5, 0.2);
	return grid_light;
}

vec2 uv_math(vec2 xy, float local_scale){
	vec2 uv = xy;
	uv = uv * 2.0 - 1.0;
	uv = uv * vec2(1.0, -1.0);
	uv = uv * local_scale;
	return uv;
}

void fragment() {
	vec2 uv = uv_math(UV, scale);
	vec3 col = vec3(0.);
	uint uv_grid_id_x = grid_id_x(uv);
	uint uv_grid_id_y = grid_id_y(uv);
	float worley_distances[5] = float[5](MAX_DISTANCE,MAX_DISTANCE,MAX_DISTANCE,MAX_DISTANCE,MAX_DISTANCE);
	
	
	
	col = col + grid_line(uv, scale);
	ALBEDO = col; ALPHA = 1.0;
}
