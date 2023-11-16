extends Unit

@onready var selection: Sprite2D = get_node("Selection")

func toggle_selection(toggle):
	selection.visible = toggle
