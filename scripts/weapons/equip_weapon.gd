extends Node2D

@export var default_fire_rate : float = 0.5
@export var default_damage: int = 1
var fire_rate: float = 0.5
var damage: int = 1
var last_use_time : float
var aim_angle : float
var can_use : bool = true

func _process(delta : float):
	global_rotation = lerp_angle(global_rotation, aim_angle, 40 * delta)
func set_aim_direction (aim_dir : Vector2):
	aim_angle = aim_dir.angle()

func _equip(weapon):
	default_fire_rate = weapon.fire_rate # + damage_modifier
	default_damage = weapon.damage # * fire_rate_modifier
	
	pass

func _unequip():
	pass

func _try_use() -> bool:
	if not can_use:
		return false
	if Time.get_unix_time_from_system() - last_use_time < fire_rate:
		return false
	last_use_time = Time.get_unix_time_from_system()
	_use()
	return true

func _use():
	$Pistol.use(damage)
	
