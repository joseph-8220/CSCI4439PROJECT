extends CharacterBody2D
var projectile_path=preload("res://scenes/projectile.tscn")
var weaponid = 1
var fire_rate: float = 0.5
var damage: int = 1
var hungry: bool = false
#PISTOL

func checkStats():
	damage = 1 + floor(get_parent().player.dmgbuffcount/1.5)
	fire_rate = 0.5/pow(1.05, get_parent().player.dmgbuffcount)
	get_parent().fire_rate = fire_rate
	get_parent().damage = damage
	$"../Sprite2D".frame = 2
	
func use(damage):
	var projectile = projectile_path.instantiate()
	
	projectile.dir = global_rotation 
	projectile.pos = global_position
	projectile.rota = global_rotation
	projectile.damage = damage
	projectile.lifetime = 10
	projectile.speed = 300 + 50*get_parent().player.dmgbuffcount
	projectile.pierce = 1
	projectile.hungry = hungry
	get_tree().current_scene.add_child(projectile)
	
	
	# projectile.damage = i can change the value of the projectile damage as it leaves the barrel
