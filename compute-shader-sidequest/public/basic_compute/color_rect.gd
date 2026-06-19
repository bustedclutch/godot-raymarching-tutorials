extends ColorRect

const IMAGE_SIZE := 16

func _ready() -> void:
	var rd := RenderingServer.create_local_rendering_device()

	var shader_file := load("res://public/basic_compute/basic_compute_shader.glsl") as RDShaderFile
	var shader_spirv := shader_file.get_spirv()
	var shader := rd.shader_create_from_spirv(shader_spirv)
	var pipeline := rd.compute_pipeline_create(shader)

	var fmt := RDTextureFormat.new()
	fmt.width = IMAGE_SIZE
	fmt.height = IMAGE_SIZE
	fmt.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	fmt.usage_bits = (
		RenderingDevice.TEXTURE_USAGE_STORAGE_BIT
		| RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	)
	var output_texture_rd := rd.texture_create(fmt, RDTextureView.new(), [])

	var uniform := RDUniform.new()
	uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	uniform.binding = 0
	uniform.add_id(output_texture_rd)
	var uniform_set := rd.uniform_set_create([uniform], shader, 0)

	var compute_list := rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	var groups := IMAGE_SIZE / 8
	rd.compute_list_dispatch(compute_list, groups, groups, 1)
	rd.compute_list_end()

	rd.submit()
	rd.sync()

	var bytes := rd.texture_get_data(output_texture_rd, 0)
	print("compute returned %d bytes" % bytes.size())

	var image := Image.create_from_data(IMAGE_SIZE, IMAGE_SIZE, false, Image.FORMAT_RGBA8, bytes)
	var display_texture := ImageTexture.create_from_image(image)
	material.set_shader_parameter("source_texture", display_texture)
