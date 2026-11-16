extends CharacterBody2D
var projectile_path=preload("res://scenes/enemyprojectile.tscn")
@onready var player_node: CharacterBody2D = get_parent().get_node("player")
@export var speed: float
@export var enemyhealth: int
@export var damage: int
@export var firerate: float
@export var projectilespeed: float
@onready var deadnoise: AudioStreamPlayer2D = $deadnoise

var scattering: bool
var timer: float = 0.0
func _ready():
	speed = 60
	enemyhealth = 2 + floor((get_tree().get_first_node_in_group("main").wave - 1)/4)
	damage = 1
	firerate = 1.7*pow(.99, get_tree().get_first_node_in_group("main").wave - 1)
	get_parent().enemycount += 1
	
func _physics_process(delta):
	if get_tree().get_first_node_in_group("player").dead:
		return
	if get_tree().paused:
		return
	if enemyhealth < 1:
		death()
		return
	var direction = (player_node.global_position - global_position).normalized()
	global_rotation = direction.angle()
	if scattering:
		velocity = -direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		timer += delta
		if timer >= firerate:
			fire()
			timer = 0
	var target_angle = direction.angle()
	if global_position.x < -165:
		global_position.x = -165
	elif global_position.x > 165:
		global_position.x = 165
	if global_position.y < -90:
		global_position.y = -90
	elif global_position.y > 90:
		global_position.y = 90

func death():
	var player = get_tree().get_first_node_in_group("player")
	var world = get_tree().get_first_node_in_group("main")
	remove_child(deadnoise)
	get_parent().add_child(deadnoise)
	deadnoise.pitch_scale = randf_range(1.4, 1.6)
	deadnoise.global_position = global_position
	deadnoise.play()
	deadnoise.finished.connect(deadnoise.queue_free)
	queue_free()
	get_parent().enemycount -= 1
	player.money = player.money + 10
	player.score += 20
	world.mobsdefeated += 1
	print(world.mobsdefeated)


func fire():
	var projectile = projectile_path.instantiate()
	
	projectile.dir = global_rotation 
	projectile.pos = global_position
	projectile.rota = global_rotation
	projectile.damage = damage
	projectile.lifetime = 10
	projectile.speed = 130*pow(1.04, get_tree().get_first_node_in_group("main").wave - 1)
	get_tree().current_scene.add_child(projectile)


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		scattering = true



func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		scattering = false
