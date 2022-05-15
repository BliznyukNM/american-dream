extends Path
class_name Route


export(Array, NodePath) var stations: Array
export var ticket_cost: int


func _ready() -> void:
	for train in get_children():
		train.register(self)
		train.start()
