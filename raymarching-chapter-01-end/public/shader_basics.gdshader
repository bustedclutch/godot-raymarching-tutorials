shader_type spatial;
render_mode unshaded;

void fragment() {
	vec2 uv = UV;

	uv = vec2(uv.x,(1.0-uv.y));
	
	uv = uv*2.0 - 1.0 ;

	vec3 col = vec3(uv.x, uv.y, 0.0);
	
	//col = vec3(length(uv));
	col = clamp(col, 0.0, 1.0);
	col = pow(col, vec3(2.2));
	
	
	
	ALBEDO = col; ALPHA = 1.0;
}
