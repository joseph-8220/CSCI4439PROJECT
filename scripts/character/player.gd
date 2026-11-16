extends CharacterBody2D
# The player is able to dash by double tapping any directional input.
# I have implemented the dash system, however i still need to implement that double tap input.

# all of these variables will be modifiable through items. 
# do note that dash power affects the velocity, duration, of the dash
@export var dash_power : float = 10
@export var dash_cd : float = 1
@export var friction_coeff : float = 8
@export var playerhealth : int = 3
@export var maxhealth: int = 3
@export var money : int = 0
@export var knockback_strength : float = 500
@export var iframes_duration: float = .5
@export var weaponid: int = 1
@export var dmgbuffcount: int = 0
@export var vitbuffcount: int = 0
@export var spebuffcount: int = 0
@export var movespeed: int

@onready var dashsound: AudioStreamPlayer2D = $dashsound
@onready var hurtsound: AudioStreamPlayer2D = $hurtsound

#not these ones though lol
var can_dash : bool = true
var is_invuln: bool = false
var last_dash_time : float
var input_direction : Vector2 = Vector2.ZERO
var dash_direction : Vector2 = Vector2.ZERO
var is_dashing : bool
# var current_weapon : int = 0
var knockback: Vector2 = Vector2.ZERO
var dead: bool
var shopping: bool = false
var score: int = 0
func _ready():
	movespeed = 85
func get_input():
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	var aim_direction = (mouse_pos - global_position).normalized()
	$equip_weapon.set_aim_direction(aim_direction)
	if Input.is_action_pressed("click"):
		$equip_weapon._try_use()
	
	
	
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * movespeed
	if Input.is_action_pressed('shift'):
		if (Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down")):
			if _try_dash():
				_dash()
				print("dash used")

	
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
	if input_direction == Vector2.ZERO:
		return
	dashsound.play()
	dash_direction = input_direction
	velocity = dash_direction * dash_power * 50
	can_dash = false
	is_dashing = true
	set_collision_mask_value(4, false)
	set_collision_layer_value(2, false)
	last_dash_time = Time.get_unix_time_from_system()

func _physics_process(delta):
	#prevent player input while game is paused, player is dead, or shopping ui is open
	if get_tree().paused or dead or shopping:
		return
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
			set_collision_mask_value(4, true)
			set_collision_layer_value(2, true)
			await get_tree().create_timer(dash_cd, false).timeout
			can_dash = true
			
			
	else:
		# i cannot seem to get the world boundaries to work so this is the best i got
		if global_position.x < -165:
			global_position.x = -165
		elif global_position.x > 165:
			global_position.x = 165
		if global_position.y < -90:
			global_position.y = -90
		elif global_position.y > 90:
			global_position.y = 90
		
		get_input()
		velocity += knockback
		knockback = knockback.lerp(Vector2.ZERO, friction_coeff * delta)
	move_and_slide()

# damage and death function 
func damage(owchie):
	if is_invuln or is_dashing:
		return
	hurtsound.pitch_scale = randf_range(0.92, 1.2)
	hurtsound.play()
	playerhealth = playerhealth - owchie
	$Sprite2D.frame = 1
	ubercharge()
	$Sprite2D.frame = 0
	if playerhealth < 1:
		dead = true;
		$Sprite2D.modulate.a = 0
		$equip_weapon.modulate.a = 0
		get_tree().get_first_node_in_group("main").death()

# iframes 
func ubercharge():
	if dead:
		return
	is_invuln = true
	print("ubered")
	await get_tree().create_timer(iframes_duration).timeout
	is_invuln = false
	print("iframes over")

func checkStats():
	maxhealth = 3 + vitbuffcount
	playerhealth = maxhealth
	dash_power = 10 + .6*spebuffcount
	movespeed = 85 + 5*spebuffcount
	iframes_duration = 0.5 + .009*vitbuffcount
	friction_coeff = 8 + .004*vitbuffcount

# originally i was doing the collision.collider.whatever thing i used for the projectiles but in 
# general it was just really buggy so i decided to just use a hurtbox instead
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if is_invuln or dead or is_dashing:
		return
	if body.is_in_group("enemy"):
		var push_dir = (global_position - body.global_position).normalized()
		knockback = push_dir * knockback_strength
		velocity = knockback 
		
		print("player took ", body.damage, " damage")
		damage(body.damage)
		ubercharge()
