#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba8, set = 0, binding = 0) uniform restrict writeonly image2D output_image;

void main() {
    ivec2 coord = ivec2(gl_GlobalInvocationID.xy);
    ivec2 size = imageSize(output_image);
    if (coord.x >= size.x || coord.y >= size.y) {
        return;
    }
    vec2 uv = vec2(coord) / vec2(size - 1);
    imageStore(output_image, coord, vec4(uv.x, uv.y, 0.0, 1.0));
}