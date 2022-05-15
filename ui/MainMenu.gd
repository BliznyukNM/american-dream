extends Control


onready var map: = preload("res://maps/UnitedStates.tscn")


func _ready() -> void:
	$SinglePlayer.connect("button_up", self, "_start_solo")
	$DuoGame.connect("button_up", self, "_start_duo")


func _start_solo() -> void:
	var game: Game = map.instance()
	game.player_count = 1
	get_tree().root.add_child(game)
	queue_free()


func _start_duo() -> void:
	var game: Game = map.instance()
	game.player_count = 2
	get_tree().root.add_child(game)
	queue_free()
