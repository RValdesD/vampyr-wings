extends CanvasLayer

var current_powerup: Texture2D = null
var magic_unlocked: bool = false
@onready var slot_icon: TextureRect = $PowerupUI/SlotIcon

func reset_powerup():
	current_powerup = null
	magic_unlocked = false
	slot_icon.texture = null
	visible = false

func _process(_delta):
	_update_visibility()

func set_powerup(texture: Texture2D) -> void:
	current_powerup = texture
	magic_unlocked = true
	slot_icon.texture = texture

func clear_powerup() -> void:
	reset_powerup()

func _update_visibility():
	var current = get_tree().current_scene
	var is_level := false

	if current != null:
		var path := current.get_scene_file_path()
		for lvl in LevelManager.levels:
			if lvl.resource_path == path:
				is_level = true
				break

	# If this scene is NOT a level → reset the powerup UI
	if not is_level:
		reset_powerup()
		return  # Prevent showing UI

	# If it's a level → show only if unlocked and not paused
	visible = magic_unlocked and not get_tree().paused
