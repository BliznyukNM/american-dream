extends KinematicBody
class_name Traveller


signal route_selected(traveller, route)
signal back_attempted(traveller)
signal routes_changed(traveller, routes)


export var speed: = 10.0


var routes_available: Array = [] setget set_routes_available
var in_entity: bool


var _can_move: bool = true
var _map_root: Node


func _ready() -> void:
	_map_root = get_parent()


func _process(_delta: float) -> void:
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
	move_and_slide(movement * speed)


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


func select_route(index: int) -> void:
	print("selecter ", index, " route")
	emit_signal("route_selected", self, index)


func set_routes_available(value: Array) -> void:
	routes_available = value
	emit_signal("routes_changed", self, routes_available)
