shader_type spatial;
render_mode unshaded;



void fragment() {
	//Add point 1, an arbitrary point in the bottom rightish.
	vec2 point1 = vec2(0.25, -0.5);
	
	vec2 uv = UV;
	uv = vec2(uv.x,(1.0-uv.y));
	uv = uv*2.0 - 1.0 ;
	
	vec3 col = vec3(length(uv));
	
	col = vec3(distance(uv,point1));
	
	
	
	
	col = clamp(col, 0.0, 1.0);
	col = pow(col, vec3(2.2));
	
	ALBEDO = col; ALPHA = 1.0;
}