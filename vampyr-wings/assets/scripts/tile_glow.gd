extends TileMapLayer

@onready var mat := material as ShaderMaterial

func reveal_with_echo(duration: float = 2.0):
	if mat == null:
		return

	mat.set_shader_parameter("show_glow", true)
	mat.set_shader_parameter("glow_strength", 1.0)

	var t = create_tween()
	t.tween_property(mat, "shader_parameter/glow_strength", 0.0, duration)
	t.tween_callback(Callable(self, "_hide_glow"))

func _hide_glow():
	if mat:
		mat.set_shader_parameter("show_glow", false)
