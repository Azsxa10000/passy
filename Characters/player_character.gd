extends "res://Characters/base_character_body.gd"

@export var max_speed := 6.0
@export var max_sprint_speed := 10.0

@export_category("jumps")
@export var jump_height := 3.0 ## height in meters for character to jump
@export var jump_peak_time:float ## time in seconds to reach peak of jump
@export var fall_time: float ##time in seconds to fall all the way down from peak


#no touchy, used for jump calculations, dont adjust here
@onready var jump_velocity = (2.0 * jump_height)/ jump_peak_time
@onready var jump_gravity = (-2.0 * jump_height)/ pow(jump_peak_time,2)
@onready var fall_gravity = (-2.0*jump_height) / pow(fall_time,2)
@onready var fast_fall := false


var can_double_jump:= true


func try_jump(): ## checks if can jump 
	if is_on_floor():
		jump()
	elif can_double_jump: # not on floor but can double jump
		can_double_jump = false
		jump()
func jump(): ## performs actual jump in physics
	velocity.y = jump_velocity
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		fast_fall = true
	
func get_grav() -> float:
	if velocity.y > 0 and not fast_fall:
		return jump_gravity
	else:
		return fall_gravity




func _physics_process(delta: float) -> void: 	
############# Horizontal movement code
	var input_dir : Vector2 = Input.get_vector("move_left","move_right","move_backward","move_backward")
	var movement_dir : Vector3 = Vector3(input_dir.x, 0.0, input_dir.y)


	
###########################
	
	
############# jump code
	if Input.is_action_just_pressed("jump"):
		try_jump()
	
	velocity.y += get_grav() * delta
	print( velocity.length())
	
	if is_on_floor(): ## jump code resetter
		can_double_jump = true
		if fast_fall:
			fast_fall = false
#############################
			
			
################# final movement checks
	if velocity.length() > _max_possible_velocity: # caps velocity to a max set in Globals
		_cap_velocity(delta)
		# function cap_velocity() declared in base_character_body.gd
		# allows for velocity capping and warning to be reused in different characters

####################################
	move_and_slide() ## at bottom to allow for jump and movement code to be run at the same time and spot in code
