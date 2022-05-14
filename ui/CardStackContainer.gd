tool
extends Container


export var shift: Vector2


var selected_index: = 0


func can_buy_selected() -> bool:
	return get_child(selected_index).can_buy


func get_selected_ticket_cost() -> int:
	return get_child(selected_index).cost


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		_rebuild()


func _rebuild() -> void:
	for i in range(0, get_child_count()):
		var index = get_child_count() - i - 1
		fit_child_in_rect(get_child(i), Rect2(Vector2(index * shift.x, index * shift.y), rect_size))


func roll() -> void:
	if get_child_count() <= 1: return
	
	var target = get_child(get_child_count() - 1)
	var target_color = target.modulate
	target_color.a = 0
	var pos_tween: = create_tween().tween_property(target, "rect_position", Vector2(-200, 0), 0.2)
	var color_tween: = create_tween().tween_property(target, "modulate", target_color, 0.2)
	
	yield(pos_tween, "finished")
	yield(color_tween, "finished")
	
	move_child(target, 0)
	target_color.a = 1.0
	target.modulate = target_color
	_rebuild()
	
	selected_index = (selected_index + 1) % get_child_count()
