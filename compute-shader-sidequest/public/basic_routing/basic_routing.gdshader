shader_type canvas_item;

uniform sampler2D source_texture : filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//COLOR = vec4(0.0, 0.0, 0.0, 0.5); 
	//COLOR = vec4(UV.x, 0., 0.0, 0.5); 
	COLOR = vec4(texture(source_texture, UV).rgb, 0.5);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
