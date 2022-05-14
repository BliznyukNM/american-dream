extends KinematicBody
class_name Traveller


signal route_selected(traveller, route)
signal back_attempted(traveller)


var routes_available: Array
var in_entity: bool


var _can_move: bool = true
var _map_root: Node


func _ready() -> void:
	_map_root = get_parent()


func _process(_delta: float) -> void:
	if routes_available != null and Input.is_action_just_pressed("traveller_keyboard_select"):
		emit_signal("route_selected", self, 0)
	if Input.is_action_just_pressed("traveller_keyboard_back"):
		emit_signal("back_attempted", self)
	
	if not _can_move: return
	
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("traveller_keyboard_right") - Input.get_action_strength("traveller_keyboard_left")
	direction.y = Input.get_action_strength("traveller_keyboard_down") - Input.get_action_strength("traveller_keyboard_up")
	_apply_movement(direction)


func _apply_movement(direction: Vector2) -> void:
	var movement: = Vector3(direction.x, 0, direction.y)
	movement = movement.normalized() if movement.length_squared() > 1 else movement
	move_and_slide(movement * 10)


func place_in_entity(entity: Node) -> void:
	_can_move = false
	in_entity = true
	get_parent().remove_child(self)
	entity.add_child(self)
	translation = Vector3.ZERO


func place_in_world(exit: Spatial) -> void:
	_can_move = true
	in_entity = false
	get_parent().remove_child(self)
	_map_root.add_child(self)
	translation = exit.global_transform.origin
