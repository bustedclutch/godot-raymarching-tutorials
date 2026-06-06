shader_type spatial;
render_mode unshaded;

float line (float x, float y) {
	//float f_of_x = 2.0 * x;
	float f_of_x = sin(x);
	float raw_distance = y - f_of_x;
	return abs(raw_distance);
}

void fragment() {
	vec2 uv = UV;
	uv = uv * 2.0 - 1.0;
	uv.y = -uv.y;

	vec3 col = vec3(0.);
	
	float illuminated_pixel_test = step(line(uv.x, uv.y), 0.02);
	col = col + illuminated_pixel_test;
	
	ALBEDO = col; ALPHA = 1.0;
}
