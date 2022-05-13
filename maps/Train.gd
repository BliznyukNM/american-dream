extends PathFollow


signal station_reached
signal station_left


export var speed: = 20
export var stop_delay: = 2.0
export var next_station: = 0


var stops: Array


func _ready() -> void:
	connect("station_left", self, "_go_to_station")
	connect("station_reached", self, "_wait_at_station")


func register(stops: Array) -> void:
	self.stops = stops


func start() -> void:
	emit_signal("station_left")


func _go_to_station() -> void:
	var point_from = 0 if next_station == 0 else stops[next_station - 1]
	var point_next = stops[next_station]
	
	var tween = create_tween()
	tween.tween_property(self, "offset", point_next, (point_next - point_from) / speed).set_trans(Tween.TRANS_QUAD)
	
	yield(tween, "finished")
	emit_signal("station_reached")


func _wait_at_station() -> void:
	yield(get_tree().create_timer(stop_delay), "timeout")
	next_station = (next_station + 1) % stops.size()
	emit_signal("station_left")
