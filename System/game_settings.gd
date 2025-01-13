extends Node

var camera_sensivity : float = 0.1 ## regular camera movement sensitivity
var max_fps := 120
var desired_fov : float = 85.0


@onready var default_mouse_mode : Input.MouseMode = Input.MOUSE_MODE_CAPTURED


func _ready() -> void:
	Engine.max_fps = max_fps
