extends PathFollow
class_name Train


signal station_reached(train, index)
signal station_left(train, index)
signal traveller_exited(train, traveller, index)


export var speed: = 20
export var stop_delay: = 2.0
export var next_station: = 0


var path: TrainPath


const epsilon = 0.01


var _stops: Array
var _waiting: bool


func _ready() -> void:
	connect("station_left", self, "_go_to_station")
	connect("station_reached", self, "_wait_at_station")


func register(path: TrainPath, stops: Array) -> void:
	self.path = path
	_stops = stops


func start() -> void:
	emit_signal("station_left", self, next_station)


func _go_to_station(_train, _index) -> void:
	_waiting = false
	var point_from = 0 if next_station == 0 else _stops[next_station - 1]
	var point_next = _stops[next_station]
	
	var tween = create_tween()
	tween.tween_property(self, "offset", point_next + epsilon, (point_next - point_from) / speed).set_trans(Tween.TRANS_QUAD)
	
	yield(tween, "finished")
	emit_signal("station_reached", self, next_station)


func _wait_at_station(_train, _index) -> void:
	_waiting = true
	yield(get_tree().create_timer(stop_delay), "timeout")
	var previous_station = next_station
	next_station = (next_station + 1) % _stops.size()
	emit_signal("station_left", self, previous_station)


func register_traveller(traveller: Traveller) -> void:
	traveller.place_in_entity(self)
	traveller.connect("back_attempted", self, "_on_traveller_back_requested")
	print("Traveller is on train ", self)


func _on_traveller_back_requested(traveller: Traveller) -> void:
	if not _waiting: return
	_unregister_traveller(traveller)
	emit_signal("traveller_exited", self, traveller, next_station)


func _unregister_traveller(traveller: Traveller) -> void:
	traveller.disconnect("back_attempted", self, "_on_traveller_back_requested")
