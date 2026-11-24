extends TileMapLayer
@onready var mat := material as ShaderMaterial

func reveal_with_echo():
	if mat == null:
		return

	mat.set_shader_parameter("echo_strength", 1.0)

	var t := create_tween()
	t.tween_property(mat, "shader_parameter/echo_strength", 0.0, 1.0).set_delay(1.0)
