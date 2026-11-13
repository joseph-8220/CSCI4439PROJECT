extends CharacterBody2D
var projectile_path=preload("res://scenes/projectile.tscn")
var weaponid = 3
var fire_rate = 0.15
var damage = 1

func checkStats():
	fire_rate = .005 - (.001 - .15)*pow(0.8, get_parent().player.dmgbuffcount)
	
	get_parent().fire_rate = fire_rate
	get_parent().damage = damage
	$"../Sprite2D".frame = 4
	
func use(damage):
	var projectile = projectile_path.instantiate()
	
	projectile.dir = global_rotation 
	projectile.pos = global_position
	projectile.rota = global_rotation
	projectile.damage = damage
	projectile.speed = 300 + 20*get_parent().player.dmgbuffcount
	get_tree().current_scene.add_child(projectile)
	
	
