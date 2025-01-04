extends Node


func _ready() -> void:
	Input.mouse_mode = GameSettings.default_mouse_mode


func _input(event: InputEvent) -> void:
	if Input.mouse_mode == GameSettings.default_mouse_mode and event.is_action("alt_tab") or event.is_action("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and event is InputEventMouseButton:
		Input.mouse_mode = GameSettings.default_mouse_mode
