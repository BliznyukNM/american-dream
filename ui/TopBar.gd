extends Control


func update_money(count: int) -> void:
	$Money/Amount.text = str(count)


func update_points(points: int) -> void:
	$Points/Amount.text = str(points)


func update_time(hours: float, days: int) -> void:
	$Time/Calendar/Days.text = str(days)
	$Time/Clock/Pivot.rect_rotation = (1 - hours / 24.0) * 360
