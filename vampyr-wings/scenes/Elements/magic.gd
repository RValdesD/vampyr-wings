class_name Magic
extends Hitbox
@export var max_speed: int = 80
@export var accel: int = 200

func _ready():
	# magic lasts 3 seconds
	await get_tree().create_timer(2.0).timeout
	connect("body_entered", Callable(self, "_on_body_entered"))
	queue_free()
	
func _physics_process(delta: float) -> void:
	var velocity = max_speed * transform.x
	position += velocity * delta
