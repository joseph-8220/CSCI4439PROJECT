extends CharacterBody2D
var projectile_path=preload("res://scenes/projectile.tscn")
var weaponid = 3
var fire_rate = 0.15
var damage: int = 1
var lifetime: float = 0.53
var hungry: bool = false
@onready var m_gun_sound: AudioStreamPlayer2D = $MGunSound

func checkStats():
	fire_rate = .005 - (.001 - .15)*pow(0.93, get_parent().player.dmgbuffcount)
	get_parent().fire_rate = fire_rate
	get_parent().damage = 1 + floor(get_parent().player.dmgbuffcount/10)
	$"../Sprite2D".frame = 4
	
func use(damage):
	m_gun_sound.pitch_scale = randf_range(0.85, 1.10)
	m_gun_sound.play()
	var spread = deg_to_rad(.45*get_parent().player.dmgbuffcount)
	var random_offset = randf_range(-spread/2, spread/2)
	var final_angle = global_rotation + random_offset
	var projectile = projectile_path.instantiate()
	projectile.lifetime = lifetime
	projectile.dir = final_angle 
	projectile.pos = global_position
	projectile.rota = final_angle
	projectile.damage = damage
	projectile.hungry = hungry
	projectile.speed = 300 + 3.5*get_parent().player.dmgbuffcount
	projectile.pierce = 1
	get_tree().current_scene.add_child(projectile)
		

	
