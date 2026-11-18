extends Node2D
var pos: Vector2
var rota: float
var dir: float
@export var speed: float = 300
var damage: int
var lifetime: float
var timer: float = 0.0
var pierce: int = 1
var hungry: bool
var hit_list: Array = []
@onready var hitsound: AudioStreamPlayer2D = $hitsound

func _ready():
	global_position=pos
	global_rotation=rota
func _physics_process(delta):
	timer += delta
	if timer >= lifetime:
		queue_free()
	var lifetimecheck: float = Time.get_unix_time_from_system()
	if lifetimecheck - Time.get_unix_time_from_system()  >= lifetime:
		queue_free()
	if abs(global_position.x) > 176 or abs(global_position.y) > 96:
		queue_free()
	position += Vector2(speed, 0).rotated(dir) * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body in hit_list:
			return
			hit_list.append(body)
		if is_instance_valid(hitsound):
			var sound_copy = hitsound.duplicate()
			get_parent().add_child(sound_copy)
			sound_copy.global_position = global_position
			sound_copy.play()
			sound_copy.finished.connect(sound_copy.queue_free)
		body.enemyhealth -= damage
		pierce -= 1
		if pierce <= 0:
			queue_free()
	
