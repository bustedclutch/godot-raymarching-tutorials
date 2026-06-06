shader_type spatial;
render_mode unshaded;

////Built for two points only:
//float nearest_point_distance(vec2 uv, vec2 p1, vec2 p2){
	//float d = distance(uv, p1);
	//d = min(d, distance(uv,p2));
	//return d;
//}


//Now to accomodate three points:
float nearest_point_distance(vec2 uv, vec2 p1, vec2 p2, vec2 p3){
	float d = distance(uv, p1);
	d = min(d, distance(uv,p2));
	d = min(d, distance(uv,p3));
	return d;
}

void fragment() {
	//Add point 1, an arbitrary point in the bottom rightish.
	vec2 point1 = vec2(0.25, -0.5);
	vec2 point2 = vec2(-0.5,0.1);
	vec2 point3 = vec2(0.8,0.6);
	
	vec2 uv = UV;
	uv = vec2(uv.x,(1.0-uv.y));
	uv = uv*2.0 - 1.0 ;
	
	vec3 col = vec3(length(uv));
	
	col = vec3(distance(uv,point1));
	
	////When using the function that only takes two points:
	//col = vec3(nearest_point_distance(uv,point1,point2));	
	
	col = vec3(nearest_point_distance(uv,point1,point2,point3));	
	
	
	
	col = clamp(col, 0.0, 1.0);
	col = pow(col, vec3(2.2));
	
	ALBEDO = col; ALPHA = 1.0;
}