extends Spatial


export var hours: = 336.0
export var hours_drain_per_second: = 1.0


onready var traveller: = $Traveller
onready var top_bar: = $TopBar


func _ready() -> void:
	traveller.connect("routes_changed", self, "_show_route_selector")
	top_bar.update_money(traveller.money)
	$RouteSelector.visible = false


func _process(delta: float) -> void:
	if $RouteSelector.visible and Input.is_action_just_pressed("ui_focus_next"):
		$RouteSelector/Container.roll()
		
	if traveller.routes_available.size() > 0 and Input.is_action_just_pressed("traveller_keyboard_select") and $RouteSelector/Container.can_buy_selected():
		traveller.select_route($RouteSelector/Container.selected_index, $RouteSelector/Container.get_selected_ticket_cost())
	
	top_bar.update_money(int(traveller.money))
	top_bar.update_points(traveller.points)
	var hours_int: = int(hours)
	top_bar.update_time(hours_int % 24, hours_int / 24)
	hours -= hours_drain_per_second * delta


func _show_route_selector(traveller: Traveller, routes: Array) -> void:
	routes.invert()
	$RouteSelector.visible = routes.size() > 0
	$RouteSelector.fill_info(traveller, routes, traveller.close_station)
