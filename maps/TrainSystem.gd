extends Node


func _ready() -> void:
	for path in get_children():
		if path is Route:
			for station in path.stations:
				for train in path.get_children():
					train.connect("station_left", path.get_node(station), "_on_train_left")
					train.connect("station_reached", path.get_node(station), "_on_train_arrived")
					train.connect("traveller_exited", path.get_node(station), "_on_traveller_exited")
