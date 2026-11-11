extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_start_pressed() -> void:
	$TextureRect.hide()
	$buttonmanager.hide()
	get_tree().paused = false
	set_process(false)

func _process(delta):
	if Input.is_action_just_pressed("escape") and get_tree().paused:
		_on_start_pressed()


func _on_quit_pressed() -> void:
	get_tree().quit()
