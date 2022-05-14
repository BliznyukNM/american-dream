extends Area


export(Array, NodePath) var _routes: Array


var _travellers_tracked: = {}
var _trains_tracked: Array


func _on_traveller_in_range(traveller: Traveller) -> void:
	if traveller.in_entity: return
	_register_traveler(traveller)


func _register_traveler(traveller: Traveller) -> void:
	_travellers_tracked[traveller] = { "selected_route": -1 }
	traveller.connect("route_selected", self, "_on_traveller_route_selected")
	traveller.connect("back_attempted", self, "_on_traveller_back_requested")
	traveller.routes_available = _routes


func _on_traveller_out_of_range(traveller: Traveller) -> void:
	if not _travellers_tracked.has(traveller): return
	traveller.disconnect("route_selected", self, "_on_traveller_route_selected")
	traveller.disconnect("back_attempted", self, "_on_traveller_back_requested")
	_travellers_tracked.erase(traveller)


func _on_train_arrived(train: Train, station_index: int) -> void:
	if get_node(train.path.stations[station_index]) != self: return
	_trains_tracked.append(train)
	_resolve_travellers()
	print("Train arrived at ", get_node(train.path.stations[station_index]))


func _on_train_left(train: Train, station_index: int) -> void:
	if get_node(train.path.stations[station_index]) != self: return
	_trains_tracked.erase(train)


func _on_traveller_route_selected(traveller: Traveller, index: int) -> void:
	traveller.place_in_entity($Hall)
	_register_traveler(traveller)
	_travellers_tracked[traveller]["selected_route"] = index
	_resolve_travellers()


func _on_traveller_back_requested(traveller: Traveller) -> void:
	traveller.place_in_world($Exit)
	_travellers_tracked[traveller]["selected_route"] = -1


func _resolve_travellers() -> void:
	for traveller in _travellers_tracked:
		var route_index = _travellers_tracked[traveller]["selected_route"]
		if route_index < 0: continue
		
		for train in _trains_tracked:
			if train.path != get_node(_routes[route_index]): continue
			train.register_traveller(traveller)
			_on_traveller_out_of_range(traveller)
			break


func _on_traveller_exited(train: Train, traveller: Traveller, station_index: int) -> void:
	if get_node(train.path.stations[station_index]) != self: return
	traveller.place_in_world($Exit)
