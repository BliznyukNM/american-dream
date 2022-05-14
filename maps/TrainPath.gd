extends Path
class_name TrainPath


export(Array, float) var stops: Array
export(Array, NodePath) var stations: Array


func _ready() -> void:
	stops.append(curve.get_baked_length())
	for train in get_children():
		train.register(self, stops)
		train.start()
