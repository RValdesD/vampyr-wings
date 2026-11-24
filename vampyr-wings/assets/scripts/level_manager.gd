extends Node

@export var levels: Array[PackedScene] = []
var curr: int = 0

# Safely sync curr with currently loaded scene
func update_curr_from_scene() -> void:
	var current_scene = get_tree().current_scene
	if current_scene == null:
		push_warning("LevelManager: current_scene is null, cannot update curr")
		return

	var current_scene_path = current_scene.get_scene_file_path()
	for i in range(levels.size()):
		if levels[i].resource_path == current_scene_path:
			curr = i
			return

	push_warning("LevelManager: current scene not found in levels array.")

# Go to the next level
func go_to_next_level() -> void:
	if levels.size() == 0:
		push_error("LevelManager: No levels assigned")
		return

	curr = (curr + 1) % levels.size()
	get_tree().change_scene_to_packed(levels[curr])

# Go to the previous level
func go_to_prev_level() -> void:
	if levels.size() == 0:
		push_error("LevelManager: No levels assigned")
		return

	curr = (curr - 1 + levels.size()) % levels.size() # safe modulo
	get_tree().change_scene_to_packed(levels[curr])

# Go to a specific scene path
func go_to_scene(scene_path: String) -> void:
	var scene = load(scene_path)
	if scene:
		get_tree().change_scene_to_packed(scene)
		call_deferred("update_curr_from_scene") # ensure scene loaded before syncing curr
	else:
		push_error("LevelManager: Could not load scene at path: " + scene_path)

func is_current_scene_a_level() -> bool:
	var current_scene = get_tree().current_scene
	if current_scene == null:
		return false

	var current_scene_path = current_scene.get_scene_file_path()

	for level in levels:
		if level.resource_path == current_scene_path:
			return true

	return false
