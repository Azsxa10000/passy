class_name BaseCharacter
extends CharacterBody3D

const _max_possible_velocity := Globals.max_possible_velocity ## Max possible velocity in meters per second


## Caps velocity of CharacterBody3D

# code is here solely to prevent needing to rewrite error message each time
func _cap_velocity(delta):
	if abs(velocity.length()) > _max_possible_velocity * delta:
		push_warning("velocity reached: ", velocity, "...   Capping to: ", _max_possible_velocity * delta)
		velocity = (velocity.normalized() * _max_possible_velocity * delta)
