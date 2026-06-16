vec3 line (vec2 xy, float local_scale) {
	//float f_of_x = sin(xy.x+TIME/2.);
	float f_of_x = sin(xy.x+TIME/2.);
	float abs_raw_distance = abs( xy.y - f_of_x );
	float illuminated_pixel_test = step(abs_raw_distance, 0.02);
	//Anti-aliasing
	illuminated_pixel_test = 1.0 - smoothstep(0.015, 0.025, abs_raw_distance);
	////A wider band gives puffy or neon, depending on execution
	illuminated_pixel_test = 1.0 - smoothstep(0.005, 0.05, abs_raw_distance);
	vec3 color = vec3(0.2, 0.4, 0.8);
	return vec3(illuminated_pixel_test) * color;
}

vec3 line2 (vec2 xy, float local_scale) {
	//float f_of_x = sin(xy.x+TIME/2.);
	float f_of_x = smoothstep(0.2, 0.8, sin(xy.x+TIME/2.));
	float abs_raw_distance = abs( xy.y - f_of_x );
	float illuminated_pixel_test = step(abs_raw_distance, 0.02);
	//Anti-aliasing
	illuminated_pixel_test = 1.0 - smoothstep(0.015, 0.025, abs_raw_distance);
	////A wider band gives puffy or neon, depending on execution
	illuminated_pixel_test = 1.0 - smoothstep(0.005, 0.05, abs_raw_distance);
	vec3 color = vec3(0.8, 0.4, 0.8);
	return vec3(illuminated_pixel_test) * color;
}