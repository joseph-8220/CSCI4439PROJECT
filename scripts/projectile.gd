extends CharacterBody2D
var pos: Vector2
var rota: float
var dir: float
@export var speed = 300
@export var damage = 1

func _ready():
	global_position=pos
	global_rotation=rota
func _physics_process(delta):
	for index in get_slide_collision_count():
			var collision = get_slide_collision(index)
			if collision.get_collider().is_in_group("enemy"):
				collision.get_collider().enemyhealth = collision.get_collider().enemyhealth - damage
				print("enemy took ", damage, " damage")
				queue_free()
				break;
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
