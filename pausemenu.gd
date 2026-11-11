extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func resume():
	get_tree().paused = false
	#$AnimationPlayer.play_backwards("obfus")
	#await $AnimationPlayer.animation_finished
	if not get_tree().paused:
		hide()

func pause():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("obfus")


func testEsc():
	if Input.is_action_just_pressed("escape"):
		print("escape pressed")
		if get_tree().paused:
			resume()
		else:
			pause()



func _on_resume_button_pressed() -> void:
	resume()


func _on_restart_button_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _process(delta):
	testEsc()
