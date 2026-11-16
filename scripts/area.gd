extends Node2D

@export var wave: int = 0
@export var intermission: bool = true
var player: Node2D
var shop: Control
var mobstospawn: int = 6
var enemycount: int = 0
var enemy_walker = preload("res://scenes/walker.tscn")
var enemy_shooter = preload("res://scenes/eyeball.tscn")
var spawn_time: float = 1.5
var done_spawning: bool = false
var spawning: bool = false
var mobsdefeated: int = 0
var game_over_shown: bool = false
var game_over_layer: CanvasLayer
# Upon loading into the game, the player must press a key (not sure yet) 
func _ready() -> void:
	get_tree().paused = true
	onwaveup()
	player = get_tree().get_first_node_in_group("player")
	shop = get_tree().get_first_node_in_group("shop")
	_build_game_over_screen()


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
		player.money += 15
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
	if game_over_shown:
		return
	game_over_shown = true
	$GameOverLayer/GameOverPanel/Center/Content/Stats.text = "WAVE REACHED: %d\nSCORE: %d" % [wave, player.score]
	$GameOverLayer/GameOverPanel.show()
	get_tree().paused = true

# A basic end screen. Kept in one script so it is easy to edit later.
func _build_game_over_screen():
	game_over_layer = CanvasLayer.new()
	game_over_layer.name = "GameOverLayer"
	game_over_layer.layer = 20
	game_over_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(game_over_layer)

	var panel = ColorRect.new()
	panel.name = "GameOverPanel"
	panel.color = Color(0.05, 0.05, 0.07, 0.94)
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.offset_left = 0
	panel.offset_top = 0
	panel.offset_right = 0
	panel.offset_bottom = 0
	panel.visible = false
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	game_over_layer.add_child(panel)

	# Fill the viewport, then center the menu inside it.
	# This keeps the screen centered at different window sizes.
	var center = CenterContainer.new()
	center.name = "Center"
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.add_child(center)

	var content = VBoxContainer.new()
	content.name = "Content"
	content.custom_minimum_size = Vector2(300, 260)
	content.add_theme_constant_override("separation", 16)
	center.add_child(content)

	var title = Label.new()
	title.text = "GAME OVER"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 42)
	content.add_child(title)

	var stats = Label.new()
	stats.name = "Stats"
	stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats.add_theme_font_size_override("font_size", 22)
	content.add_child(stats)

	var restart = Button.new()
	restart.text = "TRY AGAIN"
	restart.custom_minimum_size.y = 48
	restart.pressed.connect(_restart_game)
	content.add_child(restart)

	var quit = Button.new()
	quit.text = "QUIT GAME"
	quit.custom_minimum_size.y = 48
	quit.pressed.connect(_quit_game)
	content.add_child(quit)

func _restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _quit_game():
	get_tree().quit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not game_over_shown and Input.is_action_just_pressed("ui_accept") and intermission:
		intermission = false
		print("out of intermission")
		loadwave()
	if not game_over_shown and not intermission and waveclearcheck():
		intermission = true
		shop.rollshop()
		onwaveup()
	

func spawnenemy():
	var enemy_position = Vector2(randi_range(-170, 170), randi_range(-90, 90))
	while  get_tree().get_first_node_in_group("player").global_position.distance_to(enemy_position) < 100:
		enemy_position = Vector2(randi_range(-170, 170), randi_range(-90, 90))
	var new_enemy: Node2D
	if randi() % 8 == 0:
		new_enemy = enemy_shooter.instantiate()
	else:
		new_enemy = enemy_walker.instantiate()
	new_enemy.global_position = enemy_position
	add_child(new_enemy)
	print("enemy spawned at ", enemy_position, ", enemy count ", enemycount)
