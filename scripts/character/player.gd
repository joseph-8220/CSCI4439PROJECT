extends character
# The player is able to dash by double tapping any directional input.
# I have implemented the dash system, however i still need to implement that double tap input.

# all of these variables will be modifiable through items. 
# do note that dash power affects the velocity, duration, of the dash
@export var dash_power : float = 8.5
@export var dash_cd : float = 1
@export var friction_coeff : float = 8
@export var playerhealth : int = 3
@export var money : int = 0
@export var knockback_strength : float = 500
@export var iframes_duration: float = .5
#not these ones though lol
var can_dash : bool = true
var is_invuln: bool = false
var last_dash_time : float
var input_direction : Vector2 = Vector2.ZERO
var dash_direction : Vector2 = Vector2.ZERO
var is_dashing : bool
var current_weapon : int = 0
var knockback: Vector2 = Vector2.ZERO
var dead: bool
func _ready():
	movespeed = 85
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
	#if Input.is_action_pressed('click'):
		#$equip_weapon._try_use()
	
	
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
	if get_tree().paused or dead:
		return
	if Input.is_action_just_pressed("ui_accept"):
		playerhealth = 3
	if playerhealth <= 1:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
		
	input_direction = Input.get_vector("left", "right", "up", "down")
	
	# DASHING
	if is_dashing : 
		velocity = velocity.lerp(dash_direction * movespeed, friction_coeff * delta)
		
		if Time.get_unix_time_from_system() - last_dash_time >= dash_power * 0.01:
			is_dashing = false
	else:
		if not is_invuln:
			pass
			#for index in get_slide_collision_count():
				#var collision = get_slide_collision(index)
				#if is_instance_valid(collision.get_collider()):
					#if collision.get_collider().is_in_group("enemy"):
						#var push_dir = (global_position - collision.get_collider().global_position).normalized()
						#knockback = push_dir * knockback_strength
						#
						#var playerdamage = collision.get_collider().damage
						#print("player took ", playerdamage, " damage")
						#damage(playerdamage)
						#ubercharge()
						#break
		
		get_input()
		velocity += knockback
		knockback = knockback.lerp(Vector2.ZERO, friction_coeff * delta)
	move_and_slide()

func damage(owchie):
	playerhealth = playerhealth - owchie
	
	if playerhealth < 1:
		dead = true;
		print("player died")

func ubercharge():
	if dead:
		return
	is_invuln = true
	print("ubered")
	await get_tree().create_timer(iframes_duration).timeout
	is_invuln = false
	print("iframes over")


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if is_invuln or dead:
		return
	if body.is_in_group("enemy"):
		var push_dir = (global_position - body.global_position).normalized()
		knockback = push_dir * knockback_strength
		velocity = knockback # Immediately launch the player
		
		print("player took ", body.damage, " damage")
		damage(body.damage)
		ubercharge()
