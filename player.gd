extends CharacterBody2D

@export var speed = 120

func get_input():
	look_at(get_global_mouse_position())
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if Input.is_action_pressed('click'):
		print("projectile fired")
	
func _physics_process(delta):
	get_input()
	move_and_slide()
