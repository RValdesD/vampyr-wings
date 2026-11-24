class_name Player
extends CharacterBody2D

var has_magic_powerup: bool = false

#Magic cooldown
@export var magic_cooldown := 0.5     
var magic_ready: bool = true

#Death after freefall
var below_stage_timer: Timer
@export var death_marker: Marker2D

#Movement Variables
@export var run_multiplier: float = 2.0
@export var max_speed: int = 80
@export var jump_speed: int = 200
@export var gravity: int = 250
@export var accel: int = 200
@export var glide_gravity_scale: float = 0.2
@onready var pivot: Node2D = $Pivot
@export var magic_scene: PackedScene


#Echo variables
@export var echo_rays: int = 24
@export var echo_range: float = 800.0
@export var echo_spread_degrees: float = 60.0
@onready var raycast: RayCast2D = $RayCast2D

#World setup variables
@onready var light: PointLight2D = $PointLight2D
@onready var sprite_2d: Sprite2D = $Pivot/Sprite2D

#Animation variables
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/movement/playback"]
@onready var sfx_player: AudioStreamPlayer = $SFX

#Magic
@onready var magic_spawn: Marker2D = $MagicSpawn

#Platform illumination
signal echo_fired


#Life setup
@export var max_life := 6
var life := 6
var invincible: bool = false
const INVINCIBILITY_TIME := 0.7
var ui: LifeUI

func _ready() -> void:
	add_to_group("player")
	ui = get_tree().get_first_node_in_group("life_ui")
	
#PowerUp
	if PowerupUi.magic_unlocked:
		has_magic_powerup = true
	else:
		has_magic_powerup = false
		
# Timer setup for death on DeathZone
	below_stage_timer = Timer.new()
	below_stage_timer.wait_time = 1.0
	below_stage_timer.one_shot = true
	below_stage_timer.connect("timeout", Callable(self, "_on_below_stage_timeout"))
	add_child(below_stage_timer)

func die() -> void:
	get_tree().change_scene_to_file("res://scenes/Interface/Lose_Menu.tscn")

func _physics_process(delta: float) -> void:
	
#Gravity + Jumps
	if not is_on_floor():
		var current_gravity: float = gravity
		if Input.is_action_pressed("jump") and velocity.y > 0:
			current_gravity *= glide_gravity_scale
			playback.travel("glide")
		velocity.y += current_gravity * delta

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed

#H-movement
	var move_input: float = Input.get_axis("mv_left", "mv_right")
	var is_running: bool = Input.is_action_pressed("run")
	var current_max_speed: float = max_speed * (run_multiplier if is_running else 1.0)

	velocity.x = move_toward(velocity.x, move_input * current_max_speed, accel * delta)
	move_and_slide()

#Direction of character
	if move_input != 0.0:
		pivot.scale.x = sign(move_input)

#Animations 
	if is_on_floor():
		if move_input != 0.0 or abs(velocity.x) > 5.0:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if velocity.y < 0.0:
			playback.travel("jump")
		elif velocity.y > 50.0:
			playback.travel("fall")

#Echo animation
	if Input.is_action_just_pressed("atk"):
		sfx_player.play()
		trigger_echo()
		animation_tree["parameters/echo/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		
	#Magic
	if Input.is_action_just_pressed("magic") and has_magic_powerup:
		try_spawn_magic()
		
	if playback.get_current_node() == "echo" and not animation_player.is_playing():
	# Force idle when echo animation ends
		playback.travel("idle")
		animation_player.speed_scale = 1.0
		
	# Check if player is below the marker
	if global_position.y > death_marker.global_position.y:
		if below_stage_timer.is_stopped():
			below_stage_timer.start()
	else:
	# Player back above marker, stop the timer
		if not below_stage_timer.is_stopped():
			below_stage_timer.stop()
			
func _on_below_stage_timeout() -> void:
	life = 0
	die()
	
func try_spawn_magic():
	if not has_magic_powerup:
		return
	
	if not magic_ready:
		return

	# Magic cast allowed
	spawn_magic()
	start_magic_cooldown()
	
#1. Echo System Setup 
func trigger_echo() -> void:
	var origin: Vector2 = global_position
	var facing: float = pivot.scale.x
	var half_angle: float = deg_to_rad(echo_spread_degrees / 2.0)
	var space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	emit_signal("echo_fired")
	
#1.1 RayCasting
	for i in range(echo_rays):
		var t: float = float(i) / float(echo_rays - 1)
		var angle: float = lerp(-half_angle, half_angle, t)
		var direction: Vector2 = Vector2(facing, 0).rotated(angle)
		var to: Vector2 = origin + direction * echo_range

		var params: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(origin, to)
		params.exclude = [self]

#1.2 Enemy reveal logic
		var result: Dictionary = space.intersect_ray(params)
		if result.size() > 0:
			var collider: Object = result.get("collider", null)
			if collider != null:
				var enemy_node: Node = _get_enemy_node(collider)
				if enemy_node != null:
					reveal_enemy(enemy_node)
					

#1.3 Platform reveal logic





func _get_enemy_node(collider: Object) -> Node:
	if collider is Node and collider.is_in_group("enemy"):
		return collider

	if collider is Node:
		var p: Node = collider
		while p != null:
			if p.is_in_group("enemy"):
				return p
			p = p.get_parent()
	return null


func reveal_enemy(enemy: Node) -> void:
	var sprite_names = ["Scorpion1", "Owl"]
	var sprite: Sprite2D = null

	for name in sprite_names:
		sprite = enemy.find_child(name, true, false) as Sprite2D
		if sprite:
			break

	if sprite == null:
		return

	var mat := sprite.material as ShaderMaterial
	if mat == null:
		return

	# Glow ON
	var tween := create_tween()
	tween.tween_property(mat, "shader_parameter/glow_strength", 1.0, 0.1)

	await get_tree().create_timer(1.0).timeout
	if not is_instance_valid(enemy):
		return

	# Glow OFF
	var fade_tween := create_tween()
	fade_tween.tween_property(mat, "shader_parameter/glow_strength", 0.0, 0.5)


	
#2 Life System Setup
#2.1 Taking Damage
func take_damage(amount: int = 1):
	if invincible:
		return
	life -= amount
	ui.damage(amount)
	blink()

	if life <= 0:
		die()
		return

	invincible = true
	await get_tree().create_timer(INVINCIBILITY_TIME).timeout
	invincible = false

#Blinking effect post hit
func blink():
	var t = create_tween()
	t.tween_property(sprite_2d, "modulate:a", 0.3, 0.1)
	t.tween_property(sprite_2d, "modulate:a", 1.0, 0.1)

func _on_passive_damage_timer_timeout() -> void:
	take_damage(1)

func spawn_magic():
	# Don't allow magic if no powerup
	if not has_magic_powerup:
		return

	if not magic_scene:
		return

	var magic_inst = magic_scene.instantiate()
	get_parent().add_child(magic_inst)
	magic_inst.global_position = magic_spawn.global_position

	if magic_inst is Node2D:
		magic_inst.scale.x = pivot.scale.x

		
func give_magic_powerup(texture: Texture2D) -> void:
	PowerupUi.set_powerup(texture)
	has_magic_powerup = true

func start_magic_cooldown():
	magic_ready = false

	var timer := get_tree().create_timer(magic_cooldown)
	await timer.timeout

	magic_ready = true
