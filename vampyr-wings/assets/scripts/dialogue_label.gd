extends RichTextEffect
class_name WaveEffect

@export var amplitude: float = 5.0
@export var frequency: float = 8.0
@export var speed: float = 4.0

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	# char_fx.absolute_index = index of the character in the text
	char_fx.offset.y = sin((char_fx.absolute_index + Time.get_ticks_msec() / 1000.0 * speed) * frequency) * amplitude
	return true
