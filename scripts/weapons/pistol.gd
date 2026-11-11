extends CharacterBody2D
var projectile_path=preload("res://scenes/projectile.tscn")


func _physics_process(delta):
	if Input.is_action_pressed("click"):
		get_parent()._try_use()

func use(damage):
	var projectile = projectile_path.instantiate()
	
	projectile.dir = global_rotation 
	projectile.pos = global_position
	projectile.rota = global_rotation
	projectile.damage = damage
	
	get_tree().current_scene.add_child(projectile)
	
	
	# projectile.damage = i can change the value of the projectile damage as it leaves the barrel
