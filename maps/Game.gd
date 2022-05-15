extends Spatial


export var hours: = 336.0
export var hours_drain_per_second: = 1.0
export var player_count: = 1
export(Array, String) var input_prefixes: Array
export(Array, Vector3) var starting_points: Array


onready var traveller_template: = preload("res://character/Traveller.tscn")


func _ready() -> void:
	for i in range(0, player_count):
		var viewport = _create_viewport(i)
		var traveller: Traveller = traveller_template.instance()
		traveller.set_input_prefix(input_prefixes[i])
		add_child(traveller)
		traveller.global_translate(starting_points[i])
		viewport.setup(traveller, $World)


func _create_viewport(index: int) -> PlayerViewport:
	var base_viewport = $HBoxContainer.get_child(0)
	var viewport: PlayerViewport = base_viewport if index == 0 else base_viewport.duplicate()
	if viewport.get_parent() == null: $HBoxContainer.add_child(viewport)
	return viewport
