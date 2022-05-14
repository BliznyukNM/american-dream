extends Control


func update_money(count: int) -> void:
	$Money.text = str(count)


func update_points(points: int) -> void:
	$Points.text = str(points)
