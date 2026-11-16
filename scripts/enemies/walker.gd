extends CharacterBody2D


@onready var player_node: CharacterBody2D = get_parent().get_node("player")
@export var speed: float
@export var enemyhealth: int
@export var damage: int
@onready var deadnoise: AudioStreamPlayer2D = $deadnoise

func _ready():
	speed = 80*pow(1.02, get_tree().get_first_node_in_group("main").wave - 1)
	enemyhealth = 3 + floor((get_tree().get_first_node_in_group("main").wave - 1)/2)
	damage = 1
	get_parent().enemycount += 1
	
func _physics_process(delta):
	if get_tree().get_first_node_in_group("player").dead:
		return
	if get_tree().paused:
		return
	if enemyhealth < 1:
		death()
	var direction = (player_node.global_position - global_position).normalized()
	var target_angle = direction.angle()
	rotation = lerp_angle(rotation, target_angle, 30 * delta)
	velocity = speed * direction
	move_and_slide()

func death():
	var parent = get_parent()
	remove_child(deadnoise)
	parent.add_child(deadnoise)
	deadnoise.pitch_scale = randf_range(0.6, 1)
	deadnoise.global_position = global_position
	deadnoise.play()
	deadnoise.finished.connect(deadnoise.queue_free)
	var player = get_tree().get_first_node_in_group("player")
	var world = get_tree().get_first_node_in_group("main")
	queue_free()
	get_parent().enemycount -= 1
	player.money = player.money + 5
	player.score += 10
	world.mobsdefeated += 1
	print(world.mobsdefeated)
