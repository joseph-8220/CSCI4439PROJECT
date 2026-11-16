extends Node2D
var pos: Vector2
var rota: float
var dir: float
@export var speed: float = 90
var damage: int = 1
var lifetime: float
var timer: float = 0.0
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
	if body.is_in_group("player"):
		body.damage(damage)
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		if area.hungry:
			queue_free()
