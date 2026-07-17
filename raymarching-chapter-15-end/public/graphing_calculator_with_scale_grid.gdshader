

shader_type spatial;
render_mode unshaded;

//Adding scale as a uniform, exposing it to the Inspector
uniform float scale = 3.0;

float line (float x, float y) {
	//float f_of_x = 2.0 * x;
	float f_of_x = sin(x);
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
//requires an operation on its fractional part. Fractional parts under 0.02 
//units or greater than 0.98 units would trigger 1.0. 

//Find the x fractional portion
	float x_fract = fract(uv.x);
//Test to see if a part is less that 0.02 or greater than 0.98
	float x_tests = step(x_fract, 0.02) + step(0.98, x_fract);
//If so, light it up! Make sure it can't go over 1 using a min.
	float x_lit = min(1.0, x_tests);
//Color the light.
	vec3 x_colored_light = x_lit * vec3(1.0, 0.5, 0.0);
	col = col + x_colored_light;
	
	ALBEDO = col; ALPHA = 1.0;
}
