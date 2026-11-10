extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_start_pressed() -> void:
	$TextureRect.hide()
	$buttonmanager.hide()
	get_tree().paused = false



func _on_quit_pressed() -> void:
	get_tree().quit()
