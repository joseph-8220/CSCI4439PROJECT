extends Control

@onready var click: AudioStreamPlayer2D = $click
var player: Node2D
var world: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	world = get_tree().get_first_node_in_group("main")
	hide()



func _process(delta: float) -> void:
	pass

func win():
	var weap: String
	match player.weaponid:
		1:
			weap = "Pistol"
		2:
			weap = "Shotgun"
		3:
			weap = "Machine Gun"
		4:
			weap = "Crossbow"
		_:
			weap = "What?"
	$StatLabel.text = "SCORE: " + str(player.score) + "\nWEAPON: " + weap
	show()
	click.play()
	get_tree().paused = true
	# play win sound effect if i feel like finding one



func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	hide()
	click.play()
	


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
