extends Node2D

@export var wave: int = 0
@export var intermission: bool = true
var player: Node2D
var shop: Control
var mobstospawn: int = 6
var enemycount: int = 0
var enemy_walker = preload("res://scenes/walker.tscn")
var spawn_time: float = 1.5
var done_spawning: bool = false
var spawning: bool = false
var mobsdefeated: int = 0
# Upon loading into the game, the player must press a key (not sure yet) 
func _ready() -> void:
	get_tree().paused = true
	onwaveup()
	player = get_tree().get_first_node_in_group("player")
	shop = get_tree().get_first_node_in_group("shop")


func onwaveup():
	if wave%3 == 0 and wave != 0:
		pass
	mobstospawn = roundi(6 * pow(1.6, wave - 1))
	if spawn_time > .3:
		spawn_time -= 0.15
	print("spawn_time is now " , spawn_time)
	print("mobstospawn is now ", mobstospawn)

func loadwave():
	if spawning:
		return
	if not intermission:
		done_spawning = false
		wave += 1
		spawning = false
		for i in mobstospawn:
			if get_tree().get_first_node_in_group("player").dead:
				break
			spawnenemy()
			await get_tree().create_timer(spawn_time, false).timeout
		spawning = false
		done_spawning = true

func waveclearcheck() -> bool:
	if get_enemy_count() == 0 and done_spawning:
		var player = get_tree().get_first_node_in_group("player")
		player.money += 10
		player.playerhealth = player.maxhealth
		mobsdefeated = 0
		return true
	return false

func get_enemy_count() -> int:
	var count := 0
	for child in get_children():
		if child.is_in_group("enemy"):
			count += 1
	return count
	
func openshop():
	pass

func death():
	print("player died")
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and intermission:
		intermission = false
		print("out of intermission")
		loadwave()
	if not intermission and waveclearcheck():
		intermission = true
		shop.rollshop()
		onwaveup()
	

func spawnenemy():
	var enemy_position = Vector2(randi_range(-170, 170), randi_range(-90, 90))
	while  get_tree().get_first_node_in_group("player").global_position.distance_to(enemy_position) < 100:
		enemy_position = Vector2(randi_range(-170, 170), randi_range(-90, 90))
	var new_enemy = enemy_walker.instantiate()
	new_enemy.global_position = enemy_position
	add_child(new_enemy)
	print("enemy spawned at ", enemy_position, ", enemy count ", enemycount)
