extends Node2D

@export var wave: int = 1
@export var intermission: bool = true
var enemycount: int
var enemy_walker = preload("res://scenes/walker.tscn")
# Upon loading into the game, the player must press a key (not sure yet) 
func _ready() -> void:
	get_tree().paused = true
	enemycount = 0

func loadwave():
	pass

func waveclearcheck():
	if get_child_count() < 1:
		wave = wave + 1
		intermission = true
	pass

func openshop():
	pass

func death():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_wavespawner_timeout() -> void:
	
	var enemy_position = Vector2(randi_range(-170, 170), randi_range(-90, 90))
	while  get_tree().get_first_node_in_group("player").global_position.distance_to(enemy_position) < 100:
		enemy_position = Vector2(randi_range(-170, 170), randi_range(-90, 90))
	var new_enemy = enemy_walker.instantiate()
	new_enemy.global_position = enemy_position
	add_child(new_enemy)
	print("enemy spawned at ", enemy_position, ", enemy count ", enemycount)
