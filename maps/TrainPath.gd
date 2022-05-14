extends Path


export(Array, float) var stops: Array


func _ready() -> void:
	stops.append(curve.get_baked_length())
	
	for train in get_children():
		train.register(stops)
		train.start()
