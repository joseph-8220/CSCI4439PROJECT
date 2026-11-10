extends CharacterBody2D
var projectile_path=preload("res://scenes/projectile.tscn")


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		use()

func use():
	var projectile = projectile_path.instantiate()
	
	projectile.dir = global_rotation 
	projectile.pos = global_position
	projectile.rota = global_rotation
	
	get_tree().current_scene.add_child(projectile)
