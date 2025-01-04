extends Node

@onready var debug_menu : DebugMenu = get_tree().get_first_node_in_group("DebugMenu")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_menu"):
		debug_menu.visible = !debug_menu.visible
