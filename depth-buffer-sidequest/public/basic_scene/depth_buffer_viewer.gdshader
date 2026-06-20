shader_type spatial;
render_mode unshaded, depth_draw_never;

uniform float example_number : hint_range(0.0,1.0) = 0.4;
uniform float example_number2 : hint_range(0.0,1.0);
uniform sampler2D godot_depth_sampler : hint_depth_texture;
uniform float far_distance : hint_range(0.0,100.0) = 30;

float linear_depth(vec2 uv, mat4 inv_proj) {
    float d = texture(godot_depth_sampler, uv).x;
    vec3 ndc = vec3(uv * 2.0 - 1.0, d);
    vec4 view = inv_proj * vec4(ndc, 1.0);
    view.xyz /= view.w;
    return -view.z;
}

void vertex() {
	// Called for every vertex the material is visible on.
}



void fragment() {
    //float depth = texture(godot_depth_sampler, SCREEN_UV).x;
	float depth = texture(godot_depth_sampler, UV).x;
	//depth = linear_depth(UV, INV_PROJECTION_MATRIX) / far_distance;
    ALBEDO = vec3(depth);
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
