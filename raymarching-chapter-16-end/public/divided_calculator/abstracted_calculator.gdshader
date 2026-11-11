

shader_type spatial;
render_mode unshaded;

//Adding scale as a uniform, exposing it to the Inspector
uniform float scale = 3.0;

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

vec3 line (vec2 xy, float local_scale) {
	float f_of_x = sin(xy.x);
	float abs_raw_distance = abs( xy.y - f_of_x );
	float illuminated_pixel_test = step(abs_raw_distance, 0.02);
	return vec3(illuminated_pixel_test);
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
	col = col + line(uv, scale);
	col = col + grid_line(uv, scale);
	ALBEDO = col; ALPHA = 1.0;
}
