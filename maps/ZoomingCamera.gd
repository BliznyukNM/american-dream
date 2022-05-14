extends Camera


export var max_zoom_global_point: Vector3
export var max_zoom_rotation: Vector3
export var max_zoom_fov: float

export var min_zoom_local_point: Vector3
export var min_zoom_rotation: Vector3
export var min_zoom_fov: float

onready var traveller: Traveller = $"../Traveller"


var _zoom: = 0.0


func zoom(delta: float) -> void:
	var min_zoom_global_point = traveller.global_transform.origin + min_zoom_local_point
	_zoom = clamp(_zoom + delta, 0, 1)
	var target_point = lerp(min_zoom_global_point, max_zoom_global_point, _zoom)
	global_transform.origin = target_point
	
	var target_rotation = lerp(min_zoom_rotation, max_zoom_rotation, _zoom)
	rotation_degrees = target_rotation
	
	var target_fov = lerp(min_zoom_fov, max_zoom_fov, _zoom)
	fov = target_fov


func _process(delta: float) -> void:
	if Input.is_action_just_released("camera_zoom_in"):
		zoom(-delta)
	elif Input.is_action_just_released("camera_zoom_out"):
		zoom(delta)
	else:
		zoom(0)
