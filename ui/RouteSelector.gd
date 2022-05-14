extends Control


func fill_info(stations: Array) -> void:
	for i in range(1, $Container.get_child_count()):
		$Container.get_child(i).queue_free()
	
	for i in len(stations):
		var ticket = $Container.get_child(0) if i == 0 else $Container.get_child(0).duplicate()
		if ticket.get_parent() == null: $Container.add_child(ticket)
		ticket.get_node("Label").text = stations[i]
