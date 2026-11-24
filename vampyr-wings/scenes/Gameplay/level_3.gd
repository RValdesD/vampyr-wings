extends Node

@onready var player: Player = $EnemyGlow/Player
@onready var plat_glow: TileMapLayer = $GlowLayer/TileGlow
@onready var level_3: Node2D = $"Level 3"

func _ready():
	player.echo_fired.connect(_on_player_echo)

func _on_player_echo():
	if plat_glow:
		plat_glow.reveal_with_echo()
