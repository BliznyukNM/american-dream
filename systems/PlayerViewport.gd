extends ViewportContainer
class_name PlayerViewport


onready var _top_bar: = $Viewport/TopBar
onready var _route_selector: = $Viewport/RouteSelector
onready var _route_container: = $Viewport/RouteSelector/Container
onready var _viewport: = $Viewport


var _traveller: Traveller


func setup(traveller: Traveller, world: Node) -> void:
	_traveller = traveller
	
	_traveller.connect("routes_changed", self, "_show_route_selector")
	_top_bar.update_money(traveller.money)
	_route_selector.visible = false
	
	_viewport.world = world
	$Viewport/Camera.traveller = traveller


func _process(delta: float) -> void:
	_top_bar.update_money(int(_traveller.money))
	_top_bar.update_points(_traveller.points)
	
	if _route_selector.visible and Input.is_action_just_pressed(_traveller.pr("next")):
		_route_container.roll()
		
	if _traveller.routes_available.size() > 0 and Input.is_action_just_pressed(_traveller.pr("select")) and _route_container.can_buy_selected():
		_traveller.select_route(_route_container.selected_index, _route_container.get_selected_ticket_cost())


func _show_route_selector(traveller: Traveller, routes: Array) -> void:
	routes.invert()
	_route_selector.visible = routes.size() > 0
	_route_selector.fill_info(traveller, routes, traveller.close_station)
