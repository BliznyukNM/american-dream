extends Path


export(Array, float) var stops: Array


func _ready() -> void:
	for train in get_children():
		train.register(stops)
		train.start()
