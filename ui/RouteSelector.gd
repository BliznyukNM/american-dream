extends Control


func fill_info(traveller: Traveller, routes: Array, station_path: NodePath) -> void:
	var station: Station = null if station_path.is_empty() else get_node(station_path)
	
	for i in range(1, $Container.get_child_count()):
		$Container.get_child(i).queue_free()
	
	for i in len(routes):
		var ticket: TextureRect = $Container.get_child(0) if i == 0 else $Container.get_child(0).duplicate()
		if ticket.get_parent() == null: $Container.add_child(ticket)
		var route: TrainPath = station.get_node(routes[i])
		var station_index: = (route.stations.find(route.get_path_to(station)) + 1) % route.stations.size()
		var ticket_cost: int = route.ticket_costs[station_index]
		ticket.get_node("Label").text = route.get_node(route.stations[station_index]).name + " " + str(ticket_cost) + "$"
		ticket.cost = ticket_cost
		
		if ticket_cost > traveller.money:
			ticket.can_buy = false
