shader_type spatial;
render_mode unshaded;

const int MAX_MARCH_STEPS = 64;
const float MAX_MARCH_DISTANCE = 20.0;
const float SURFACE_EPSILON = 0.001;

//Change const to uniform if you wanna use the inspector
const vec3 light_direction = vec3(1.0, 1.0, 1.0);
const float camera_focal_length = 1.3032253;
const vec3 camera_position = vec3(0.0, 0.0, 3.0);

//Ch2. Start pullin in uniforms from the script.
uniform vec3 camera_pos;
//Be aware that camera basis is a matrix when declaring and using later
uniform mat3 camera_basis; 
uniform vec3 marble1_pos;
uniform vec3 marble2_pos;
uniform vec3 marble3_pos;
uniform vec3 game_floor_pos;
uniform vec3 game_floor_size;

//Chapter 5: Add the min_and_mat function to allow the get_scene_distance function to track
//the material ID of the object with the smallest distance as a vec2
vec2 min_n_mat(vec2 first_object_d_and_m, vec2 second_object_d_and_m){
	return
	(first_object_d_and_m.x < second_object_d_and_m.x)
	?
	first_object_d_and_m : second_object_d_and_m;
}


float get_distance_to_sphere(vec3 point_minus_origin, float r) {
	return length(point_minus_origin) - r;
}

float get_distance_to_box( vec3 point_minus_origin, vec3 box_dimensions )
{
  vec3 q = abs(point_minus_origin) - box_dimensions * 0.5;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

////Chapter 5: Remodel the get_scene_distance function so that it now returns a vec2, uses the
//// min_n_mat function, and passing in a Y component for each object as a material ID.

//float get_scene_distance(vec3 point) {
	//float d = get_distance_to_sphere(point-marble1_pos, 0.5);
	//d = min(d, get_distance_to_sphere(point-marble2_pos, 0.5));
	//d = min(d, get_distance_to_sphere(point-marble3_pos, 0.5));
	//d = min(d, get_distance_to_box(point-game_floor_pos,game_floor_size));
	//return d;
//}

vec2 get_scene_distance(vec3 point) {
	vec2 d = vec2(get_distance_to_sphere(point-marble1_pos, 0.5), 1);
	d = min_n_mat(d, vec2(get_distance_to_sphere(point-marble2_pos, 0.5), 2));
	d = min_n_mat(d, vec2(get_distance_to_sphere(point-marble3_pos, 0.5), 3));
	d = min_n_mat(d, vec2(get_distance_to_box(point-game_floor_pos,game_floor_size), 50));
	return d;
}

////Chapter 5: Update the normal function to consider only the X compnent. The normal function,
//// for now, doesn't need access to the material ID.

//vec3 get_surface_normal(vec3 point) {
	//float offset = 0.001;
	//return normalize(vec3(
		//get_scene_distance(point + vec3(offset, 0.0, 0.0)) - get_scene_distance(point - vec3(offset, 0.0, 0.0)),
		//get_scene_distance(point + vec3(0.0, offset, 0.0)) - get_scene_distance(point - vec3(0.0, offset, 0.0)),
		//get_scene_distance(point + vec3(0.0, 0.0, offset)) - get_scene_distance(point - vec3(0.0, 0.0, offset))
	//));
//}

vec3 get_surface_normal(vec3 point) {
	float offset = 0.001;
	return normalize(vec3(
		get_scene_distance(point + vec3(offset, 0.0, 0.0)).x - get_scene_distance(point - vec3(offset, 0.0, 0.0)).x,
		get_scene_distance(point + vec3(0.0, offset, 0.0)).x - get_scene_distance(point - vec3(0.0, offset, 0.0)).x,
		get_scene_distance(point + vec3(0.0, 0.0, offset)).x - get_scene_distance(point - vec3(0.0, 0.0, offset)).x
	));
}

void fragment() {
	//ALBEDO = vec3(UV.x, UV.y, 0.0); //Testing UV's on the quad
	// Convert UV to normalized device coordinates (-1 to +1)
	vec2 screen_uv = UV * 2.0 - vec2(1.0);
	screen_uv = screen_uv*vec2(1.0,-1.0);
	////Commenting out the viewport alterations for now.
	//screen_uv.x *= VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;

////The original ray origin and camera position, followed
////by the revised to account for the camera's updated
////basis and position.
	//vec3 ray_origin = camera_position;
	//vec3 ray_direction = normalize(vec3(screen_uv, -camera_focal_length));
	//
	vec3 ray_origin = camera_pos;
	vec3 ray_direction = normalize(camera_basis*(vec3(screen_uv, -camera_focal_length)));
	

////Chapter 5: Declare distance_to_surface as a vec2 instead.
	//float distance_to_surface = 0.0;
	vec2 distance_to_surface = vec2(0.0, 0.0);
	
	float total_distance = 0.0;
	for (int step = 0; step < MAX_MARCH_STEPS; step++) {
		vec3 current_position = ray_origin + ray_direction * total_distance;
		distance_to_surface = get_scene_distance(current_position);
		////Chapter 5: Pull X component from distance_to_surface now that it's a vec2, as the 
		////material ID in the Y component is irrelevant for evaluating whether the ray hit.
		//if (distance_to_surface < SURFACE_EPSILON || total_distance > MAX_MARCH_DISTANCE) {
		if (distance_to_surface.x < SURFACE_EPSILON || total_distance > MAX_MARCH_DISTANCE) {
			break;
		}
		////Chapter 5: Tweak the total-distance calculator to only consider the distance traveled
		////each step, which is the X component, not the material component stored in Y.
		//total_distance += distance_to_surface;
		total_distance += distance_to_surface.x;
	}

////Chapter 5: Update this branch of the hit logic to consider the X component, as the hit logic
////that asks if a hit took place is concerned with distance and not material ID:
	//if (distance_to_surface < SURFACE_EPSILON) {	
	if (distance_to_surface.x < SURFACE_EPSILON) {	
		
		vec3 surface_position = ray_origin + ray_direction * total_distance;
		vec3 surface_normal = get_surface_normal(surface_position);
		float diffuse = clamp(dot(normalize(surface_normal), normalize(light_direction)), 0.0, 1.0);
		ALBEDO = vec3(diffuse); // Basic Lambert shading
		ALPHA = 1.0;
		
		
	} else {
		ALBEDO = vec3(0.0); // Missed the scene — render background
		ALPHA = 0.0;
	}
	
}