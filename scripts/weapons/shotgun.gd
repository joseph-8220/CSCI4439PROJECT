extends CharacterBody2D
var projectile_path=preload("res://scenes/projectile.tscn")
var weaponid = 2
var damage: int = 1
var fire_rate: float = 0.75
var pellets: int
var lifetime: float = .15
var pierce: int
var hungry: bool = true


@onready var shotgun_sound: AudioStreamPlayer2D = $ShotgunSound

func _ready():
	pellets = 3
	
func checkStats() -> String:
	pellets = 3 + get_parent().player.dmgbuffcount * 2
	pierce = 1 + floor(get_parent().player.dmgbuffcount/3)
	get_parent().fire_rate = fire_rate
	get_parent().damage = damage
	$"../Sprite2D".frame = 3
	return str(pellets)
	
func use(damage):
	var spread = deg_to_rad(35)
	shotgun_sound.pitch_scale = randf_range(0.8, 1.2)
	shotgun_sound.play()
	for i in range(pellets):
		var projectile = projectile_path.instantiate()
		
		var random_offset = randf_range(-spread/2, spread/2)
		var final_angle = global_rotation + random_offset
		
		projectile.lifetime = lifetime
		projectile.dir = final_angle 
		projectile.pos = global_position
		projectile.rota = final_angle
		projectile.damage = damage
		projectile.pierce = pierce
		projectile.hungry = hungry
		projectile.speed = 300*randf_range(0.85,1.75) + 5*get_parent().player.dmgbuffcount
		get_tree().current_scene.add_child(projectile)
		
	var knockback_force = 325+(6*pellets)
	get_tree().get_first_node_in_group("player").knockback = -Vector2.from_angle(global_rotation) * knockback_force
	
	
	
