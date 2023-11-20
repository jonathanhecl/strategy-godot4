extends Node2D

var selected_unit: CharacterBody2D
var players: Array[CharacterBody2D]
var enemies: Array[CharacterBody2D]

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			try_select_unit()
				

func try_select_unit():
	var unit = get_selected_unit()
	if unit != null and unit.is_player:
		if selected_unit != unit:
			select_unit(unit)
			return
	
	if unit == null or (unit != null and !unit.is_player):
		if selected_unit != null:
			try_command_unit()
			return
	
	unselect_unit()
	
func select_unit(unit):
	unselect_unit()
	selected_unit = unit
	selected_unit.toggle_selection(true)

func unselect_unit():
	if selected_unit != null:
		selected_unit.toggle_selection(false)
		selected_unit = null

func get_selected_unit():
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	var intersection = space.intersect_point(query, 1)
	
	if intersection.is_empty():
		return null
		
	return intersection[0].collider

func try_command_unit():
	if selected_unit == null:
		return

	var target = get_selected_unit()
	if target != null and !target.is_player:
		selected_unit.set_target(target)
	else:
		selected_unit.move_to_location(get_global_mouse_position())
