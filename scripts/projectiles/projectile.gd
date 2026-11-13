extends CharacterBody2D
var pos: Vector2
var rota: float
var dir: float
@export var speed: float = 300
var damage: int

func _ready():
	global_position=pos
	global_rotation=rota
func _physics_process(delta):
	for index in get_slide_collision_count():
			var collision = get_slide_collision(index)
			if is_instance_valid(collision.get_collider()):
				if collision.get_collider().is_in_group("enemy"):
					collision.get_collider().enemyhealth = collision.get_collider().enemyhealth - damage
					print("enemy took ", damage, " damage")
					queue_free()
					break;
	if abs(global_position.x) > 176 or abs(global_position.y) > 96:
		queue_free()
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
