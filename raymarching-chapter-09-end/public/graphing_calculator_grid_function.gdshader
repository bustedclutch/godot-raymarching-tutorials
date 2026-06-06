

shader_type spatial;
render_mode unshaded;

//Adding scale as a uniform, exposing it to the Inspector
uniform float scale = 3.0;

vec3 grid_line (float uv_x, float uv_y) {
	//Take fractional parts of X and Y
	float x_fract = fract(uv_x);
	float y_fract = fract(uv_y);
	//Test each part to see if the fractional part is close to zero or almost one.
	float grid_test = step(x_fract, 0.02) + step(0.98, x_fract) + step(y_fract, 0.02) + step(0.98, y_fract) ;
	float lit = min(1.0, grid_test);
	vec3 grid_light = lit * vec3(0.0, 0.5, 0.2);
	return grid_light;
}

float line (float x, float y) {
	//float f_of_x = 2.0 * x;
	float f_of_x = sin(x+TIME/2.);
	float raw_distance = y - f_of_x;
	return abs(raw_distance);
}

void fragment() {
	vec2 uv = UV;
	uv = uv * 2.0 - 1.0;
	uv = uv * vec2(1.0, -1.0);
	
	//The single line needed to scale the image.
	//Or in the future, noise. Remember that
	//our current view isn't a unit square but 
	//runs -1 to 1, so a scale of 3 here would be a
	//scale of 6 if you were matching this to a 
	//unit square.
	uv = uv * scale;

	vec3 col = vec3(0.);
	
	float illuminated_pixel_test = step(line(uv.x, uv.y), 0.02);
	col = col + illuminated_pixel_test;
	
//Creating a grid; a grid line at the integers would mean evaluating whether
//any given point, uv.x, or uv.y, is within 0.02 units of an integer. Which
//requires an operation on its fractional part. Fractional p_existsarts under 0.02 
//units or greater than 0.98 units would trigger 1.0. 

	col = col + grid_line(uv.x, uv.y);
	
	ALBEDO = col; ALPHA = 1.0;
}
