extends KinematicBody


func _process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("traveller_keyboard_right") - Input.get_action_strength("traveller_keyboard_left")
	direction.y = Input.get_action_strength("traveller_keyboard_down") - Input.get_action_strength("traveller_keyboard_up")
	_apply_movement(direction)


func _apply_movement(direction: Vector2) -> void:
	var movement: = Vector3(direction.x, 0, direction.y)
	movement = movement.normalized() if movement.length_squared() > 1 else movement
	move_and_slide(movement * 10)
