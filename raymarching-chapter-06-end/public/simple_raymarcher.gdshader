/*I've copied and pasted far too much of this Frankenstenian
raymarcher to take credit for any of it, but the comments are
obviously my own for the purpose of the GGDA work-a-long and
github/youtube uploads. Many thanks to GGDA and Andrew
Greenberg for hosting me.

You can find me on steam and github as BustedClutch or via
email at alexrowland at symbol gmail.com and feel free to
reach out if you found this heavily-commented explanation at
all helpful. I like raymarching and shading, don't know
very much about either, but I hope you'll enjoy falling down
the rabbit hole together. Or at least it'll give you the
confidence to try shaders/Godot/game making/etc. even if you
too don't know what you're doing. Have fun!
*/

/*
The shader type, "spatial", you'll see everywhere with 3d shaders.
The unshaded render mode, however, is more unusual, and prevents
Godot from taking over the lighting. Besides raymarching, you
might encounter unshaded shaders in toon shading, which is another
shader type where you might handle the physics of the lighting
yourself. This allows the quad you're shading to be visible even
if there are no lights in the scene.
*/

shader_type spatial;
render_mode unshaded;

/*Although in the workshop we'll be experimenting with making
these constants dynamic, note that there's an exception:
MAX MARCH STEPS is fixed at compile time for the shader,
due to how the GPU operates. It needs to know in advance
the number of loops in the for loop. For that reason,
the MAX MARCH STEPS is often declared as a constant
to prevent errors.*/
const int MAX_MARCH_STEPS = 64;
const float MAX_MARCH_DISTANCE = 20.0;
const float SURFACE_EPSILON = 0.001;

/*I continued to declare everything as a constant,
just so that I wouldn't run into the problem of the inspector
panel on the right hijacking my variables. But try
replacing "const" with "uniform" and notice how it 
shows up in the inspector panel. */
const vec3 light_direction = vec3(1.0, 1.0, 1.0);
const float camera_focal_length = 1.3;
const vec3 camera_position = vec3(0.0, 0.0, 3.0);


/*For my own sanity, my function is mathematically
identical to the Inigo Quilez reference list of 3d SDF functions,
but is much wordier. I've used the phrase "get distance
to sphere" because it's easier for me to read than "sdSphere."
I've also spelled out "point_minus_origin" to remind me later
that my input needs to be expressed as the current location
of the point, minus the vector that provides the object location.*/
float get_distance_to_sphere(vec3 point_minus_origin, float r) {
	return length(point_minus_origin) - r;
}

/*And here's a box. Try using the Inigo Quilez reference to
add functions for other shapes! Try renaming the parameters
for the shapes to something you find understandable.
*/
float get_distance_to_box( vec3 point_minus_origin, vec3 box_dimensions )
{
  vec3 q = abs(point_minus_origin) - box_dimensions;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

/*We can think of this as the "master function" that draws
together all of the individual functions to identify locations
and dimensions for individual shapes, as well as any boolean
math to add or blend or subtract objects. A "min" function,
as you can see, just adds more objects without any blending.
Try toying with the location of objects, and then adding objects.
This is also a spot where you can shove in blending functions.*/
float get_scene_distance(vec3 point) {
	float d = get_distance_to_sphere(point-vec3(0.0,0.0,0.0), 0.5);
	d = min(d, (get_distance_to_box(point-vec3(0.0,1.0,1.0),vec3(0.5))));
	d = min(d, get_distance_to_sphere(point-vec3(2.0,0.0,-3.0), 0.5));
	return d;
}

/*This is the function that calculates the surface normal for an object
at any given place. Warning: This isn't the best function to use
for your framerate, because it samples six times. But it's much
easier to understand, and works in two dimensions if you're
calculating it by hand, so I chose this instead for learning purposes.
When you're ready
for the more efficient and more difficult to understand function,
look up the function that samples four times with a tetrahedron.*/
vec3 get_surface_normal(vec3 point) {
	float offset = 0.001;
	return normalize(vec3(
		get_scene_distance(point + vec3(offset, 0.0, 0.0)) - get_scene_distance(point - vec3(offset, 0.0, 0.0)),
		get_scene_distance(point + vec3(0.0, offset, 0.0)) - get_scene_distance(point - vec3(0.0, offset, 0.0)),
		get_scene_distance(point + vec3(0.0, 0.0, offset)) - get_scene_distance(point - vec3(0.0, 0.0, offset))
	));
}

/*If you're unfamiliar with the idea of visualizing UV's, or what
UVs are, check out Freya Holmer's amazing three part video series;
she discusses UVs fairly early. Although she's working in Unity,
fret not--Godot uses "ALBEDO" to set color as a vector 3, and ALPHA
as its own separate float for transparency. Unity uses a vector 4,
or vec4, where the fourth channel is transparency, and the first
three floats of the vec4 make up the RGB components. Tomato Tomahto, 
as it were.*/
void fragment() {
	//ALBEDO = vec3(UV.x, UV.y, 0.0); //Testing UV's on the quad
	// Convert UV to normalized device coordinates (-1 to +1)
	vec2 screen_uv = UV * 2.0 - vec2(1.0);
	screen_uv = screen_uv*vec2(1.0,-1.0);
	/*The below line isn't exactly what you'd use to correct for aspect
	ratio, but I included the line here since you'd generally shove it
	here and it would look something like this.
	When you stretch the quad to no longer being a rectangle,
	you must account for that somehow to avoid a squished look.*/
	//screen_uv.x *= VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;


	vec3 ray_origin = camera_position;
	
	/*The below line does a hilarious amount of lifting, so
	draw this one in Blender or on paper until it makes sense.
	Although you can skip a lot of the 3D geometry elsewhere,
	I don't think I'd pass this.
	"Camera focal length" here is an arbitrary, unitless expression,
	which might feel weird if you're used to setting the FOV in Godot
	using degrees or setting the focal length in Blender with
	millimeters as you would with a real life camera.
	In case you need the formula later or I get hit by a bus,
	if you need the formula that defines the relationship between
	"f" focal length as used here, and "d" as in the field of view
	as expressed in degrees (not radians!), the formula is: 
	f = 1/tan(d/2)
	You can derive this formula if you sketch out a triangle in
	3D space where the camera is one point, the point on the quad
	at UV -1,0 is another point, and the 90 degree angle of the triangle
	is at 0,0 on the quad in normalized device coordinates.
	*/
	vec3 ray_direction = normalize(vec3(screen_uv, -camera_focal_length));

	float distance_to_surface = 0.0;
	float total_distance = 0.0;
	
	/*This is the basic raymarching loop. It goes for 20 steps,
	or whatever you set MAX_MARCH_STEPS to.
	To find the current position, it takes the starting location
	for the ray, and adds the normalized direction multipled by
	the total distance, which keeps getting bumped up as the for
	loop progresses. Normalizing the ray direction gives it
	a length of 1 so that we can use multiplication to identify
	the current location in 3D space.
	If the distance to the nearest object, as understood by the
	big scene distance function above, ever goes below the epsilon,
	it breaks the foor loop, and is later considered as a "hit". 
	Alternatively, if total distance exceeds the max distance, the
	for loop breaks and is handled as a "miss" in the 
	logic further below.*/
	for (int step = 0; step < MAX_MARCH_STEPS; step++) {
		vec3 current_position = ray_origin + ray_direction * total_distance;
		distance_to_surface = get_scene_distance(current_position);
		if (distance_to_surface < SURFACE_EPSILON || total_distance > MAX_MARCH_DISTANCE) {
			break;
		}
		total_distance += distance_to_surface;
	}


/*This is the "hit" logic, triggered if the distance to a surface
is below the epsilon. It finds the normal, which is then used for
very simple Lambertian shading. I don't describe Lambertian shade here,
as there's lots of simple Lambertian shading tutorials online.
As for why it's clamped with a min of 0 and max of 1, Godot can and
absolutely will do weird things if your colors drop below zero,
things that you won't see if you're coming from other places like
Shadertoy.*/
	if (distance_to_surface < SURFACE_EPSILON) {	
		
		vec3 surface_position = ray_origin + ray_direction * total_distance;
		vec3 surface_normal = get_surface_normal(surface_position);
		float diffuse = clamp(dot(normalize(surface_normal), normalize(light_direction)), 0.0, 1.0);
		ALBEDO = vec3(diffuse); // Basic Lambert shading
		ALPHA = 1.0;
		
/*This is the "miss" logic, which we've defined for this purpose as
literally everything besides a hit. This logic is simple (if it didn't
hit, it's gotta be a miss!) but one can imagine situations where this
view of the raymarched world is agressive. What would happen if 
a ray reached its max number of steps while getting real close
to an object? Should that be called a miss? As the artist, you decide.
Note that I've set ALPHA to zero to make the misses transparent,
but try commenting out the alpha line, or recoloring the background.*/
	} else {
		ALBEDO = vec3(0.0); // Missed the scene — render background
		ALPHA = 0.0;
	}
	
}