extends KinematicBody
class_name Traveller


signal route_selected(traveller, route)
signal back_attempted(traveller)
signal select_attempted(traveller)
signal routes_changed(traveller, routes)


export var speed: = 10.0
export var car_speed: = 40.0
export var money: = 100
export var points: = 0


var routes_available: Array = []
var close_station: NodePath
var in_entity: bool


var _can_move: bool = true
var _map_root: Node


func _is_car() -> bool: return $AMERIVAN.visible


func _ready() -> void:
	_map_root = get_parent()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("traveller_keyboard_back"):
		emit_signal("back_attempted", self)
	
	if Input.is_action_just_pressed("traveller_keyboard_select"):
		emit_signal("select_attempted", self)
	
	if not _can_move: return
	
	if Input.is_action_just_pressed("traveller_keyboard_car_toggle"):
		_enable_car(not _is_car())
	
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("traveller_keyboard_right") - Input.get_action_strength("traveller_keyboard_left")
	direction.y = Input.get_action_strength("traveller_keyboard_down") - Input.get_action_strength("traveller_keyboard_up")
	_apply_movement(direction, delta)


func _enable_car(enable: bool) -> void:
	$Person.visible = not enable
	$AMERIVAN.visible = enable


func _apply_movement(direction: Vector2, delta: float) -> void:
	var movement: = Vector3(direction.x, 0, direction.y)
	movement = movement.normalized() if movement.length_squared() > 1 else movement
	move_and_slide(movement * (car_speed if _is_car() else speed), Vector3.UP, true, 4)
	
	if movement.length_squared() > 0:
		look_at(translation + movement, Vector3.UP)


func place_in_entity(entity: Node) -> void:
	_enable_car(false)
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


func select_route(index: int, cost: int) -> void:
	money -= cost
	emit_signal("route_selected", self, index)


func set_station_info(routes: Array, station: NodePath) -> void:
	routes_available = routes
	close_station = station
	emit_signal("routes_changed", self, routes_available)
