extends character
# The player is able to dash by double tapping any directional input.
# I have implemented the dash system, however i still need to implement that double tap input.

# all of these variables will be modifiable through items. 
# do note that dash power affects the velocity, duration, of the dash
@export var dash_power : float
@export var dash_cd : float
@export var friction_coeff : float

#not these ones though lol
@export var can_dash : bool
@export var last_dash_time : float
@export var input_direction : Vector2
@export var dash_direction : Vector2
@export var is_dashing : bool
@export var current_weapon : int
func _ready():
	movespeed = 120
	can_dash = true
	dash_power = 10
	dash_cd = 1
	is_dashing = false
	friction_coeff = 10
	dash_direction = Vector2.ZERO
	current_weapon = 0
func get_input():
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	var aim_direction = (mouse_pos - global_position).normalized()
	$equip_weapon.set_aim_direction(aim_direction)
	
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * movespeed
	if Input.is_action_pressed('shift'):
		if (Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down")):
			if _try_dash():
				_dash()
				print("dash used")
	# placeholder, will be replaced with the weapon system
	if Input.is_action_pressed('click'):
		$equip_weapon._try_use()
	
	
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
	if get_tree().paused:
		return
	input_direction = Input.get_vector("left", "right", "up", "down")
	if is_dashing : 
		velocity = velocity.lerp(dash_direction * movespeed, friction_coeff * delta)
		
		if Time.get_unix_time_from_system() - last_dash_time >= dash_power * 0.01:
			is_dashing = false
	else:
		get_input()
	move_and_slide()
