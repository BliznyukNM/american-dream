extends Spatial


onready var traveller: = $Traveller


func _ready() -> void:
	traveller.connect("routes_changed", self, "_show_route_selector")


func _process(_delta: float) -> void:
	if $RouteSelector.visible and Input.is_action_just_pressed("ui_focus_next"):
		$RouteSelector/Container.roll()
		
	if traveller.routes_available.size() > 0 and Input.is_action_just_pressed("traveller_keyboard_select"):
		traveller.select_route($RouteSelector/Container.selected_index)


func _show_route_selector(traveller: Traveller, routes: Array) -> void:
	routes.invert()
	$RouteSelector.visible = routes.size() > 0
	$RouteSelector.fill_info(routes)
