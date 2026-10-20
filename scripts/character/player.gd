extends character
# The player is able to dash by double tapping any directional input.
# I have implemented the dash system, however i still need to implement that double tap input.

# all of these variables will be modifiable through items. 
# do note that dash power affects the velocity, duration, of the dash
@export var can_dash : bool
@export var dash_power : float
@export var dash_cd : float

#not these ones though lol
@export var friction_coeff : float
@export var last_dash_time : float
@export var input_direction : Vector2
@export var dash_direction : Vector2
@export var is_dashing : bool
func _ready():
	movespeed = 120
	can_dash = true
	dash_power = 10
	dash_cd = 1
	is_dashing = false
	friction_coeff = 10
	dash_direction = Vector2.ZERO
func get_input():
	#if not Input.is_action_pressed("shift"):
		#look_at(get_global_mouse_position())
	# ^possible option? would give the user the option to lock their aim angle.
	# not sure how useful it would be, however.
	
	look_at(get_global_mouse_position())
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * movespeed
	if Input.is_action_pressed('shift'):
		if (Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down")):
			if _try_dash():
				_dash()
				print("dash used")
	# placeholder, will be replaced with the weapon system
	if Input.is_action_pressed('click'):
		print("projectile fired")
	
	
func _try_dash() -> bool:
	if not can_dash:
		return false
	if Time.get_unix_time_from_system() - last_dash_time < dash_cd:
		return false
	_dash()
	return true

func _dash():
	input_direction = Input.get_vector("left", "right", "up", "down")
	# cannot dash while standing still 
	# (i could add like spot dodging if we go in on dashes also working as a dodge but whatever)
	if input_direction == Vector2.ZERO:
		return
	dash_direction = input_direction

	velocity = dash_direction * dash_power * 50
	is_dashing = true
	last_dash_time = Time.get_unix_time_from_system()

func _physics_process(delta):
	input_direction = Input.get_vector("left", "right", "up", "down")
	if is_dashing : 
		velocity = velocity.lerp(dash_direction * movespeed, friction_coeff * delta)
		
		if Time.get_unix_time_from_system() - last_dash_time >= dash_power * 0.01:
			is_dashing = false
	else:
		get_input()
	move_and_slide()
