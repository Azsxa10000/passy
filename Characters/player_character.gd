extends BaseCharacter 	
# custom class_name from base_character.gd
# all code from BaseCharacter and acts like all code was placed here 

@export var max_speed := 6.0
@export var max_sprint_speed := 10.0
@export var acceleration : float = 10.0 ##fraction of a second until max speed is reached 


# jump logic done by mimmicking irl phyiscs equations, no touchy unless you know what you're doing, just adjust these export
# values ehre and dont touch anything else relatated to jump physics
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
		
func get_grav() -> float: ## allows for different gravity during fall and jump 
	if velocity.y > 0 and not fast_fall:
		return jump_gravity
	else:
		return fall_gravity


	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion = event.relative
		rotation_degrees.y -= event.relative.x * GameSettings.camera_sensivity
	if event.is_action_released("jump") and velocity.y > 0:
		fast_fall = true
	



func _physics_process(delta: float) -> void: 	
############# Horizontal movement code
	var input_dir : Vector2 = Input.get_vector("move_left","move_right","move_forward","move_backward")
	var movement_dir : Vector3 = Vector3(input_dir.x, 0.0, input_dir.y).rotated(Vector3.UP, rotation.y)

	if Input.is_action_pressed("sprint") and input_dir.length() > 0:
		velocity = velocity.lerp(Vector3(movement_dir.x * max_sprint_speed, velocity.y, movement_dir.z * max_sprint_speed),acceleration * delta)
	else:	
		velocity = velocity.lerp(Vector3(movement_dir.x * max_speed, velocity.y, movement_dir.z * max_speed),acceleration * delta)
	
###########################


############# jump code
	if Input.is_action_just_pressed("jump"):
		try_jump()
	
	velocity.y += get_grav() * delta

	
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
