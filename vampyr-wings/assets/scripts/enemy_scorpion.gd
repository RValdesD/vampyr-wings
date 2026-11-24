extends CharacterBody2D

@onready var sprite: Sprite2D = $Scorpion1
@onready var animation_player1: AnimationPlayer = $AnimationPlayer

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

#Damage logic
func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Hitbox overlapped with:", body)
	if body.is_in_group("player"):
		print("PLAYER FOUND — APPLY DAMAGE")
		body.take_damage(1)
