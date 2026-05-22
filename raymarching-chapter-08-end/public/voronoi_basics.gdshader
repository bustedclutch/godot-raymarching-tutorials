shader_type spatial;
render_mode unshaded;

////Built for two points only:
//float nearest_point_distance(vec2 uv, vec2 p1, vec2 p2){
	//float d = distance(uv, p1);
	//d = min(d, distance(uv,p2));
	//return d;
//}

vec2 min_n_mat(vec2 first_dist_n_mat_id, vec2 second_dist_n_mat_id){
	return
	(first_dist_n_mat_id.x < second_dist_n_mat_id.x)
	?
	first_dist_n_mat_id : second_dist_n_mat_id;
}

////Revise this function so that it packs material IDs, and returns a vec2 with
////both a distance as the x component and a material ID as the Y component
////of a vec2.

//float nearest_point_distance(vec2 uv, vec2 p1, vec2 p2, vec2 p3){
	//float d = distance(uv, p1);
	//d = min(d, distance(uv,p2));
	//d = min(d, distance(uv,p3));
	//return d;
//}

vec2 nearest_point_distance(vec2 uv, vec2 p1, vec2 p2, vec2 p3){
	vec2 d = vec2(distance(uv, p1),1.0);
	d = min_n_mat(d, vec2(distance(uv,p2),2.0));
	d = min_n_mat(d, vec2(distance(uv,p3),3.0));
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
	
	//col = vec3(nearest_point_distance(uv,point1,point2,point3));	
	//Clean up the color line to accept a vec2 input and use the X component initially:
	col = vec3(  nearest_point_distance(uv,point1,point2,point3).x  );	
	
	switch (int(nearest_point_distance(uv,point1,point2,point3).y)){
		case 1 : col = col * vec3(1.0,0.0,0.0); break;
		case 2 : col = col * vec3(0.0,1.0,0.0); break;
		case 3 : col = col * vec3(0.0,0.0,1.0); break;
		default : col = col; break;
	}
	
	//Add a match statement to multiply the color by different outcomes depending on the Y component
	
	
	col = clamp(col, 0.0, 1.0);
	col = pow(col, vec3(2.2));
	
	ALBEDO = col; ALPHA = 1.0;
}