extends Node2D

@export var default_fire_rate : float = 0.5
@export var default_damage: int = 1
var fire_rate: float 
var damage: int
var last_use_time : float
var aim_angle : float
var can_use : bool = true
var weap: Node2D
var weaponid: int
@onready var player = get_parent()
#defaults
func _ready():
	checkStats()

func _process(delta : float):
	global_rotation = lerp_angle(global_rotation, aim_angle, 40 * delta)
	
func set_aim_direction (aim_dir : Vector2):
	aim_angle = aim_dir.angle()

func _equip(id):
	player.weaponid = id
	checkStats()
	pass

func _unequip():
	pass

func _try_use() -> bool:
	if get_parent().shopping:
		return false
	if not can_use:
		return false
	if Time.get_unix_time_from_system() - last_use_time < fire_rate:
		return false
	last_use_time = Time.get_unix_time_from_system()
	_use()
	specialReload()
	await get_tree().create_timer(fire_rate).timeout
	specialLoad()
	return true

func _use():
	match get_parent().weaponid:
		1:
			$Pistol.use(damage)
		2: 
			$Shotgun.use(damage)
		3:
			$MGun.use(damage)
		4:
			$Crossbow.use(damage)


func checkStats():
	weap = checkID(get_parent().weaponid)
	weap.checkStats()
	pass
	
func checkID(weaponid) -> Node2D:
	match weaponid:
		1:
			return $Pistol
		2: 
			return $Shotgun
		3:
			return $MGun
		4:
			return $Crossbow
		_:
			return null
			
	
func specialReload():
	if get_parent().weaponid == 4:
		$Sprite2D.frame = 7
func specialLoad():
	if get_parent().weaponid == 4:
		$Sprite2D.frame = 6

func getDamage() -> int:
	return damage
func getROF() -> int:
	return fire_rate
