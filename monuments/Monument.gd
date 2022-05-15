extends Area


export var points: = 10


var explored: bool


func _ready() -> void:
	connect("body_entered", self, "_on_traveller_entered")
	connect("body_exited", self, "_on_traveller_exited")


func _explore(traveller: Traveller) -> void:
	if explored: return
	explored = true
	$Particles.visible = false
	traveller.points += points


func _on_traveller_entered(traveller: Traveller) -> void:
	traveller.connect("select_attempted", self, "_explore")


func _on_traveller_exited(traveller: Traveller) -> void:
	traveller.disconnect("select_attempted", self, "_explore")
