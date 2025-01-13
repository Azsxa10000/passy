extends Node3D


@export var fov_change_override : bool ## prevents normal fov changes from ocurring
@export var desired_fov_override : float: ## overrides desired fov
	set(val):
		desired_fov_override = val
		if not is_node_ready():
			await ready
		desired_fov = desired_fov_override # if desired fov override changed at runtime, it will adjust properly

@export var sprint_fov_multiplier : float = 0.90 ## multiplier on fov applied when sprinting
@export var sprint_fov_modifier_time : float = 0.5 ## how long in seconds for tween to change fov from sprint
@export var sprint_fov_modifier_fade_time : float = 0.35 ## how long in seconds for tween to change fov from stopping sprint
var desired_fov = desired_fov_override if desired_fov_override != 0.0 else GameSettings.desired_fov
# desired fov set in GameSetings unless override has a value

@onready var camera: Camera3D = $Camera3D




func _ready() -> void:
	if get_parent().is_in_group("PlayerCharacterBody"):
		get_parent().connect("update_sprint_fov",sprint_fov_adjust)
	camera.fov = desired_fov
		
var tween : Tween

func sprint_fov_adjust(is_sprinting:bool):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()	
	if is_sprinting:
		print("sprint")
		tween.tween_property(camera,"fov",(desired_fov * sprint_fov_multiplier), sprint_fov_modifier_time).set_trans(Tween.TRANS_CUBIC)
	else:
		print("not sprint")
		tween.tween_property(camera,"fov", desired_fov, sprint_fov_modifier_fade_time).set_trans(Tween.TRANS_CUBIC)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion : Vector2 = event.relative
		basis = basis.rotated(basis.x, deg_to_rad(-mouse_motion.y * GameSettings.camera_sensivity))
		rotation_degrees.x = clampf(rotation_degrees.x, -80.,80.)
