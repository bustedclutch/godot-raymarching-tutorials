shader_type spatial;
render_mode unshaded;

struct dd {
	float first_closest_distance;
	float second_closest_distance;
};

dd double_distance_keeper(float fresh_distance, dd current_pair){
	if (fresh_distance > current_pair.first_closest_distance && 
	fresh_distance > current_pair.second_closest_distance){
		return current_pair;	
		}
	else if (fresh_distance < current_pair.second_closest_distance &&
	fresh_distance > current_pair.first_closest_distance){
		return dd(current_pair.first_closest_distance, fresh_distance);
	}
	else {
		return dd(fresh_distance, current_pair.first_closest_distance);
	}
}

dd nearest_point_distance(vec2 uv, vec2 p1, vec2 p2, vec2 p3){
	dd tracked_pair = dd(100.0,100.0);
	tracked_pair = double_distance_keeper( distance(uv, p1), tracked_pair);
	tracked_pair = double_distance_keeper( distance(uv,p2), tracked_pair);
	tracked_pair = double_distance_keeper( distance(uv,p3), tracked_pair);
	return tracked_pair;
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

	dd tracked_distances = nearest_point_distance(uv,point1,point2,point3);
	col = vec3(tracked_distances.first_closest_distance) ;
	float standard_voronoi = tracked_distances.second_closest_distance - tracked_distances.first_closest_distance;
	col = vec3(standard_voronoi) ;
	float stepped_voronoi = step(0.2, standard_voronoi);
	col = vec3(stepped_voronoi);
	
	//col = vec3(nearest_point_distance(uv,point1,point2,point3));	
	
	col = clamp(col, 0.0, 1.0);
	col = pow(col, vec3(2.2));
	
	ALBEDO = col; ALPHA = 1.0;
}