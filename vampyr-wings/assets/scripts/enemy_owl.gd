extends CharacterBody2D
@onready var sprite: Sprite2D = $Pivot/Owl
@onready var animation_player1: AnimationPlayer = $AnimationPlayer
@onready var pivot: Node2D = $Pivot

@export var speed := 40.0
@export var move_direction := -1   # start moving left
@export var patrol_time := 5.0     # seconds per direction


#Sprite management
func _ready() -> void:
	add_to_group("enemy")
	
	if sprite == null:
		push_error("Sprite2D not found! Check node path.")
		return


#Shader Material for reveal
	if sprite.material:

		sprite.material = sprite.material.duplicate()
	else:
		var mat = ShaderMaterial.new()
		mat.shader = preload("res://assets/shaders/outline_shader.tres")
		sprite.material = mat

	var mat_ref = sprite.material
	if mat_ref is ShaderMaterial:
		# Assumes your shader has a parameter called "glow_strength"
		# This will initialize it to 0 so enemies don't start highlighted.
		mat_ref.set_shader_parameter("glow_strength", 0.0)

	animation_player1.play("Idle")
	_start_patrol()
			
#Movement Logic
func _physics_process(delta: float) -> void:
	velocity.x = move_direction * speed
	move_and_slide()

	# Flip sprite to face movement direction
	if move_direction != 0:
		pivot.scale.x = -sign(move_direction)
		
func _start_patrol() -> void:
	patrol_cycle()

# left→right loop
func patrol_cycle() -> void:
	await _move_left()
	await _move_right()
	patrol_cycle() # repeat forever


func _move_left() -> void:
	move_direction = -1
	await get_tree().create_timer(patrol_time).timeout

func _move_right() -> void:
	move_direction = 1
	await get_tree().create_timer(patrol_time).timeout
	
#Damage logic
func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Hitbox overlapped with:", body)
	if body.is_in_group("player"):
		print("PLAYER FOUND — APPLY DAMAGE")
		body.take_damage(1)
