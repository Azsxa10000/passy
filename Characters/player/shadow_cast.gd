@tool
extends RayCast3D

@onready var decal: Decal = $Shadow

func _physics_process(delta: float) -> void:
	if is_colliding():
		decal.global_position = get_collision_point()
