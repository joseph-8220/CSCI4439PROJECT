extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("player")
@export var speed: float
@export var enemyhealth: int
@export var damage: int
func _ready():
	enemyhealth = 3
	speed = 80
	damage = 1

func _physics_process(delta):
	if get_tree().paused:
		return
	if enemyhealth < 1:
		death()
	var direction = (player_node.global_position - global_position).normalized()
	velocity = lerp(velocity, direction * speed, 8.5*delta)
	move_and_slide()

func death():
	var player = get_tree().get_first_node_in_group("player")
	queue_free()
	player.money = player.money + 5
	print(player.money)
